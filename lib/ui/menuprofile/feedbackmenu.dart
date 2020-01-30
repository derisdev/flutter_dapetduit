import 'package:dapetduit/helper/dbhelperFeedback.dart';
import 'package:dapetduit/service/fetchdata.dart';
import 'package:dapetduit/ui/menuprofile/questionmenucreate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackMenu extends StatefulWidget {
  @override
  _FeedbackMenuState createState() => _FeedbackMenuState();
}

class _FeedbackMenuState extends State<FeedbackMenu> {

  bool isLoading = false;

  @override
  void initState() { 
    super.initState();
    checkLoaded();
  }

  Future checkLoaded() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoaded = prefs.getBool('isFeedbackLoaded');

    if (!isLoaded) {
      _loadFromApi();
    }
    prefs.setBool('isFeedbackLoaded', true);
  }


  _loadFromApi() async {

    setState(() {
      isLoading = true;
    });
   
    FetchData fetchData = FetchData();
    await fetchData.readFeedback();

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
              icon: Icon(Icons.chevron_left, size: 40,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: Icon(Icons.add, size: 30),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => QuestionMenuCreate()
                    ));
                  },
                ),
              )
            ],
          ),
          body: Container(
            height: MediaQuery.of(context).size.height*7/8+1,
                padding: EdgeInsets.only(top: 30),
                decoration: new BoxDecoration(
                    color: Color(0xffefeff4),
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(40.0),
                        topRight: const Radius.circular(40.0))),
                child: isLoading? SpinKitThreeBounce(
      size: 40.0,
      color: Color(0xff24bd64),
    ) : FutureBuilder(
      future: DBHelperFeedback.db.getAllFeedback(),
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
              child: Text('Belum ada Feedback.\nTarik kebawah untuk memperbarui', textAlign: TextAlign.center,),
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
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('Q: ', style: TextStyle(fontWeight: FontWeight.bold),),
                              SizedBox(width: 10,),
                              Flexible(child: Text('Kenapa fitur checkin menghilang?')),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: <Widget>[
                              Text('A: ', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(width: 10,),
                              Flexible(child: Text('Hello, kalo kamu punya akun lain sedang checkin balaa al bla')),
                            ],
                          ),
                        ],
                      ),
                    )
                  ),
                );
              },
            )
          );
        }
      },
    )
                ))
      ],
    );
  }
}