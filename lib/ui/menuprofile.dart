import 'package:dapetduit/ui/menuprofile/feedbackmenu.dart';
import 'package:dapetduit/ui/menuprofile/notifmenu.dart';
import 'package:dapetduit/ui/menuprofile/phoneverification.dart';
import 'package:dapetduit/ui/menuprofile/questionmenucreate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pollfish/flutter_pollfish.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuProfile extends StatefulWidget {
  @override
  _MenuProfileState createState() => _MenuProfileState();
}

class _MenuProfileState extends State<MenuProfile> {
  String name;
  String phone;

  bool isVerified = false;

  @override
  void initState() {
    super.initState();
    FlutterPollfish.instance.hide();
    readDatauser();
  }

  Future readDatauser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name');
    String phone = prefs.getString('phone');

    if (phone == null) {
      setState(() {
        isVerified = false;
      });
    } else {
      setState(() {
        isVerified = true;
      });
    }

    setState(() {
      this.name = name;
      this.phone = phone;
    });
  }

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
                icon: Icon(
                  Icons.chevron_left,
                  size: 40,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 7 / 8 + 1,
                  padding: EdgeInsets.only(top: 30),
                  decoration: new BoxDecoration(
                      color: Color(0xffefeff4),
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(40.0),
                          topRight: const Radius.circular(40.0))),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10),
                          Container(
                            height: 100,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          name == null
                                              ? SpinKitThreeBounce(
                                                  size: 20,
                                                  color: Colors.amber,
                                                )
                                              : Text(
                                                  name,
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                          isVerified
                                              ? phone == null
                                                  ? SpinKitThreeBounce(
                                                      size: 20,
                                                      color: Colors.amber)
                                                  : Text('+62$phone',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.grey))
                                              : FlatButton(
                                                  child: Text(
                                                    'Verifikasi nomor telpon',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                PhoneVerification()));
                                                  },
                                                ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        width: 50,
                                        height: 50,
                                        margin: EdgeInsets.only(left: 80),
                                        child: Image.asset(
                                            'images/icon/people.png'))
                                  ],
                                )),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.repeat),
                                    title: Text('Q & A'),
                                    trailing: Icon(Icons.chevron_right),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FeedbackMenu()));
                                    },
                                  ),
                                  Divider(),
                                  ListTile(
                                    leading: Icon(Icons.notifications),
                                    title: Text('Notifikasi'),
                                    trailing: Icon(Icons.chevron_right),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NotifMenu()));
                                    },
                                  ),
                                  Divider(),
                                  ListTile(
                                    leading: Icon(Icons.settings),
                                    title: Text('Pengaturan'),
                                    trailing: Icon(Icons.chevron_right),
                                  ),
                                  Divider(),
                                  ListTile(
                                    leading: Icon(Icons.help),
                                    title: Text('Bantuan'),
                                    trailing: Icon(Icons.chevron_right),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  QuestionMenuCreate()));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Versi 1.0.0'),
                  ),
                )
              ],
            )),
      ],
    );
  }
}
