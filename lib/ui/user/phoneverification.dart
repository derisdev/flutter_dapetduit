import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneVerification extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {


  bool isLoadingVerify = false;
  bool isLoading = false;

  TextEditingController phoneController = TextEditingController();
  TextEditingController verifyController = TextEditingController();

  Future savePhone() async {

    setState(() {
     isLoadingVerify = true; 
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id');
    String baseUrl =
        "https://dapetduitrestapi.000webhostapp.com/api/v1/user/create_profile";
    var response = await http.post(baseUrl, headers: {
      "Accept": "application/json"
    }, body: {
      'phone_number': '+62${phoneController.text}',
      'user_id': userId.toString()
    });

    if(response.statusCode == 200) {
      Fluttertoast.showToast(
          msg:
              'Kode verifikasi telah dikirimkan',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 14.0,
          backgroundColor: Colors.grey,
          textColor: Colors.white);
    }

    else if (response.statusCode == 500) {
      Fluttertoast.showToast(
          msg:
              'Nomor telpon sudah digunakan',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 14.0,
          backgroundColor: Colors.grey,
          textColor: Colors.white);
    } else if (response.statusCode == 504) {
      Fluttertoast.showToast(
          msg: 'Server sedang ada gangguan. Coba lagi nanti',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 14.0,
          backgroundColor: Colors.grey,
          textColor: Colors.white);
    } else {
      Fluttertoast.showToast(
          msg: 'Gagal terhubung ke server',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 14.0,
          backgroundColor: Colors.grey,
          textColor: Colors.white);
    }
    setState(() {
     isLoadingVerify = false; 
    });




    print(response.statusCode);
    print(response.body);
    print(userId);
    print(phoneController.text);
  }




  Future verifyPhone() async {

    setState(() {
     isLoading =true; 
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id');
    String baseUrl =
        "https://dapetduitrestapi.000webhostapp.com/api/v1/user/create_profile_verify";
    var response = await http.post(baseUrl, headers: {
      "Accept": "application/json"
    }, body: {
      'verification_code': verifyController.text,
      'phone_number': phoneController.text
    });

    if(response.statusCode == 201) {
      Fluttertoast.showToast(
          msg:
          'Nomor di tambahkan',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 14.0,
          backgroundColor: Colors.grey,
          textColor: Colors.white);

      prefs.setString('phone_number', '+62${phoneController.text}');

    }
    setState(() {
     isLoading = false; 
    });
    print(response.statusCode);
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
                  'Silahkan masukkan nomor ponsel Anda dan mendapatkan kode', style: TextStyle(fontSize: 15),textAlign: TextAlign.center,),
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
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Nomor harus diisi';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12.0),
                        prefixText: '+62',
                        prefixStyle: TextStyle(color: Colors.black, fontSize: 15),
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
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 200,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                      controller: verifyController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Harap isi kode verifikasi';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          labelText: 'Kode Verifikasi',
                          labelStyle: TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.yellow))),
                    ),
                  ),
                        Container(
                          height: 45,
                          child: isLoadingVerify?
                          SpinKitThreeBounce(
                            size: 50,
                            color: Color(0xff24bd64),
                          )
                           : RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: Color(0xff24bd64),
                            child: Text('Verifikasi', style:  TextStyle(color: Colors.white),),
                            onPressed: (){
                              savePhone();
                            },
                          ),
                        )
                ],
              ),
              SizedBox(height: 40,),
              Container(
                width: 300,
                height: 45,
                child: isLoading?
                          SpinKitThreeBounce(
                            size: 50,
                            color: Colors.amber,
                          )
                           : RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            color: Colors.amber,
                            child: Text('Yakin', style:  TextStyle(color: Colors.white),),
                            onPressed: (){
                              verifyPhone();
                            },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
