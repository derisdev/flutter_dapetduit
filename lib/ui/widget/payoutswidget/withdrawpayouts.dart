import 'package:dapetduit/service/fetchdata.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WithdrawPayouts extends StatefulWidget {
  @override
  _WithdrawPayoutsState createState() => _WithdrawPayoutsState();
}

class _WithdrawPayoutsState extends State<WithdrawPayouts> {
  bool isLoading = false;
  FetchData fetchData = new FetchData();

  Future withdraw(String via, String amount) async {
    setState(() {
      isLoading = true;
    });
    await fetchData.createPayment(via, amount);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        isLoading? SpinKitThreeBounce(size: 30, color: Colors.amber) : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            elevation: 3,
            child: ListTile(
              leading: ClipRRect(
                  borderRadius: new BorderRadius.circular(8.0),
                  child: Image.asset('images/icon/dana.jpeg')),
              title: Text('IDR 10.000'),
              subtitle: Text(
                'DANA',
              ),
              trailing: Text(
                '1700 koin',
                style: TextStyle(color: Colors.amber),
              ),
              onTap: () {
                withdraw('DANA', "IDR 10.000");
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            elevation: 3,
            child: ListTile(
              leading: ClipRRect(
                  borderRadius: new BorderRadius.circular(8.0),
                  child: Image.asset('images/icon/gopay.jpeg')),
              title: Text('IDR 10.000'),
              subtitle: Text(
                'GO-Pay',
              ),
              trailing: Text(
                '2000 koin',
                style: TextStyle(color: Colors.amber),
              ),
              onTap: () {},
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            elevation: 3,
            child: ListTile(
              leading: ClipRRect(
                  borderRadius: new BorderRadius.circular(8.0),
                  child: Image.asset('images/icon/ovo.jpeg')),
              title: Text('IDR 20.000'),
              subtitle: Text(
                'OVO',
              ),
              trailing: Text(
                '3000 koin',
                style: TextStyle(color: Colors.amber),
              ),
              onTap: () {},
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            elevation: 3,
            child: ListTile(
              leading: ClipRRect(
                  borderRadius: new BorderRadius.circular(8.0),
                  child: Image.asset('images/icon/dana.jpeg')),
              title: Text('IDR 20.000'),
              subtitle: Text(
                'DANA',
              ),
              trailing: Text(
                '3200 koin',
                style: TextStyle(color: Colors.amber),
              ),
              onTap: () {},
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            elevation: 3,
            child: ListTile(
              leading: ClipRRect(
                  borderRadius: new BorderRadius.circular(8.0),
                  child: Image.asset('images/icon/dana.jpeg')),
              title: Text('IDR 25.000'),
              subtitle: Text(
                'DANA',
              ),
              trailing: Text(
                '3800 koin',
                style: TextStyle(color: Colors.amber),
              ),
              onTap: () {},
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            elevation: 3,
            child: ListTile(
              leading: ClipRRect(
                  borderRadius: new BorderRadius.circular(8.0),
                  child: Image.asset('images/icon/gopay.jpeg')),
              title: Text('IDR 25.000'),
              subtitle: Text(
                'Go-Pay',
              ),
              trailing: Text(
                '4000 koin',
                style: TextStyle(color: Colors.amber),
              ),
              onTap: () {},
            ),
          ),
        ),
      ],
    ));
  }
}
