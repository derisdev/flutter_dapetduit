import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:dapetduit/helper/dbhelperPayment.dart';
import 'package:dapetduit/service/fetchdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HistoryPayouts extends StatefulWidget {
  @override
  _HistoryPayoutsState createState() => _HistoryPayoutsState();
}

class _HistoryPayoutsState extends State<HistoryPayouts> {

  bool isLoading = false;


  _loadFromApi() async {

    setState(() {
      isLoading = true;
    });
   
    FetchData fetchData = FetchData();
    await fetchData.readPayment();

    await Future.delayed(const Duration(seconds: 2));

     setState(() {
      isLoading = false;
    });
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await _loadFromApi();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading? SpinKitThreeBounce(
      size: 40.0,
      color: Color(0xff24bd64),
    ) : FutureBuilder(
      future: DBHelperPayment.db.getAllapyment(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SmartRefresher(
            enablePullDown: true,
        enablePullUp: false,
        header: WaterDropMaterialHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("Sudah mencapai batas");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Gagal Memuat");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("Tarik kebawah untuk memperbarui");
            } else {
              body = Text("Tidak ada data lagi");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
            child: Center(
              child: Text('Belum ada history.\nTarik kebawah untuk memperbarui', textAlign: TextAlign.center,),
            ),
          );
        } else {
          return SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropMaterialHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("Sudah mencapai batas");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Gagal Memuat");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("Tarik kebawah untuk memperbarui");
            } else {
              body = Text("Tidak ada data lagi");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                String icon;
                if (snapshot.data[index].via == 'DANA') {
                  icon = 'dana';
                } else if (snapshot.data[index].via == 'OVO') {
                  icon = 'ovo';
                } else {
                  icon = 'gopay';
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      leading: ClipRRect(
                          borderRadius: new BorderRadius.circular(8.0),
                          child: Image.asset('images/icon/$icon.jpeg')),
                      title: Text(snapshot.data[index].amount),
                      subtitle: Text(
                        snapshot.data[index].time,
                      ),
                      trailing: Text(
                        snapshot.data[index].status,
                        style: TextStyle(color: Colors.amber),
                      ),
                      onTap: () {},
                    ),
                  ),
                );
              },
            )
          );
        }
      },
    );
  }
}
