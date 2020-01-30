import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionMenuCreate extends StatefulWidget {
  @override
  _QuestionMenuCreateState createState() => _QuestionMenuCreateState();
}

class _QuestionMenuCreateState extends State<QuestionMenuCreate> {

  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
        "images/background.jpeg",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.chevron_left, size: 40,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height*7/8+1,
            width: double.infinity,
                padding: EdgeInsets.only(top: 30),
                decoration: new BoxDecoration(
                    color: Color(0xffefeff4),
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(40.0),
                        topRight: const Radius.circular(40.0))),
                child: Text('Tanyakan Lainnya disini')
                ))
      ],
    );
  }
}