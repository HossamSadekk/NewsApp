import 'package:news/model/source.dart';

class SourceResponse{
   List<Source>? sources;

  SourceResponse(this.sources);

  SourceResponse.fromJson(Map<String,dynamic> json){
    sources = (json["sources"] as List).map((i) => Source.fromJson(i)).toList();
  }
}