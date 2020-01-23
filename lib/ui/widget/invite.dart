import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Invite extends StatefulWidget {
  @override
  _InviteState createState() => _InviteState();
}

class _InviteState extends State<Invite> {

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
    }
    else {
      setState(() {
       currentCoin = coin; 
      });
    }  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite'),
        backgroundColor: Color(0xff24bd64),
        actions: <Widget>[
          Image.asset('images/icon/coin.png'),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: currentCoin==null?  
                    SpinKitThreeBounce(
                      size: 30,
                     color: Colors.white,
                    )
                    :  Text('$currentCoin', style: TextStyle(fontSize: 30)),
            ),
          )
        ],
        elevation: 7.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                    child: Text('Undang Temanmu!', style: TextStyle(fontSize: 30))),
                 SizedBox(
                  height: 10,
                ),
                Text('Dapatkan 10% dari emas yang temanmu kumpulkan!', style: TextStyle(fontSize: 18)),
                 SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Jumlah teman yang telah anda\nundang: ', style: TextStyle(fontSize: 18)),
                    Container(
                      width: 50,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          color: Color(0xff24bd64), 
                          child: Text('0', style: TextStyle(color: Colors.white, fontSize: 20),),
                          onPressed: (){},
                        ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                  color: Color(0xffefeff4),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Share di Media Sosial', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                        SizedBox(height: 10,),
                        Text('1. Share Link Undangan atau Kode Undangan Anda di sosial media dan undang temanmu untuk gabung dengan dapet duit!\n2. Temanmu akan dapat 150 Emas dengan gratis setelah registrasi dan selesaikan misi.\n3. Anda selamanya dapat 10% dari Emas yang temanmu kumpulkan dari selesai misi di halaman beranda!', style: TextStyle(height: 2)),
                        SizedBox(height: 10,),
                        Container(
                          height: 100,
                          child: Card(
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0), side: BorderSide(color: Colors.orange)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text('https://invite.dapetduit.id\n/?ic?22222H3L', style: TextStyle(fontSize: 17)),
                                VerticalDivider(color: Colors.orange,),
                                Text('Copy\nURL', style: TextStyle(fontSize: 20, color: Colors.orange))  
                              ]
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15,),
                          child: Text('atau', style: TextStyle(color: Colors.grey)),
                        ),
                        Container(
                          height: 100,
                          child: Card(
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0), side: BorderSide(color: Colors.blue)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0, top: 25),
                                  child: Column(
                                    children: <Widget>[
                                      Text('Kode Undangan Anda', style: TextStyle(color: Colors.blue)),
                                      Text('2222H3L', style: TextStyle(fontSize: 25, color: Colors.blue)),
                                    ],
                                  ),
                                ),
                                VerticalDivider(color: Colors.blue,),
                                Text('Copy\nURL', style: TextStyle(fontSize: 20, color: Colors.blue)),  
                              ]
                            ),
                          ),
                        ),
                        SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              height: 45,
                              child: RaisedButton(
                                color: Color(0xff24bd64),
                                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.call, color: Colors.white),
                                    SizedBox(width: 5,),
                                    Text('WhatsApp', style: TextStyle(color: Colors.white, fontSize: 17))
                                  ],
                                ),
                                onPressed: (){},
                              ),
                            ),
                            Container(
                              height: 45,
                              child: RaisedButton(
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.share, color: Colors.white),
                                    SizedBox(width: 5,),
                                    Text('Lainnya', style: TextStyle(color: Colors.white, fontSize: 17))
                                  ],
                                ),
                                onPressed: (){},
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
