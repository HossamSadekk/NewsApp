import 'package:dio/dio.dart';
import 'package:news/model/article_response.dart';
import 'package:news/model/sources_response.dart';

class NewsRepository
{
  static String mainUrl = "https://newsapi.org/v2/";
  final String apiKey = "a634077a5aab4c1f8673049d418f6bea";

  Dio dio = Dio();


  var getTopHeadlinesUrl = "$mainUrl/top-headlines";
  var everythingUrl = "$mainUrl/everything";
  var getSourcesUrl = "$mainUrl/sources";

  Future<ArticleResponse> getTopHeadlines() async {
    var params = {
      "apiKey":apiKey,
      "country":"us"
    };

      Response response = await dio.get(getTopHeadlinesUrl,queryParameters: params);
      return ArticleResponse.fromJson(response.data);

  }

  Future<SourceResponse> getSources() async {
    var params = {
      "apiKey":apiKey,
      "language":"en",
      "country":"us"
    };

    Response response = await dio.get(getSourcesUrl,queryParameters: params);
    return SourceResponse.fromJson(response.data);

  }

  Future<ArticleResponse> getHotNews() async {
    var params = {
      "apiKey":apiKey,
      "q":"apple",
      "sortBy":"popularity"
    };

    Response response = await dio.get(everythingUrl,queryParameters: params).catchError((error){print(error.toString()+"-----+---+--+--+");});
    return ArticleResponse.fromJson(response.data);
  }

  Future<ArticleResponse> getSourceNews(String sourceId) async {
    var params = {
      "apiKey":apiKey,
      "sources":sourceId
    };

    Response response = await dio.get(getTopHeadlinesUrl,queryParameters: params);
    return ArticleResponse.fromJson(response.data);

  }

  Future<ArticleResponse> search(String searchValue) async {
    var params = {
      "apiKey":apiKey,
      "q": searchValue
    };

    Response response = await dio.get(getTopHeadlinesUrl,queryParameters: params);
    return ArticleResponse.fromJson(response.data);

  }
}