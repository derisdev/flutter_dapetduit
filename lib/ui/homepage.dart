import 'package:dapetduit/ui/widget/moretask.dart';
import 'package:dapetduit/ui/widget/payouts.dart';
import 'package:dapetduit/ui/widget/invite.dart';
import 'package:dapetduit/ui/widget/task.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  
  final pages = [
    Task(),
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
      body: pages.elementAt(selectedIndex),
    );
  }
}