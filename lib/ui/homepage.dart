import 'package:adcolony/AdColony.dart';
import 'package:dapetduit/ui/widget/homewidget/moretask.dart';
import 'package:dapetduit/ui/widget/homewidget/payouts.dart';
import 'package:dapetduit/ui/widget/homewidget/invite.dart';
import 'package:dapetduit/ui/widget/homewidget/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pollfish/flutter_pollfish.dart';
import 'package:fluttertoast/fluttertoast.dart';


class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  @override
  void initState() { 
    super.initState();
    initPollfish();
   
  }
    Future<void> initPollfish() async {
    await FlutterPollfish.instance.init(
        apiKey: '63f82c3f-6101-448e-94d3-4cb1c259d19a',
        pollfishPosition: 3,
        rewardMode: false,
        releaseMode: false,
        offerwallMode: true,
        requestUUID: null);
    }



  DateTime currentBackPressTime;
  
  final pages = [
    Task(),
    MoreTask(),
    Payouts(),
    Invite()
  ];

  int selectedIndex = 0;

  void onTap(int index) {
    setState(() {
      selectedIndex = index;
 });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note, size: 35,),
            title: Text('Misi')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available, size: 35),
            title: Text('Lebih Banyak')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard, size: 35),
            title: Text('Penukaran')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add,size: 35),
            title: Text('Undang')
          ),
        ],
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Color(0xff24bd64),    
        unselectedItemColor: Colors.grey.withOpacity(0.7),   
        onTap: onTap,
      ),
      body: WillPopScope(
        child: pages.elementAt(selectedIndex),
        onWillPop: onWillPop,
      ),
    );
  }
  
Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || 
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'tekan sekali lagi untuk keluar');
      return Future.value(false);
    }
    return Future.value(true);
  }
}