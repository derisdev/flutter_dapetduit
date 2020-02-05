import 'package:dapetduit/service/fetchdata.dart';
import 'package:dapetduit/ui/menuprofile/phoneverification.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WithdrawPayouts extends StatefulWidget {
  @override
  _WithdrawPayoutsState createState() => _WithdrawPayoutsState();
}

class _WithdrawPayoutsState extends State<WithdrawPayouts> {
  bool isLoading = false;
  bool isVerified = false;
  String username;
  String phone;
  int currentCoin = 10000;
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
    String name = prefs.getString('name');

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
      this.username = name;
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

  Future withdraw(String coin, String via, String amount) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

    if(mounted){
      setState(() {
      isLoading = true;
    });
    }
    await fetchData.createPayment(via, amount).then((isPayouted){
      if(isPayouted == true) {
        showDialog(
                context: context,
                builder: (context) =>
                    _onWithdrawSuccess(context));

      setState(() {
       currentCoin -= int.parse(coin); 
      });
    prefs.setInt('coin', currentCoin);

    fetchData.updateRewards(currentCoin.toString(), 'minus withdraw');
      
      }
    });
    if(mounted){
      setState(() {
      isLoading = false;
    });
    }
    
  }

  Future onClickPayment(String time, String koin, String via, String amount) async {
    await checkPhoneNumber();

    currentCoin >= int.parse(koin)
        ? isVerified
            ? showDialog(
                context: context,
                builder: (context) =>
                    _onTapCard(context, time, koin, via, amount))
            : showDialog(
                context: context,
                builder: (context) => _onPhoneNotVerify(context))
        : showDialog(
            context: context, builder: (context) => _oncoinNotEnough(context));
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Padding(
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
                    DateTime now = DateTime.now();
                    String formattedDate =
                        DateFormat('d MMM yyyy, h:mm').format(now);
                    onClickPayment(formattedDate, '5000', 'DANA', 'IDR 10.000');
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
                  onTap: () {
                     DateTime now = DateTime.now();
                    String formattedDate =
                        DateFormat('d MMM yyyy, h:mm').format(now);
                    onClickPayment(formattedDate, '5000', 'Go-Pay', 'IDR 10.000');
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
                      child: Image.asset('images/icon/ovo.jpeg')),
                  title: Text('IDR 20.000'),
                  subtitle: Text(
                    'OVO',
                  ),
                  trailing: Text(
                    '9000 koin',
                    style: TextStyle(color: Colors.amber),
                  ),
                  onTap: () {
                     DateTime now = DateTime.now();
                    String formattedDate =
                        DateFormat('d MMM yyyy, h:mm').format(now);
                    onClickPayment(formattedDate, '9000', 'OVO', 'IDR 20.000');
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
                      child: Image.asset('images/icon/dana.jpeg')),
                  title: Text('IDR 20.000'),
                  subtitle: Text(
                    'DANA',
                  ),
                  trailing: Text(
                    '9000 koin',
                    style: TextStyle(color: Colors.amber),
                  ),
                  onTap: () {
                     DateTime now = DateTime.now();
                    String formattedDate =
                        DateFormat('d MMM yyyy, h:mm').format(now);
                    onClickPayment(formattedDate, '9000', 'DANA', 'IDR 20.000');
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
                      child: Image.asset('images/icon/dana.jpeg')),
                  title: Text('IDR 25.000'),
                  subtitle: Text(
                    'DANA',
                  ),
                  trailing: Text(
                    '11000 koin',
                    style: TextStyle(color: Colors.amber),
                  ),
                  onTap: () {
                     DateTime now = DateTime.now();
                    String formattedDate =
                        DateFormat('d MMM yyyy, h:mm').format(now);
                    onClickPayment(formattedDate, '11000', 'DANA', 'IDR 25.000');
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
                  title: Text('IDR 25.000'),
                  subtitle: Text(
                    'Go-Pay',
                  ),
                  trailing: Text(
                    '11000 koin',
                    style: TextStyle(color: Colors.amber),
                  ),
                  onTap: () {
                     DateTime now = DateTime.now();
                    String formattedDate =
                        DateFormat('d MMM yyyy, h:mm').format(now);
                    onClickPayment(formattedDate, '11000', 'Go-Pay', 'IDR 25.000');
                  },
                ),
              ),
            ),
          ],
        )),
        isLoading
            ? Container(
                color: Colors.white.withOpacity(0.8),
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: SpinKitThreeBounce(
                    size: 40,
                    color: Color(0xff24bd64),
                  ),
                ))
            : SizedBox()
      ],
    );
  }

  _onTapCard(BuildContext context, String time, String koin, String via,
      String amount) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width-10,
          height: 510,
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  ClipRRect(
                    borderRadius: new BorderRadius.circular(8.0),
                    child: Container(
                        height: 140,
                        child: Image.asset('images/withdrawcash.png')),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Withdraw Koin',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 25),
                      alignment: Alignment.centerLeft,
                      child: Text('Withdraw Detail',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold))),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 1,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
                    ),
                    child: Slider(
                      activeColor: Colors.amber,
                      inactiveColor: Colors.grey,
                      value: 37,
                      min: 0,
                      max: 100,
                      onChanged: (value) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 112),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Nama',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 20,
                        ),
                        Text(username, style: TextStyle(fontSize: 17)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 58),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Nomor Telpon',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 20,
                        ),
                        Text('62$phone', style: TextStyle(fontSize: 17)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Tanggal Withdraw',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 20,
                        ),
                        Text(time, style: TextStyle(fontSize: 17)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 122),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Koin',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 20,
                        ),
                        Text(koin, style: TextStyle(fontSize: 17)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 130),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Via',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 20,
                        ),
                        Text(via, style: TextStyle(fontSize: 17)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 102),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Jumlah',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 20,
                        ),
                        Text(amount, style: TextStyle(fontSize: 17)),
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width - 20,
                    margin: EdgeInsets.only(top: 20),
                    child: RaisedButton(
                      color: Color(0xff20d59e),
                      child: Text('Konfirmasi Withdraw',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.pop(context);
                        withdraw(koin, via, amount);
                      },
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  _oncoinNotEnough(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width - 30,
          height: MediaQuery.of(context).size.height * 1 / 2,
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  ClipRRect(
                    borderRadius: new BorderRadius.circular(8.0),
                    child: Container(
                        height: 140,
                        child: Image.asset('images/notenough.png')),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Tidak Cukup Koin',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                        'Koinmu tidak cukup untuk withdraw ini. kamu bisa mendapatkan koin lebih banyak dengan menyelesaikan semua misi.',
                        style: TextStyle(fontSize: 15)),
                  ),
                ],
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width - 20,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 1 / 8),
              child: FloatingActionButton(
                backgroundColor: Colors.amberAccent,
                child: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              )),
        )
      ],
    );
  }

  _onPhoneNotVerify(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width - 30,
          height: 300,
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 150,
                    height: 140,
                    child: FloatingActionButton(
                      elevation: 0.0,
                      backgroundColor: Colors.greenAccent,
                      child: Icon(
                        Icons.phone_android,
                        size: 100,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Harap Verifikasi Nomor Terlebih dahulu',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                        'Anda Belum memverifikasi nomor Telpon. Silahkan verifikasi terlebih dahulu',
                        style: TextStyle(fontSize: 15)),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width - 20,
                    margin: EdgeInsets.only(bottom: 20),
                    child: RaisedButton(
                      color: Color(0xff20d59e),
                      child: Text('Verifikasi',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhoneVerification()));
                      },
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }
    _onWithdrawSuccess(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width - 30,
          height: MediaQuery.of(context).size.height * 1 / 2,
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 150,
                      width: 150,
                      child: FloatingActionButton(
                        elevation: 0,
                        child: Icon(Icons.check, size: 100),
                        onPressed: (){},

                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Penukaran Berhasil',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                        'Kami akan melakukan pembayaran Maksimal 3 hari jam kerja.',
                        style: TextStyle(fontSize: 15)),
                  ),
                ],
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width - 20,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 1 / 8),
              child: FloatingActionButton(
                backgroundColor: Colors.amberAccent,
                child: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              )),
        )
      ],
    );
  }

}
