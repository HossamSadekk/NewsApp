import 'article.dart';

class ArticleResponse {
  List<Article>? articles;

  ArticleResponse(this.articles);

  ArticleResponse.fromJson(Map<String, dynamic> json) {
    articles =
        (json["articles"] as List).map((i) => Article.fromJson(i)).toList(); // the response return a List<dynamic> we will use map() to change every dynamic item of list into tag object of dynamic into list of article
  }                                                                          // you must add toList() to convert from Iterable to List
}
