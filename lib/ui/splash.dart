import 'dart:convert';

import 'package:dapetduit/helper/dbhelper.dart';
import 'package:dapetduit/model/historyModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dapetduit/ui/homepage.dart';
import 'package:dapetduit/ui/user/register.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool login = false;

  @override
  void initState() {
    super.initState();

    checkLogin().then(setcondition);

    Timer(
        Duration(seconds: 2),
        () => checkInternet().then((internet) {
              if (internet != null && internet) {
                getRewards();

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

  Future getRewards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt('user_id');
    int recentRewards = prefs.getInt('rewards_from_refferal');

    if (recentRewards == null) {
      recentRewards = 0;
    }

    String baseUrl =
        "https://dapetduitrestapi.000webhostapp.com/api/v1/user/show_refferal";
    var response = await http.post(baseUrl, headers: {
      "Accept": "application/json"
    }, body: {
      'user_id': userId.toString(),
    });

    print(response.statusCode);
    print(response.body);
    print(recentRewards);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      int rewards = jsonData['rewards'];

      print('reward diperoleh dari refferal $rewards');

      if (rewards > recentRewards) {
        int currentCoin = prefs.getInt('coin');
        if (currentCoin==null) {
          currentCoin = 0;
        }
        currentCoin += 2;
        prefs.setInt('coin', currentCoin);

        DbHelper dbHelper = DbHelper();
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('EEE d MMM').format(now);

        int totalRewards = 2;

        HistoryModel historyModel =
            HistoryModel(formattedDate, 'Refferal', '+$totalRewards');
        await dbHelper.insert(historyModel);

        print('Data rewards refferal inserted');

        prefs.setInt('rewards_from_refferal', rewards);
      }
    }
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
