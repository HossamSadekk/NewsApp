class Source {
  String? id;
  String? name;
  String? description;
  String? url;
  String? category;
  String? country;
  String? language;

  Source(this.id, this.name);

  Source.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["description"];
    url = json["url"];
    category = json["category"];
    country = json["country"];
    language = json["language"];
  }
}
