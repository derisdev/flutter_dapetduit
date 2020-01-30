import 'dart:convert';

List<FeedbackModel> feedbackFromJson(String str) =>
    List<FeedbackModel>.from(json.decode(str).map((x) => FeedbackModel.fromJson(x)));

String feedbackToJson(List<FeedbackModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FeedbackModel {
  int id;
  String question;
  String answer;

  FeedbackModel({
    this.id,
    this.question,
    this.answer,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
      };
}