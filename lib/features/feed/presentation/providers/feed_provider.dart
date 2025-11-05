import 'package:flutter/material.dart';
import 'package:animeto_app/core/errors/exceptions.dart';
import 'package:animeto_app/features/feed/domain/entities/publication.dart';
import 'package:animeto_app/features/feed/domain/repositories/publication_repository.dart';
import 'package:animeto_app/features/feed/domain/repositories/reaction_repository.dart';
import 'package:animeto_app/features/feed/domain/constants/reaction_constants.dart';

enum FeedState { initial, loading, loaded, error }

class FeedProvider extends ChangeNotifier {
  final PublicationRepository publicationRepository;
  final ReactionRepository reactionRepository;

  FeedProvider({
    required this.publicationRepository,
    required this.reactionRepository,
  });

  FeedState _state = FeedState.initial;
  FeedState get state => _state;

  List<Publication> _publications = [];
  List<Publication> get publications => _publications;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchPublications() async {
    _state = FeedState.loading;
    notifyListeners();

    try {
      _publications = await publicationRepository.getPublications(1, 10);
      _state = FeedState.loaded;
    } on ServerException catch (e) {
      _errorMessage = e.message;
      _state = FeedState.error;
    }
    notifyListeners();
  }

  Future<bool> reactToPublication(String publicationId, String type) async {
    try {
      final reaction = await reactionRepository.createReaction(
        type: type,
        target: ReactionTargets.post,
        postId: publicationId,
      );

      final index = _publications.indexWhere((p) => p.id == publicationId);
      if (index != -1) {
        // La API maneja el toggle automático:
        // - Si existe reacción del mismo tipo: se elimina (toggle off)
        // - Si existe pero es diferente tipo: se actualiza
        // - Si no existe: se crea nueva
        
        // Limpiar reacciones previas del usuario actual y agregar la nueva
        // (o ninguna si fue eliminada por el toggle)
        _publications[index].reactions.removeWhere((r) => r.userId == reaction.userId);
        
        // Si la reacción no es nula (no fue eliminada por toggle), agregarla
        if (reaction.type.isNotEmpty) {
          _publications[index].reactions.add(reaction);
        }
        
        notifyListeners();
      }
      return true;
    } on ServerException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }
}