import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Payouts extends StatefulWidget {
  @override
  _PayoutsState createState() => _PayoutsState();
}

class _PayoutsState extends State<Payouts> {

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

  Future withdraw(String via, String amount, String userId) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    int userId = prefs.getInt('user_id');
    String phone = prefs.getString('phone');


     String baseUrl =
      "https://dapetduitrestapi.000webhostapp.com/api/v1/payment?token=$token";
    var response = await http.post(baseUrl, headers: {
      "Accept": "application/json"
    }, body: {
      'phone': phone,
      'via': via,
      'amount': amount,
      'userId': userId.toString(),
      'status': 'Pending',
    });
    if(response.statusCode == 201) {

    }
    print(response.statusCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffefeff4),
       appBar: AppBar(
        title: Text('Penarikan'),
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
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                elevation: 7,
                child: ListTile(
                  leading: Image.asset('images/icon/dana.jpeg'),
                  title: Text('DANA Rp 10K'),
                  subtitle: Text('1700 koin',),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                elevation: 7,
                child: ListTile(
                  leading: Image.asset('images/icon/gopay.jpeg'),
                  title: Text('Go-Pay Rp 10K'),
                  subtitle: Text('2000 koin'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                elevation: 7,
                child: ListTile(
                  leading: Image.asset('images/icon/ovo.jpeg'),
                  title: Text('OVO Rp 10K'),
                  subtitle: Text('1700 koin'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                elevation: 7,
                child: ListTile(
                  leading: Image.asset('images/icon/dana.jpeg'),
                  title: Text('Dana Rp 20K'),
                  subtitle: Text('3200 koin'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                elevation: 7,
                child: ListTile(
                  leading: Image.asset('images/icon/dana.jpeg'),
                  title: Text('Dana Rp 25K'),
                  subtitle: Text('3800 koin'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                elevation: 7,
                child: ListTile(
                  leading: Image.asset('images/icon/gopay.jpeg'),
                  title: Text('Go-Pay Rp 25K'),
                  subtitle: Text('4000 koin'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

