import 'package:dapetduit/service/fetchdata.dart';
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


  bool isLoading = false;
  FetchData fetchData = new FetchData();

  TextEditingController phoneController = TextEditingController();

  Future verifyPhone() async {
    setState(() {
     isLoading = true; 
    });

    await fetchData.phoneVerify(phoneController.text);
    
    setState(() {
     isLoading = false; 
    });
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
