import 'package:news/model/article_response.dart';
import 'package:news/repository/news_repository.dart';
import 'package:rxdart/rxdart.dart';

class HotNewsBloc {
  NewsRepository _newsRepository = NewsRepository();
  BehaviorSubject<ArticleResponse> _subject =
      BehaviorSubject(); // it emitted the last value , this helpful when pur widget change it's state

  getHotNews() async {
    ArticleResponse articleResponse = await _newsRepository.getHotNews();
    _subject.sink.add(articleResponse);
  }

  BehaviorSubject<ArticleResponse> get subject => _subject;

  dispose() {
    _subject.close();
  }
}

final getHotNews = HotNewsBloc();
