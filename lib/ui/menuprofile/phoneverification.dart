import 'package:dapetduit/service/fetchdata.dart';
import 'package:dapetduit/ui/menuprofile.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class PhoneVerification extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  bool isLoading = false;
  bool _validate = false;
  FetchData fetchData = new FetchData();

  TextEditingController phoneController = TextEditingController();

  Future verifyPhone() async {
    setState(() {
      isLoading = true;
    });

    await fetchData.phoneVerify(phoneController.text);

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MenuProfile()));
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffefeff4),
      appBar: AppBar(
        title: Text('Verifikasi Nomor Telpon'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 60),
                child: Text(
                  'Silahkan masukkan nomor ponsel Anda',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: 300,
                child: Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: TextFormField(
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        errorText:
                            _validate ? 'Nomor Telpon harus diisi' : null,
                        contentPadding: EdgeInsets.all(12.0),
                        prefixText: '+62',
                        prefixStyle:
                            TextStyle(color: Colors.black, fontSize: 15),
                        labelText: 'Nomor Telepon',
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.yellow))),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                  width: 300,
                  height: 45,
                  child: isLoading
                      ? SpinKitThreeBounce(
                          size: 50,
                          color: Colors.amber,
                        )
                      : RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.amber,
                          child: Text(
                            'Yakin',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              phoneController.text.isEmpty
                                  ? _validate = true
                                  : _validate = false;
                            });
                            if(_validate == false){
                              verifyPhone();
                            }
                          },
                        )),
              SizedBox(
                height: 50,
              ),
              Text('Perhatian',
                  style: TextStyle(color: Colors.amber, fontSize: 20)),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    child: FloatingActionButton(
                      heroTag: 'one',
                      backgroundColor: Colors.black,
                      elevation: 0,
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                      child: Text(
                          'Satu Nomor Telepon hanya bisa digunakan pada satu akun.'))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    child: FloatingActionButton(
                      heroTag: 'two',
                      backgroundColor: Colors.black,
                      elevation: 0,
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                      child: Text(
                          'Pastikan Nomor Telpon Telah terhubung dengan salah satu metode pembayaran baik DANA, GOPAY, maupun OVO.'))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    child: FloatingActionButton(
                      heroTag: 'three',
                      backgroundColor: Colors.black,
                      elevation: 0,
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                      child: Text(
                          'Untuk sementara belum tersedia fitur Login. Sehingga jika aplikasi terhapus, anda harus membuat akun baru dengan Nomor Telepon yang baru.'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
