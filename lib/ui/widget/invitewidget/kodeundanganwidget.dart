import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KodeUndanganWidget extends StatefulWidget {
  @override
  _KodeUndanganState createState() => _KodeUndanganState();
}

class _KodeUndanganState extends State<KodeUndanganWidget> {
  String refferalCode;

  @override
  void initState() {
    super.initState();
    readRefferalCode();
  }

  Future readRefferalCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      refferalCode = prefs.getString('refferal_code_owner');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: new BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.1, 0.9],
              colors: [
                Colors.blueAccent,
                Colors.greenAccent,
              ],
            ),
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(30.0),
                topRight: const Radius.circular(30.0))),
        width: MediaQuery.of(context).size.width - 30,
        height: MediaQuery.of(context).size.height / 2,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: ClipPath(
                  clipper: OvalRightBorderClipper(),
                  child: Container(
                    height: 65,
                    width: 230,
                    color: Colors.greenAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "1. Ajak Temanmu dan berikan kode refferal Kamu dibawah",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ClipPath(
                  clipper: OvalLeftBorderClipper(),
                  child: Container(
                    height: 65,
                    width: 270,
                    color: Colors.blueAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "2. Temanmu menggunakan kode refferal kamu pada saat pendaftaran",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: ClipPath(
                  clipper: OvalRightBorderClipper(),
                  child: Container(
                    height: 65,
                    width: 230,
                    color: Colors.greenAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "3. Temanmu akan mendapat 150 koin setelah selesai misi",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ClipPath(
                  clipper: OvalLeftBorderClipper(),
                  child: Container(
                    height: 60,
                    width: 270,
                    color: Colors.blueAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "4. Kamu selamanya mendapat 10% dari hasil misi temanmu di beranda",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 100,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.blue)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Text('Kode Undangan Anda',
                            style: TextStyle(color: Colors.blue)),
                        SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onLongPress: () {
                            Clipboard.setData(
                                ClipboardData(text: refferalCode));
                            Scaffold.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                  content: Text('Copied Refferal Code!')),
                            );
                          },
                          child: Text(
                              refferalCode == null ? 'belum ada' : refferalCode,
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 135,
                    height: 50,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      color: Color(0xff24bd64),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.phone,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('WhatsApp',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15))
                        ],
                      ),
                      onPressed: () {
                        FlutterShareMe()
                       .shareToWhatsApp(msg: 'Ayo bergabung bersama saya di Aplikasi DapetDuit dan dapatkan penghasilan Lebih.\n\nGunakan kode Refferal $refferalCode');
                      },
                    ),
                  ),
                  Container(
                    width: 135,
                    height: 50,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      color: Colors.blueAccent,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text('Lainnya',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15))
                        ],
                      ),
                      onPressed: () {
                        Share.share('Ayo bergabung bersama saya di Aplikasi DapetDuit dan dapatkan penghasilan Lebih.\nGunakan kode Refferal $refferalCode');

                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
