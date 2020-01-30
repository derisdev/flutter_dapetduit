import 'package:dapetduit/ui/widget/invitewidget/kodeundanganwidget.dart';
import 'package:dapetduit/ui/widget/invitewidget/linkwidget.dart';
import 'package:dapetduit/ui/widget/payoutswidget/historypayouts.dart';
import 'package:dapetduit/ui/widget/payoutswidget/withdrawpayouts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Invite extends StatefulWidget {
  @override
  _InviteState createState() => _InviteState();
}

class _InviteState extends State<Invite> {
  int currentInvited;
  bool isLink = true;

  @override
  void initState() {
    super.initState();
    getCurrentInvite();
  }

  Future getCurrentInvite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String invited = prefs.getString('invited');
    if (invited == null) {
      setState(() {
        currentInvited = 0;
      });
    } else {
      setState(() {
        currentInvited = int.parse(invited);
      });
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffefeff4),

        body: SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Stack(
        children: <Widget>[
      
          Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 1 / 3,
                decoration: new BoxDecoration(
                    color: Color(0xff24bd64),
                    borderRadius: new BorderRadius.only(
                        bottomLeft: const Radius.circular(10.0),
                        bottomRight: const Radius.circular(10.0))),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Total Teman yang telah di undang',
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                    Text(currentInvited == null? SpinKitThreeBounce(
                      size: 30,
                      color: Colors.white,
                    ) : currentInvited.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 30)),
                  ],
                )),
              ),
              Container(
                margin: EdgeInsets.only(top: 60),
                height: MediaQuery.of(context).size.height * 2 / 3,
                child: isLink? LinkWidget() : KodeUndanganWidget()
              ),
            ],
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 14,
            top: MediaQuery.of(context).size.height * 1 / 3.7,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 150,
                  height: 80,
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                       isLink = true; 
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: isLink? Colors.white:  Colors.white.withOpacity(0.8),

                      child: Center(
                        child: Text('Link',
                            style: TextStyle(color:isLink? Colors.orange : Colors.black, fontSize: 20)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 80,
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                       isLink = false; 
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: isLink? Colors.white.withOpacity(0.8) : Colors.white,
                      child: Center(
                        child: Text('Kode\nUndangan',
                            style: TextStyle(color:isLink? Colors.black : Colors.greenAccent, fontSize: 20), textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                margin: EdgeInsets.only(top: 40.0),
                child: Image.asset('images/icon/menu.png', width: 30, height: 30,)),
          ),
        ],
      ),
    ));
  }
}
