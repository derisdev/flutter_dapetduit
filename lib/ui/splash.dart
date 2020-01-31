import 'package:dapetduit/service/fetchdata.dart';
import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dapetduit/ui/homepage.dart';
import 'package:dapetduit/ui/user/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool login = false;

  FetchData fetchData = new FetchData();

  @override
  void initState() {
    super.initState();

    checkLogin().then(setcondition);

    Timer(
        Duration(seconds: 2),
        () => checkInternet().then((internet) {
              if (internet != null && internet) {
                initAllDataFromDB();
                Timer(
                    Duration(seconds: 3),
                    () => Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return login ? HomePage() : Register();
                        })));
              } else {
                _onConnection();
                Fluttertoast.showToast(
                    msg:
                        'Tidak bisa terhubung ke Info Beasiswa. Periksa pengaturan jaringan atau coba lagi nanti',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    fontSize: 14.0,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white);
              }
            }));
  }

  Future<bool> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool login = prefs.getBool('login');
    if (login == null) {
      return false;
    }
    return true;
  }

  setcondition(bool login) {
    setState(() {
      this.login = login;
    });
  }

  Future checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _onConnection() {
    return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              title: Text(
                'Tidak dapat menjangkau jaringan',
                style: TextStyle(color: Colors.black),
              ),
              content: Text(
                  'Tidak bisa terhubung ke Dapet Duit. Periksa pengaturan jaringan atau coba lagi nanti'),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    FlatButton(
                        child: Text(
                          'Keluar',
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () => exit(0)),
                    SizedBox(
                      width: 40,
                    ),
                    FlatButton(
                        child: Text('Coba Lagi',
                            style: TextStyle(color: Colors.blue)),
                        onPressed: () {
                          checkInternet().then((internet) {
                            if (internet != null && internet) {
                              Navigator.pop(context);
                              initAllDataFromDB();
                              Timer(
                                  Duration(seconds: 3),
                                  () => Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return login ? HomePage() : Register();
                                      })));
                            } else {
                              Navigator.pop(context);
                              _onConnection();
                            }
                          });
                        }),
                    SizedBox(
                      width: 40,
                    ),
                  ],
                )
              ],
            ));
  }

  Future initAllDataFromDB() async {
    await fetchData.readRewards();
    await fetchData.readPayment();
    await fetchData.readNotif();
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFeedbackLoaded', false);
    await prefs.setBool('isInviteLoaded', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: Text(
            'Dapet Duit',
            style: TextStyle(
                color: Colors.yellow, fontSize: 30.0, fontFamily: 'neue'),
          ),
        ),
      ),
    );
  }
}
