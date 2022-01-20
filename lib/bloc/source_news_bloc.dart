import 'package:news/model/article_response.dart';
import 'package:news/repository/news_repository.dart';
import 'package:rxdart/rxdart.dart';

class SourceNewsBloc {
  NewsRepository _newsRepository = NewsRepository();
  BehaviorSubject<ArticleResponse> _subject = BehaviorSubject();

  getSourceNews(String sourceId) async {
    ArticleResponse response = await _newsRepository.getSourceNews(sourceId);
    _subject.sink.add(response);
  }

  BehaviorSubject<ArticleResponse> get subject => _subject;

  dispose() {
    _subject.close();
  }
}

final getSourceNewsBloc = SourceNewsBloc();
