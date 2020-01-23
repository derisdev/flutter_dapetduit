import 'package:dapetduit/helper/dbhelper.dart';
import 'package:dapetduit/model/historyModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sqflite/sqlite_api.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {

    
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<HistoryModel> historyList;

  @override
  void initState() {
    super.initState();
    historyList = List<HistoryModel>();
    updateListView();
    
    setState(() {
    historyList.sort((b, a)=> a.id.compareTo(b.id));
    });

  }

    void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<HistoryModel>> contactListFuture = dbHelper.getContactList();
      contactListFuture.then((contactList) {
        setState(() {
          this.historyList = contactList;
          this.count = contactList.length;
        });
      });
    });
  }   
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: Color(0xff24bd64),
        elevation: 7.0,
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            leading: Text('Time', style: TextStyle(fontSize: 20, color: Color(0xff24bd64),),),
            title: Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Text('From',style: TextStyle(fontSize: 20, color: Color(0xff24bd64),)),
            ),
            trailing: Text('Change', style: TextStyle(fontSize: 20, color: Color(0xff24bd64),)),
          ),
          Divider(color: Colors.black,),
          Expanded(
            child: historyList.isNotEmpty? ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index){
                return ListTile(
                  leading: Text(historyList[index].time, style: TextStyle(fontSize: 18)),
                  title: Text(historyList[index].src, style: TextStyle(fontSize: 18)),
                  trailing: Text(historyList[index].coin, style: TextStyle(fontSize: 18)),
                );
              },
            ) :
            Container(
              alignment: Alignment.center,
              child: Center(
                child: SpinKitThreeBounce(
                  size: 60,
                  color: Color(0xff24bd64),
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}