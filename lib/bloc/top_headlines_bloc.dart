import 'package:news/model/article_response.dart';
import 'package:news/repository/news_repository.dart';
import 'package:rxdart/rxdart.dart';

class TopHeadlinesBloc {
  NewsRepository _newsRepository = NewsRepository();
  BehaviorSubject<ArticleResponse> _subject =
  BehaviorSubject(); // it emitted the last value , this helpful when our widget change it's state

  getHeadlines() async {
    ArticleResponse articleResponse = await _newsRepository.getTopHeadlines();
    _subject.sink.add(articleResponse);
  }

  BehaviorSubject<ArticleResponse> get subject => _subject;

  dispose() {
    _subject.close();
  }
}

final getTopHeadlinesBloc = TopHeadlinesBloc();