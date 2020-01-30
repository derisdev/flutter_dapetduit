import 'dart:convert';
import 'package:dapetduit/helper/dbhelper.dart';
import 'package:dapetduit/helper/dbhelperFeedback.dart';
import 'package:dapetduit/helper/dbhelperNotif.dart';
import 'package:dapetduit/helper/dbhelperOfferwall.dart';
import 'package:dapetduit/helper/dbhelperPayment.dart';
import 'package:dapetduit/model/OfferwallModel.dart';
import 'package:dapetduit/model/feedbackModel.dart';
import 'package:dapetduit/model/historyModel.dart';
import 'package:dapetduit/model/notifModel.dart';
import 'package:dapetduit/model/paymentModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FetchData {

  
  Future readOfferwall() async {
    String baseUrl =
        "https://duitrest.000webhostapp.com/api/v1/offerwall";
    var response = await http.get(baseUrl,
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData['offerwall'] as List).map((offerwall) {
      print('Inserting $offerwall');
      DBHelperOfferwall.db.createOfferwall(OfferwallModel.fromJson(offerwall));
    }).toList();
    }
    print(response.statusCode);
    print(response.body);
  }


  Future createRefferal(
      String refferalCode, int userid, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String baseUrl =
        "https://duitrest.000webhostapp.com/api/v1/refferal?token=$token";
    var response = await http.post(baseUrl,
        headers: {"Accept": "application/json"},
        body: {'refferal': refferalCode, 'user_id': userid.toString()});
    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      int refferalId = jsonData['refferal']['id'];

      prefs.setString('refferal_id', refferalId.toString());
    }
    print(response.statusCode);
    print(response.body);
  }

  Future readRefferal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String refferalId = prefs.getString('refferal_id');

    String baseUrl =
        "https://duitrest.000webhostapp.com/api/v1/refferal/$refferalId";
    var response =
        await http.get(baseUrl, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      String invited = jsonData['refferal']['invited'];

      prefs.setString('invited', invited);
    }
    print(response.statusCode);
    print(response.body);
  }

  Future createRewards(int userId, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String baseUrl =
        "https://duitrest.000webhostapp.com/api/v1/rewards?token=$token";
    var response = await http.post(baseUrl,
        headers: {"Accept": "application/json"},
        body: {'rewards': '0', 'user_id': userId.toString()});
    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      int rewardsId = jsonData['rewards']['id'];

      prefs.setString('rewards_id', rewardsId.toString());
    }
    print(response.statusCode);
    print(response.body);
  }

  Future updateRewards(String rewards) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String rewardsId = prefs.getString('rewards_id');
    String refferalCodeRefferal = prefs.getString('refferal_code_refferer');

    String baseUrl =
        "https://duitrest.000webhostapp.com/api/v1/rewards/$rewardsId?token=$token";
    var response = await http.post(baseUrl,
        headers: {"Accept": "application/json"},
        body: {'rewards': rewards, 'refferal': refferalCodeRefferal,'_method': 'PATCH'});
    if (response.statusCode == 200) {
      print('rewards updated');
    }
    print(response.statusCode);
    print(response.body);
  }

  

  Future readRewards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String rewardsId = prefs.getString('rewards_id');
    int currentCoin = prefs.getInt('coin');

    String baseUrl =
        "https://duitrest.000webhostapp.com/api/v1/rewards/$rewardsId";
    var response = await http.get(baseUrl,
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      int newRewards = jsonData['rewards']['rewards'];
      if(newRewards > currentCoin) {
      prefs.setInt('coin', newRewards);
      DbHelper dbHelper = DbHelper();

  DateTime now = DateTime.now();
  String formattedDate = DateFormat('EEE d MMM').format(now);

  HistoryModel historyModel =
      HistoryModel(formattedDate, 'Refferal', '+$newRewards-$currentCoin');
  await dbHelper.insert(historyModel);

  print('object created');
      }
    }
    print(response.statusCode);
    print(response.body);
  }

  

  Future phoneVerify(String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id');

    String baseUrl =
        "https://duitrest.000webhostapp.com/api/v1/user/phone_verify";
    var response = await http.post(baseUrl,
        headers: {"Accept": "application/json"},
        body: {'user_id': userId.toString(), 'phone': phone});
    if (response.statusCode == 201) {
       Fluttertoast.showToast(
          msg:
          'Nomor di tambahkan',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 14.0,
          backgroundColor: Colors.grey,
          textColor: Colors.white);

        prefs.setString('phone', phone);
    }
    else {
      Fluttertoast.showToast(
          msg:
          'Terjadi Kesalahan saat menambahan Nomor Telpon',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 14.0,
          backgroundColor: Colors.grey,
          textColor: Colors.white);
    }
    print(response.statusCode);
    print(response.body);
  }


  
  Future createPayment(String via, String amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt('user_id');
    String phone = prefs.getString('phone');

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM').format(now);

    String baseUrl =
        "https://duitrest.000webhostapp.com/api/v1/payment?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjEsImlzcyI6Imh0dHBzOi8vZHVpdHJlc3QuMDAwd2ViaG9zdGFwcC5jb20vYXBpL3YxL3VzZXIvcmVnaXN0ZXIiLCJpYXQiOjE1ODAzMDAzMTIsImV4cCI6MTU4MDMwMzkxMiwibmJmIjoxNTgwMzAwMzEyLCJqdGkiOiJ6eTNsZkN0UUNvZ0ZpYVV1In0.hMGLokgjePJAr_2f8pvFOVvA63-r6YIKjarD4cZm6fA";
    var response = await http.post(baseUrl,
        headers: {"Accept": "application/json"},
        body: {
          'user_id': userId.toString(), 
          'phone': phone, 
          'via' : via,
          'amount' : amount,
          'status' : 'Pending',
          'time' : formattedDate
          });
    if (response.statusCode == 201) {
      print('Payment created');
    }
    print(response.statusCode);
    print(response.body);
  }
 
 
  Future readPayment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString('phone');

    String baseUrl =
        "https://duitrest.000webhostapp.com/api/v1/user/payment/$phone";
    var response = await http.get(baseUrl,
        headers: {"Accept": "application/json"},);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData['payment'] as List).map((payment) {
      print('Inserting $payment');
      DBHelperPayment.db.createPayment(Payment.fromJson(payment));
    }).toList();
    }
    print(response.statusCode);
    print(response.body);
  }


  Future readNotif() async {

    String baseUrl =
        "https://duitrest.000webhostapp.com/api/v1/notif";
    var response = await http.get(baseUrl,
        headers: {"Accept": "application/json"},);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData['notif'] as List).map((notif) {
      print('Inserting $notif');
      DBHelperNotif.db.createNotif(Notif.fromJson(notif));
    }).toList();
    }
    print(response.statusCode);
    print(response.body);
  }

  Future readFeedback() async {

    String baseUrl =
        "https://duitrest.000webhostapp.com/api/v1/feedback";
    var response = await http.get(baseUrl,
        headers: {"Accept": "application/json"},);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData['feedback'] as List).map((feedback) {
      print('Inserting $feedback');
      DBHelperFeedback.db.createFeedback(FeedbackModel.fromJson(feedback));
    }).toList();
    }
    print(response.statusCode);
    print(response.body);
  }


  Future createQuestion(String title, String category, String description, String screenshot) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString('phone');

    String baseUrl =
        "https://duitrest.000webhostapp.com/api/v1/question";
    var response = await http.post(baseUrl,
        headers: {"Accept": "application/json"},
        body: {
          'phone': phone, 
          'title' : title,
          'category' : category,
          'description' : description,
          'screenshot' : screenshot
          });
    if (response.statusCode == 201) {
      print('Ques created');
    }
    print(response.statusCode);
    print(response.body);
  }
 



}
