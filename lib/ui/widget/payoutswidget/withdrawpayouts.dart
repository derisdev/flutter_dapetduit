import 'package:dapetduit/service/fetchdata.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WithdrawPayouts extends StatefulWidget {
  @override
  _WithdrawPayoutsState createState() => _WithdrawPayoutsState();
}

class _WithdrawPayoutsState extends State<WithdrawPayouts> {
  bool isLoading = false;
  bool isVerified = false;
  String phone;
  int currentCoin;
  FetchData fetchData = new FetchData();

  @override
  void initState() {
    super.initState();
    getCurrentCoin();
    checkPhoneNumber();
  }

  Future checkPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
      this.phone = phone;
    });
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

  Future withdraw(String via, String amount) async {
    setState(() {
      isLoading = true;
    });
    await fetchData.createPayment(via, amount);
    setState(() {
      isLoading = false;
    });

    
  }

  onClickPayment(String via, String amount) {
      currentCoin > 5000
                          ? isVerified
                              ? showDialog(
                                  context: context,
                                  builder: (context) =>
                                      _onTapCard(context, via, amount))
                              : showToastWIthdraw('Harap verifikasi Nomor Terlebih dahulu. Tap icon Menu di pojok kiri atas')
                          : showToastWIthdraw('Koin Anda Belum Mencukupi untuk melakukan penukaran ini');
    }

   showToastWIthdraw(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        fontSize: 14.0,
        backgroundColor: Colors.grey,
        textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        isLoading
            ? SpinKitThreeBounce(size: 30, color: Colors.amber)
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  elevation: 0.5,
                  child: ListTile(
                    leading: ClipRRect(
                        borderRadius: new BorderRadius.circular(8.0),
                        child: Image.asset('images/icon/dana.jpeg')),
                    title: Text('IDR 10.000'),
                    subtitle: Text(
                      'DANA',
                    ),
                    trailing: Text(
                      '5000 koin',
                      style: TextStyle(color: Colors.amber),
                    ),
                    onTap: () {
                      onClickPayment('DANA', 'IDR 10.000');
                    },
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            elevation: 0.5,
            child: ListTile(
              leading: ClipRRect(
                  borderRadius: new BorderRadius.circular(8.0),
                  child: Image.asset('images/icon/gopay.jpeg')),
              title: Text('IDR 10.000'),
              subtitle: Text(
                'GO-Pay',
              ),
              trailing: Text(
                '5000 koin',
                style: TextStyle(color: Colors.amber),
              ),
              onTap: () {},
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            elevation: 0.5,
            child: ListTile(
              leading: ClipRRect(
                  borderRadius: new BorderRadius.circular(8.0),
                  child: Image.asset('images/icon/ovo.jpeg')),
              title: Text('IDR 20.000'),
              subtitle: Text(
                'OVO',
              ),
              trailing: Text(
                '9000 koin',
                style: TextStyle(color: Colors.amber),
              ),
              onTap: () {},
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            elevation: 0.5,
            child: ListTile(
              leading: ClipRRect(
                  borderRadius: new BorderRadius.circular(8.0),
                  child: Image.asset('images/icon/dana.jpeg')),
              title: Text('IDR 20.000'),
              subtitle: Text(
                'DANA',
              ),
              trailing: Text(
                '9000 koin',
                style: TextStyle(color: Colors.amber),
              ),
              onTap: () {},
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            elevation: 0.5,
            child: ListTile(
              leading: ClipRRect(
                  borderRadius: new BorderRadius.circular(8.0),
                  child: Image.asset('images/icon/dana.jpeg')),
              title: Text('IDR 25.000'),
              subtitle: Text(
                'DANA',
              ),
              trailing: Text(
                '11000 koin',
                style: TextStyle(color: Colors.amber),
              ),
              onTap: () {},
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            elevation: 0.5,
            child: ListTile(
              leading: ClipRRect(
                  borderRadius: new BorderRadius.circular(8.0),
                  child: Image.asset('images/icon/gopay.jpeg')),
              title: Text('IDR 25.000'),
              subtitle: Text(
                'Go-Pay',
              ),
              trailing: Text(
                '11000 koin',
                style: TextStyle(color: Colors.amber),
              ),
              onTap: () {},
            ),
          ),
        ),
      ],
    ));
  }

  _onTapCard(BuildContext context, String via, String amount) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset('images/icon/dana.jpeg'),
                    Text('Lakukan Penukaran 5000 coin dengan IDR 10.000'),
                    RaisedButton(
                      child: Text('Lanjut'),
                      onPressed: () {},
                    )
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
