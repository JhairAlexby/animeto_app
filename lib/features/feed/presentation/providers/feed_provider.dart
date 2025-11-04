import 'package:flutter/material.dart';
import 'package:animeto_app/core/errors/exceptions.dart';
import 'package:animeto_app/features/feed/domain/entities/publication.dart';
import 'package:animeto_app/features/feed/domain/repositories/publication_repository.dart';

enum FeedState { initial, loading, loaded, error }

class FeedProvider extends ChangeNotifier {
  final PublicationRepository publicationRepository;

  FeedProvider({required this.publicationRepository});

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
}