import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WithdrawPayouts extends StatefulWidget {
  @override
  _WithdrawPayoutsState createState() => _WithdrawPayoutsState();
}

class _WithdrawPayoutsState extends State<WithdrawPayouts> {

  bool isLoading = false;



  Future withdraw(String via, String amount) async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    int userId = prefs.getInt('user_id');
    String phone = prefs.getString('phone');

    String baseUrl =
        "https://dapetduitrestapi.000webhostapp.com/api/v1/payment?token=$token";
    var response = await http.post(baseUrl, headers: {
      "Accept": "application/json"
    }, body: {
      'phone': '+62$phone',
      'via': via,
      'amount': amount,
      'userId': userId.toString(),
      'status': 'Pending',
    });
    if (response.statusCode == 201) {}
    print(response.statusCode);
    print(response.body);
    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Padding(
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
        SizedBox(
          height: 150,
        )
      ],
    ));
  }
}
