import 'dart:convert';

List<Payment> paymentFromJson(String str) =>
    List<Payment>.from(json.decode(str).map((x) => Payment.fromJson(x)));

String paymentToJson(List<Payment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Payment {
  int id;
  String via;
  String amount;
  String status;
  String time;

  Payment({
    this.id,
    this.via,
    this.amount,
    this.status,
    this.time,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        via: json["via"],
        amount: json["amount"],
        status: json["status"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "via": via,
        "amount": amount,
        "status": status,
        "time": time,
      };
}