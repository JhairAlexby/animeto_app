import 'package:flutter/material.dart';
import 'package:animeto_app/core/errors/exceptions.dart';
import 'package:animeto_app/features/feed/domain/entities/publication.dart';
import 'package:animeto_app/features/feed/domain/repositories/publication_repository.dart';
import 'package:animeto_app/features/feed/domain/repositories/reaction_repository.dart';
import 'package:animeto_app/features/feed/domain/constants/reaction_constants.dart';
import 'package:animeto_app/features/feed/domain/entities/comment.dart';

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
        _publications[index].reactions.removeWhere((r) => r.userId == reaction.userId);
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

  Future<bool> createPost({
    required String description,
    required String type,
    int? currentChapters,
    List<String>? tags,
    String? imagePath,
  }) async {
    try {
      final newPublication = await publicationRepository.createPost(
        description: description,
        type: type,
        currentChapters: currentChapters,
        tags: tags,
        imagePath: imagePath,
      );
      _publications.insert(0, newPublication);
      notifyListeners();
      return true;
    } on ServerException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> createComment(
      {required String content, required String postId, String? parentId}) async {
    try {
      final newComment = await publicationRepository.createComment(
        content: content,
        postId: postId,
        parentId: parentId,
      );

      final index = _publications.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _publications[index].comments.insert(0, newComment);
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
