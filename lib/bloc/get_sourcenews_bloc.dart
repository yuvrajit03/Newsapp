import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../models/articals_responce.dart';
import '../repository/repository.dart';

class GetSourceNewsBloc {
  final NewsRepository _repository = NewsRepository();
  final BehaviorSubject<ArticleResponse> _subject =
      BehaviorSubject<ArticleResponse>();

  getSourceNews(String sourceId) async {
    ArticleResponse response = await _repository.getSourceNews(sourceId);
    _subject.sink.add(response);
  }

  void drainStream() {
    _subject.value = Null as ArticleResponse;
  }

  @mustCallSuper
  void dispose() async {
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<ArticleResponse> get subject => _subject;
}

final getSourceNewsBloc = GetSourceNewsBloc();
