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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    historyList = List<HistoryModel>();
    updateListView();
    
  }

    void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<HistoryModel>> contactListFuture = dbHelper.getHistoryList();
      contactListFuture.then((contactList) {
        setState(() {
          this.historyList = contactList;
          this.count = contactList.length;
          isLoading = false;
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
        elevation: 0.0,
      ),
      body: isLoading?  Container(
        alignment: Alignment.center,
        child: Center(
          child: SpinKitThreeBounce(
            size: 60,
            color: Color(0xff24bd64),
          ),
        ),
      ):  historyList.isNotEmpty? ListView.builder(
        itemCount: historyList.length,
        itemBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              child: ListTile(
              title: Text(historyList[index].src, style: TextStyle(fontSize: 18)),
              subtitle: Text(historyList[index].time),
              trailing: Text(historyList[index].coin, style: TextStyle(fontSize: 18, color: Colors.amber)),
            ),
            ),
          );
        },
      ) :
        Container(
        alignment: Alignment.center,
        child: Center(
          child: Text('Belum ada history')
        ),
      ),
    
    );
  }
}