import 'dart:convert';

List<Notif> notifFromJson(String str) =>
    List<Notif>.from(json.decode(str).map((x) => Notif.fromJson(x)));

String notifToJson(List<Notif> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Notif {
  int id;
  String title;
  String time;
  String description;

  Notif({
    this.id,
    this.title,
    this.time,
    this.description,
  });

  factory Notif.fromJson(Map<String, dynamic> json) => Notif(
        id: json["id"],
        title: json["title"],
        time: json["time"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "time": time,
        "description": description,
      };
}