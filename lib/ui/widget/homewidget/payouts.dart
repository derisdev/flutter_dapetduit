import 'package:dapetduit/ui/menuprofile.dart';
import 'package:dapetduit/ui/widget/payoutswidget/historypayouts.dart';
import 'package:dapetduit/ui/widget/payoutswidget/withdrawpayouts.dart';
import 'package:flutter_pollfish/flutter_pollfish.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Payouts extends StatefulWidget {
  @override
  _PayoutsState createState() => _PayoutsState();
}

class _PayoutsState extends State<Payouts> {
  int currentCoin;
  bool isLoading = false;
  bool isWithdraw = true;

  @override
  void initState() {
    super.initState();
    FlutterPollfish.instance.hide();
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
                    Text('Total Coin',
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                    currentCoin == null
                        ? SpinKitThreeBounce(
                            size: 30,
                            color: Colors.white,
                          )
                        : Text('$currentCoin',
                            style:
                                TextStyle(color: Colors.white, fontSize: 30)),
                  ],
                )),
              ),
              Container(
                margin: EdgeInsets.only(top: 60),
                height: MediaQuery.of(context).size.height * 2 / 3,
                padding: EdgeInsets.only(bottom: 125),
                child: isWithdraw ? WithdrawPayouts() : HistoryPayouts(),
              )
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
                    onTap: () {
                      setState(() {
                        isWithdraw = true;
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: isWithdraw
                          ? Colors.white
                          : Colors.white.withOpacity(0.8),
                      child: Center(
                        child: Text('Withdraw',
                            style: TextStyle(
                                color: isWithdraw ? Colors.amber : Colors.black,
                                fontSize: 20)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 80,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isWithdraw = false;
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: isWithdraw
                          ? Colors.white.withOpacity(0.8)
                          : Colors.white,
                      child: Center(
                        child: Text('History',
                            style: TextStyle(
                                color: isWithdraw
                                    ? Colors.black
                                    : Colors.greenAccent,
                                fontSize: 20)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => MenuProfile()
                ));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  margin: EdgeInsets.only(top: 40.0),
                  child: Image.asset(
                    'images/icon/menu.png',
                    width: 30,
                    height: 30,
                  )),
            ),
          ),
        ],
      ),
    ));
  }
}
