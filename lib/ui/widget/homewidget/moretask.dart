import 'package:dapetduit/ui/history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoreTask extends StatefulWidget {
  @override
  _MoreTaskState createState() => _MoreTaskState();
}

class _MoreTaskState extends State<MoreTask> {
  int currentCoin;

  @override
  void initState() {
    super.initState();

    getCurrentCoin();
  }

  Future getCurrentCoin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int coin = prefs.getInt('coin');
    if (coin == null) {
      setState(() {
        currentCoin = 0;
      });
    } else {
      setState(() {
        currentCoin = coin;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffefeff4),
      appBar: AppBar(
        title: Text('Misi Lainnya'),
        backgroundColor: Color(0xff24bd64),
        leading: Container(
            padding: EdgeInsets.all(15),
            child: Image.asset('images/icon/menu.png')),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => History()));
            },
            child: Row(
              children: <Widget>[
                Image.asset('images/icon/coin.png'),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Center(
                    child: currentCoin == null
                        ? SpinKitThreeBounce(
                            size: 30,
                            color: Colors.white,
                          )
                        : Text('$currentCoin', style: TextStyle(fontSize: 30)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(10),
                child: Text('Daily Tasks'),
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                    leading: Image.asset('images/icon/kalendar.png'),
                    title: Text('Attendance Rewards'),
                    subtitle: Text('Check-in Daily'),
                    trailing: RaisedButton(
                        color: Colors.amber,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: Text(
                          '+20 Free',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {}),
                    onTap: () {}),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(10),
                child: Text('Misi video'),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    ListTile(
                        leading: Image.asset('images/icon/video.png'),
                        title: Text('Tonton Video (Jaringan 1)'),
                        subtitle: Text('Dapatkan koin untuk setiap view'),
                        trailing: RaisedButton(
                            color: Color(0xff24bd64),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            child: Text(
                              '+20',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {}),
                        onTap: () {}),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                        leading: Image.asset('images/icon/video.png'),
                        title: Text('Tonton Video (Jaringan 2)'),
                        subtitle: Text('Dapatkan koin untuk setiap view'),
                        trailing: RaisedButton(
                            color: Color(0xff24bd64),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            child: Text(
                              '+20',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {}),
                        onTap: () {}),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                        leading: Image.asset('images/icon/video.png'),
                        title: Text('Tonton Video (Jaringan 3)'),
                        subtitle: Text('Dapatkan koin untuk setiap view'),
                        trailing: RaisedButton(
                            color: Color(0xff24bd64),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            child: Text(
                              '+20',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {}),
                        onTap: () {}),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(10),
                child: Text('Misi Pemula'),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Image.asset('images/icon/star.png'),
                      title: Text('Misi Review'),
                      trailing: RaisedButton(
                        color: Color(0xff24bd64),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: Text(
                          '+200',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Image.asset(
                          'images/icon/fb.png',
                          width: 30,
                          height: 30,
                        ),
                      ),
                      title: Text('Misi Facebook'),
                      trailing: RaisedButton(
                        color: Color(0xff24bd64),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child:
                            Text('+100', style: TextStyle(color: Colors.white)),
                        onPressed: () {},
                      ),
                    ),
                    ListTile(
                      leading: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Image.asset(
                            'images/icon/people.png',
                            width: 30,
                            height: 30,
                          )),
                      title: Text('Undang Teman'),
                      trailing: RaisedButton(
                        color: Color(0xff24bd64),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: Icon(
                          Icons.monetization_on,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
