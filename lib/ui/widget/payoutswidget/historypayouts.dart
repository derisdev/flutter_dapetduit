import 'package:flutter/material.dart';

class HistoryPayouts extends StatefulWidget {
  @override
  _HistoryPayoutsState createState() => _HistoryPayoutsState();
}

class _HistoryPayoutsState extends State<HistoryPayouts> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index){
        return Padding(
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
                'Pending',
                style: TextStyle(color: Colors.amber),
              ),
              onTap: () {},
            ),
          ),
        );
      },
    );
  }
}