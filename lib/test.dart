import 'package:dapetduit/service/fetchdata.dart';
import 'package:flutter/material.dart';

class TestClass extends StatefulWidget {
  @override
  _TestClassState createState() => _TestClassState();
}

class _TestClassState extends State<TestClass> {

  FetchData fetchData = new FetchData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('read offerwall'),
              onPressed: (){
                fetchData.readOfferwall();
              },
            ),
            RaisedButton(
              child: Text('create refferal'),
              onPressed: (){
                fetchData.createRefferal('dfs321', 3, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjEsImlzcyI6Imh0dHBzOi8vZHVpdHJlc3QuMDAwd2ViaG9zdGFwcC5jb20vYXBpL3YxL3VzZXIvcmVnaXN0ZXIiLCJpYXQiOjE1ODAzMDAzMTIsImV4cCI6MTU4MDMwMzkxMiwibmJmIjoxNTgwMzAwMzEyLCJqdGkiOiJ6eTNsZkN0UUNvZ0ZpYVV1In0.hMGLokgjePJAr_2f8pvFOVvA63-r6YIKjarD4cZm6fA');
              },
            ),
            RaisedButton(
              child: Text('read refferal'),
              onPressed: (){
                fetchData.readRefferal();
              },
            ),
            RaisedButton(
              child: Text('create rewards'),
              onPressed: (){
                fetchData.createRewards(3, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjEsImlzcyI6Imh0dHBzOi8vZHVpdHJlc3QuMDAwd2ViaG9zdGFwcC5jb20vYXBpL3YxL3VzZXIvcmVnaXN0ZXIiLCJpYXQiOjE1ODAzMDAzMTIsImV4cCI6MTU4MDMwMzkxMiwibmJmIjoxNTgwMzAwMzEyLCJqdGkiOiJ6eTNsZkN0UUNvZ0ZpYVV1In0.hMGLokgjePJAr_2f8pvFOVvA63-r6YIKjarD4cZm6fA');
              },
            ),
            RaisedButton(
              child: Text('update rewards'),
              onPressed: (){
                fetchData.updateRewards('10');
              },
            ),
            RaisedButton(
              child: Text('phone verify'),
              onPressed: (){
                fetchData.phoneVerify('085719632945');
              },
            ),
            RaisedButton(
              child: Text('create payment'),
              onPressed: (){
                fetchData.createPayment('DANA', 'IDR 10.000', '21 Januari 2020');
              },
            ),
            RaisedButton(
              child: Text('read payment'),
              onPressed: (){
                fetchData.readPayment();
              },
            ),
            RaisedButton(
              child: Text('read notif'),
              onPressed: (){
                fetchData.readNotif();
              },
            ),
            RaisedButton(
              child: Text('read feedback'),
              onPressed: (){
                fetchData.readFeedback();
              },
            ),
            RaisedButton(
              child: Text('create ques'),
              onPressed: (){
                fetchData.createQuestion('title', 'category', 'description', 'screenshot');
              },
            ),
          ],
        ),
      ),
    );
  }
}