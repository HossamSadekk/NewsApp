import 'package:news/model/article_response.dart';
import 'package:news/repository/news_repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  NewsRepository _newsRepository = NewsRepository();
  BehaviorSubject<ArticleResponse> _subject = BehaviorSubject();

  search(String searchValue) async {
    ArticleResponse response = await _newsRepository.search(searchValue);
    _subject.sink.add(response);
  }

  BehaviorSubject<ArticleResponse> get subject => _subject;

  dispose(){
    _subject.close();
  }
}
final searchBloc = SearchBloc();
