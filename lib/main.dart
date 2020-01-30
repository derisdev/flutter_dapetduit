import 'package:dapetduit/test.dart';
import 'package:dapetduit/ui/homepage.dart';
import 'package:dapetduit/ui/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
     statusBarColor: Colors.transparent)); 
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dapet Duit',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage()
    );
  }
}
