import 'package:dapetduit/ui/menuprofile/feedbackmenu.dart';
import 'package:dapetduit/ui/menuprofile/notifmenu.dart';
import 'package:flutter/material.dart';

class MenuProfile extends StatefulWidget {
  @override
  _MenuProfileState createState() => _MenuProfileState();
}

class _MenuProfileState extends State<MenuProfile> {
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
                                    crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                  Text('User', style: TextStyle(fontSize: 20),),
                                  SizedBox(height: 5,),
                                  Text('+6285719632945', style: TextStyle(fontSize: 15, color: Colors.grey))
                              ],
                            ),
                                ),
                            Container(
                              width: 50,
                              height: 50,
                              margin: EdgeInsets.only(left: 80),
                              child: Image.asset('images/icon/people.png'))
                              ],
                            )
                          ),
                        ),
                        SizedBox(height: 50,),
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
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => FeedbackMenu()
                                    ));
                                  },
                                ),
                                Divider(),
                                ListTile(
                                  leading: Icon(Icons.notifications),
                                  title: Text('Notifikasi'),
                                  trailing: Icon(Icons.chevron_right),
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => NotifMenu()
                                    ));
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
                                  leading: Icon(Icons.replay),
                                  title: Text('Periksa Versi'),
                                  trailing: Icon(Icons.chevron_right),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 100),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: <Widget>[
                              Text('Versi 1.0.0'),
                              Text('Syarat dan ketentuan dan kebijakan privasi'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
        ),

      ],
    );
  }
}
