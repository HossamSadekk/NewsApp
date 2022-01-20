import 'package:news/model/sources_response.dart';
import 'package:news/repository/news_repository.dart';
import 'package:rxdart/rxdart.dart';

class SourcesBloc {
  NewsRepository _newsRepository = NewsRepository();
  BehaviorSubject<SourceResponse> _subject = BehaviorSubject();

  getSources() async {
    SourceResponse sourceResponse = await _newsRepository.getSources();
    _subject.sink.add(sourceResponse);
  }

  BehaviorSubject<SourceResponse> get subject => _subject;

  dispose() {
    _subject.close();
  }
}

final getSourcesBloc = SourcesBloc();
