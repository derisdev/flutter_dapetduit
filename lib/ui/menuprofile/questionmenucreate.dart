import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        Text('Sampaikan keluhanmu disini', style: TextStyle(fontSize: 20),),
                        SizedBox(height: 30,),
                        Text('Kamu dapat menyampaikan keluhanmu melalui email atau WA melalui tombol dibawah.', style: TextStyle(),),
                        SizedBox(height: 100,),
                        Container(
                          width: 200,
                          height: 50,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)
                            ),
                            color: Color(0xff24bd64),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.phone, color: Colors.white, size: 30,),
                                SizedBox(width: 20,),
                                Text('WhatsApp',  style: TextStyle(color: Colors.white, fontSize: 20))
                              ],
                            ),
                            onPressed: (){
                              _launchURL('https://api.whatsapp.com/send?phone=6285719632945&text=Phone:%0ASubject:%0AKategori%20Masalah:%0ARincian%20Masalah:%0A%0A%0AMohon%20Sertakan%20Screenshot.%0A%0A*Pilihan%20Kategori:Login,%20Misi,%20Aktivitas,%20Kesalahan/Bug,%20Koin/Uang,%20Masukan,%20Lain');
                            },
                          ),
                        ),
                        SizedBox(height: 30,),
                        Container(
                          width: 200,
                          height: 50,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)
                            ),
                            color: Colors.red,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.mail, color: Colors.white, size: 30,),
                                SizedBox(width: 40,),
                                Text('Email',  style: TextStyle(color: Colors.white, fontSize: 20))
                              ],
                            ),
                            onPressed: (){
                              _launchURL('mailto:deris.dev7@gmail.com?subject=Feedback-DapetDuit&body=Phone:\nKategori Masalah: \nRincian Masalah: \nMohon sertakan screenshot');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                ))
      ],
    );
  }
  _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
}