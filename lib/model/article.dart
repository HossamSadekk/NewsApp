import 'package:news/model/source.dart';

class Article {
  String? author;
  String? title;
  String? description;
  String? url;
  String? img;
  String? date;
  String? content;
  Source? source;

  Article(this.author, this.title, this.description, this.url, this.img,
      this.date, this.content);

  Article.fromJson(Map<String, dynamic> json) {
    author = json["author"];
    title = json["title"];
    description = json["description"];
    url = json["url"];
    img = json["urlToImage"];
    img = json["urlToImage"];
    date = json["publishedAt"];
    content = json["content"];
    source = Source.fromJson(json["source"]);
  }
}
