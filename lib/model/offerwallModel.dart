import 'dart:convert';

List<OfferwallModel> offerwallFromJson(String str) =>
    List<OfferwallModel>.from(json.decode(str).map((x) => OfferwallModel.fromJson(x)));

String offerwallToJson(List<OfferwallModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OfferwallModel {
  int id;
  String icon;
  String title;
  String image;
  String description;
  String coin;

  OfferwallModel({
    this.id,
    this.icon,
    this.title,
    this.image,
    this.description,
    this.coin
  });

  factory OfferwallModel.fromJson(Map<String, dynamic> json) => OfferwallModel(
        id: json["id"],
        icon: json["icon"],
        title: json["title"],
        image: json["image"],
        description: json["description"],
        coin: json["coin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "icon": icon,
        "title": title,
        "image": image,
        "description": description,
        "coin": coin,
      };
}