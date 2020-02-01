import 'package:dapetduit/helper/dbhelperNotif.dart';
import 'package:dapetduit/service/fetchdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifMenu extends StatefulWidget {
  @override
  _NotifMenuState createState() => _NotifMenuState();
}

class _NotifMenuState extends State<NotifMenu> {
  bool isLoading = false;

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    FetchData fetchData = FetchData();
    await fetchData.readNotif();

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
    return Stack(
      children: <Widget>[
        Image.asset(
          "images/background.jpeg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  size: 40,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Container(
                height: MediaQuery.of(context).size.height * 7 / 8 + 1,
                padding: EdgeInsets.only(top: 30),
                decoration: new BoxDecoration(
                    color: Color(0xffefeff4),
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(40.0),
                        topRight: const Radius.circular(40.0))),
                child: isLoading
                    ? SpinKitThreeBounce(
                        size: 40.0,
                        color: Color(0xff24bd64),
                      )
                    : FutureBuilder(
                        future: DBHelperNotif.db.getAllNotif(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return SmartRefresher(
                              enablePullDown: true,
                              enablePullUp: false,
                              header: WaterDropMaterialHeader(),
                              footer: CustomFooter(
                                builder:
                                    (BuildContext context, LoadStatus mode) {
                                  Widget body;
                                  if (mode == LoadStatus.idle) {
                                    body = Text("Sudah mencapai batas");
                                  } else if (mode == LoadStatus.loading) {
                                    body = CupertinoActivityIndicator();
                                  } else if (mode == LoadStatus.failed) {
                                    body = Text("Gagal Memuat");
                                  } else if (mode == LoadStatus.canLoading) {
                                    body =
                                        Text("Tarik kebawah untuk memperbarui");
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
                                child: Text(
                                  'Belum ada Notif.\nTarik kebawah untuk memperbarui',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          } else {
                            return SmartRefresher(
                                enablePullDown: true,
                                enablePullUp: false,
                                header: WaterDropMaterialHeader(),
                                footer: CustomFooter(
                                  builder:
                                      (BuildContext context, LoadStatus mode) {
                                    Widget body;
                                    if (mode == LoadStatus.idle) {
                                      body = Text("Sudah mencapai batas");
                                    } else if (mode == LoadStatus.loading) {
                                      body = CupertinoActivityIndicator();
                                    } else if (mode == LoadStatus.failed) {
                                      body = Text("Gagal Memuat");
                                    } else if (mode == LoadStatus.canLoading) {
                                      body = Text(
                                          "Tarik kebawah untuk memperbarui");
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
                                    var data = snapshot.data[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(context: context,builder: (context) => _onTapCard(context, data.title, data.time, data.description ));
                                        },
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(data.title,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.amber)),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(data.time),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ),
                                    );
                                  },
                                ));
                          }
                        },
                      )))
      ],
    );
  }

  
  _onTapCard(BuildContext context, String title, String time, String des) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width-10,
          height: MediaQuery.of(context).size.height*2/3,
          child: Card(
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title,
                        style: TextStyle(fontSize: 20, color: Colors.amber)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(time, style: TextStyle(color: Colors.grey)),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*2/3-130,
                      child: SingleChildScrollView(
                        child: Text(des),
                      ),
                    )

                  ],
                ),
              )),
        ),
        Align(
          alignment: Alignment.topRight,
          child: RaisedButton.icon(
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              label: Text('Close')),
        ),
      ],
    );
  }

}
