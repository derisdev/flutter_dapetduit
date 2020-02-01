import 'package:dapetduit/service/fetchdata.dart';
import 'package:dapetduit/ui/menuprofile.dart';
import 'package:dapetduit/ui/widget/invitewidget/kodeundanganwidget.dart';
import 'package:dapetduit/ui/widget/invitewidget/linkwidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Invite extends StatefulWidget {
  @override
  _InviteState createState() => _InviteState();
}

class _InviteState extends State<Invite> {
  int currentInvited;
  bool isLink = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkLoaded();
  }

  Future checkLoaded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoaded = prefs.getBool('isInviteLoaded');

    if (isLoaded==false) {
      _loadFromApi();
    } else {
      getCurrentInvite();
    }
    prefs.setBool('isInviteLoaded', true);
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    FetchData fetchData = FetchData();
    await fetchData.readRefferal().then((invited) {
      if(mounted){
        setState(() {
        this.currentInvited = int.parse(invited);
      });
      }
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('invited', currentInvited);

    await Future.delayed(const Duration(seconds: 2));

    if(mounted) {
      setState(() {
      isLoading = false;
    });
    }
  }

  Future getCurrentInvite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int invited = prefs.getInt('invited');
    if (invited == null) {
      setState(() {
        currentInvited = 0;
      });
    } else {
      setState(() {
        currentInvited = invited;
      });
    }
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
    return Scaffold(
        backgroundColor: Color(0xffefeff4),
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: WaterDropMaterialHeader(color: Colors.white),
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
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 1 / 3,
                      decoration: new BoxDecoration(
                          color: Color(0xff24bd64),
                          borderRadius: new BorderRadius.only(
                              bottomLeft: const Radius.circular(10.0),
                              bottomRight: const Radius.circular(10.0))),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Total Teman yang telah di undang',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15)),
                          isLoading
                              ? SpinKitThreeBounce(
                                  size: 40.0,
                                  color: Colors.white,
                                )
                              : currentInvited == null
                                  ? SpinKitThreeBounce(
                                      size: 30,
                                      color: Colors.white,
                                    )
                                  : Text(currentInvited.toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 30)),
                        ],
                      )),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 60),
                        height: MediaQuery.of(context).size.height * 2 / 3,
                        child: isLink ? LinkWidget() : KodeUndanganWidget()),
                  ],
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width / 14,
                  top: MediaQuery.of(context).size.height * 1 / 3.7,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 150,
                        height: 80,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isLink = true;
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: isLink
                                ? Colors.white
                                : Colors.white.withOpacity(0.8),
                            child: Center(
                              child: Text('Link',
                                  style: TextStyle(
                                      color:
                                          isLink ? Colors.orange : Colors.black,
                                      fontSize: 20)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        height: 80,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isLink = false;
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: isLink
                                ? Colors.white.withOpacity(0.8)
                                : Colors.white,
                            child: Center(
                              child: Text(
                                'Kode\nUndangan',
                                style: TextStyle(
                                    color: isLink
                                        ? Colors.black
                                        : Colors.greenAccent,
                                    fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => MenuProfile()
                      ));
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        margin: EdgeInsets.only(top: 40.0),
                        child: Image.asset(
                          'images/icon/menu.png',
                          width: 30,
                          height: 30,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
