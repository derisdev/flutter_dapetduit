import 'package:dapetduit/helper/dbhelperNotif.dart';
import 'package:dapetduit/service/fetchdata.dart';
import 'package:dapetduit/ui/menuprofile.dart';
import 'package:dapetduit/ui/menuprofile/notifmenu.dart';
import 'package:flutter_pollfish/flutter_pollfish.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dapetduit/helper/dbhelper.dart';
import 'package:intl/intl.dart';
import 'package:dapetduit/model/historyModel.dart';
import 'package:dapetduit/ui/history.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ironsource/ironsource.dart';
import 'package:ironsource/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Task extends StatefulWidget {
  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task>
    with IronSourceListener, WidgetsBindingObserver {
  int currentCoin;
  String titleNotif;

  List<HistoryModel> listHistory = [];

  final String appKey = "b0d4544d";

   bool offerwallAvailable = false;
  @override
  void initState() {
    super.initState();

    FlutterPollfish.instance.hide();

    getLastNotifFromdb();
    getCurrentCoin();
    WidgetsBinding.instance.addObserver(this);
    init();
    initPollfish();
    giftRewardIfHaveRefferal();
  }

  Future getLastNotifFromdb() async {
    DBHelperNotif.db.getLastNotif().then((title) {
      List<String> titleNotifs = title.split(' ');

      setState(() {
        this.titleNotif =
            '${titleNotifs[0]} ${titleNotifs[1]} ${titleNotifs[2]}';
      });

      print(titleNotif);
    });
  }

  Future getCurrentCoin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int coin = prefs.getInt('coin');
    if (coin == null) {
      setState(() {
        currentCoin = 0;
      });
    } else {
      setState(() {
        currentCoin = coin;
      });
    }
    savetoPrefs(currentCoin);
  }

  Future giftRewardIfHaveRefferal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isHaveRefferal = prefs.getBool('haveRefferal');

    if (isHaveRefferal == true) {
      setState(() {
        currentCoin += 500;
      });

      savetoPrefs(currentCoin);
      saveHistory(500, 'Refferal');
      savetoDBFirst(500);
      showDialog(
          context: context, builder: (context) => _onGetRewards(context, 500));
    }

    prefs.setBool('haveRefferal', false);
  }

  Future<void> initPollfish() async {
    FlutterPollfish.instance
        .setPollfishReceivedSurveyListener(onPollfishSurveyReveived);
    FlutterPollfish.instance
        .setPollfishCompletedSurveyListener(onPollfishSurveyCompleted);
    FlutterPollfish.instance
        .setPollfishSurveyOpenedListener(onPollfishSurveyOpened);
    FlutterPollfish.instance
        .setPollfishSurveyClosedListener(onPollfishSurveyClosed);
    FlutterPollfish.instance.setPollfishSurveyNotAvailableSurveyListener(
        onPollfishSurveyNotAvailable);
    FlutterPollfish.instance
        .setPollfishUserRejectedSurveyListener(onPollfishUserRejectedSurvey);
    FlutterPollfish.instance
        .setPollfishUserNotEligibleListener(onPollfishUserNotEligible);
  }

  void onPollfishSurveyReveived(String result) => setState(() {
        List<String> surveyCharacteristics = result.split(',');

        if (surveyCharacteristics.length >= 6) {
          String _logText =
              'Survey Received: - SurveyInfo with CPA: ${surveyCharacteristics[0]} and IR: ${surveyCharacteristics[1]} and LOI: ${surveyCharacteristics[2]} and SurveyClass: ${surveyCharacteristics[3]} and RewardName: ${surveyCharacteristics[4]}  and RewardValue: ${surveyCharacteristics[5]}';
          print('Received $_logText');
        }
      });

  void onPollfishSurveyCompleted(String result) => setState(() {
        List<String> surveyCharacteristics = result.split(',');

        if (surveyCharacteristics.length >= 6) {
          String _logText =
              'Survey Completed: - SurveyInfo with CPA: ${surveyCharacteristics[0]} and IR: ${surveyCharacteristics[1]} and LOI: ${surveyCharacteristics[2]} and SurveyClass: ${surveyCharacteristics[3]} and RewardName: ${surveyCharacteristics[4]}  and RewardValue: ${surveyCharacteristics[5]}';
          print('complete $_logText');
          setState(() {
            currentCoin += int.parse(surveyCharacteristics[5]);
          });

          savetoPrefs(currentCoin);
          saveHistory(int.parse(surveyCharacteristics[5]), 'Survey Rewards');
          savetoDB(int.parse(surveyCharacteristics[5]));
          showDialog(
              context: context,
              builder: (context) =>
                  _onGetRewards(context, int.parse(surveyCharacteristics[5])));
        }
      });

  void onPollfishSurveyOpened() => setState(() {
        String _logText = 'Survey Panel Open';
        print(_logText);
      });

  void onPollfishSurveyClosed() => setState(() {
        String _logText = 'Survey Panel Closed';
        print(_logText);
      });

  void onPollfishSurveyNotAvailable() => setState(() {
        String _logText = 'Survey Not Available';
        print(_logText);
        Fluttertoast.showToast(
            msg: 'Mohon Tunggu sebentar. Survei sedang di persiapkan',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            fontSize: 14.0,
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      });

  void onPollfishUserRejectedSurvey() => setState(() {
        String _logText = 'User Rejected Survey';
        print(_logText);
        Fluttertoast.showToast(
            msg: 'Survei mungkin tidak cocok untuk anda',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            fontSize: 14.0,
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      });

  void onPollfishUserNotEligible() => setState(() {
        String _logText = 'User Not Eligible';
        print(_logText);
        Fluttertoast.showToast(
            msg: 'Survei mungkin tidak cocok untuk anda',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            fontSize: 14.0,
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        IronSource.activityResumed();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        IronSource.activityPaused();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  void init() async {
    var userId = await IronSource.getAdvertiserId();
    await IronSource.validateIntegration();
    await IronSource.setUserId(userId);
    await IronSource.initialize(appKey: appKey, listener: this);
    offerwallAvailable = await IronSource.isOfferwallAvailable();
  }


  void showOfferwall() async {
    if (await IronSource.isOfferwallAvailable()) {
      IronSource.showOfferwall();
    } else {
      Fluttertoast.showToast(
          msg: "Tunggu sebentar. Offerwall sedang di persiapkan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Color(0xff24bd64),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Image.asset(
        "images/background.jpeg",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: Container(
                padding: EdgeInsets.all(15),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MenuProfile()));
                    },
                    child: Image.asset('images/icon/menu.png'))),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => History()));
                },
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Image.asset('images/icon/coin.png'),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Center(
                          child: currentCoin == null
                              ? SpinKitThreeBounce(
                                  size: 30,
                                  color: Colors.white,
                                )
                              : Text('$currentCoin',
                                  style: TextStyle(fontSize: 30)),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          body: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 40),
                padding: EdgeInsets.only(top: 50),
                decoration: new BoxDecoration(
                    color: Color(0xffefeff4),
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(40.0),
                        topRight: const Radius.circular(40.0))),
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10),
                        Container(
                          height: 200,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap: () {
                              showOfferwall();
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12),
                                        child: Image.asset(
                                          'images/icon/is.png',
                                          height: 35,
                                          width: 35,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text('Iron Source Offerwall',
                                            style: TextStyle(fontSize: 20)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 125,
                                    width: 305,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.asset(
                                        'images/icon/isbanner.jpg',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 200,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap: () {
                              FlutterPollfish.instance.show();
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12),
                                        child: Image.asset(
                                          'images/icon/is.png',
                                          height: 35,
                                          width: 35,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text('Iron Source Offerwall',
                                            style: TextStyle(fontSize: 20)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 125,
                                    width: 305,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.asset(
                                        'images/icon/isbanner.jpg',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 150,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => NotifMenu()));
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 50),
                        width: MediaQuery.of(context).size.width - 50,
                        height: 30.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey.withOpacity(0.2)),
                        child: Center(
                            child: Center(
                                child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 10,
                              height: 10,
                              child: FloatingActionButton(
                                backgroundColor: Colors.red,
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                                titleNotif == null
                                    ? 'Belum ada event'
                                    : '$titleNotif...',
                                style: TextStyle(
                                  fontSize: 15,
                                )),
                          ],
                        )))),
                  ),
                ),
              )
            ],
          ))
    ]);
  }

  @override
  void onInterstitialAdClicked() {
  }

  @override
  void onInterstitialAdClosed() {
  }

  @override
  void onInterstitialAdLoadFailed(IronSourceError error) {
  }

  @override
  void onInterstitialAdOpened() {
  }

  @override
  void onInterstitialAdReady() {
  }

  @override
  void onInterstitialAdShowFailed(IronSourceError error) {
  }

  @override
  void onInterstitialAdShowSucceeded() {
  }

  @override
  void onGetOfferwallCreditsFailed(IronSourceError error) {
  }

  @override
  void onOfferwallAdCredited(OfferwallCredit reward) {
    setState(() {
      currentCoin += reward.credits;
    });

    savetoPrefs(currentCoin);
    saveHistory(reward.credits, 'Offerwall Rewards');
    showDialog(
        context: context,
        builder: (context) => _onGetRewards(context, reward.credits));
    savetoDB(reward.credits);
  }

  @override
  void onOfferwallAvailable(bool available) {

    setState(() {
      offerwallAvailable = available;
    });
  }

  @override
  void onOfferwallClosed() {
  }

  @override
  void onOfferwallOpened() {
  }

  @override
  void onOfferwallShowFailed(IronSourceError error) {
  }

  @override
  void onRewardedVideoAdClicked(Placement placement) {
  }

  @override
  void onRewardedVideoAdClosed() {
  }

  @override
  void onRewardedVideoAdEnded() {
  }

  @override
  void onRewardedVideoAdOpened() {
  }

  @override
  void onRewardedVideoAdRewarded(Placement placement) {
  }

  @override
  void onRewardedVideoAdShowFailed(IronSourceError error) {
  }

  @override
  void onRewardedVideoAdStarted() {
  }

  @override
  void onRewardedVideoAvailabilityChanged(bool available) {

  }
}

_onGetRewards(BuildContext context, int coin) {
  return Stack(
    alignment: Alignment.center,
    children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width - 30,
        height: MediaQuery.of(context).size.height * 1 / 2,
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: 150, child: Image.asset('images/icon/fire.png')),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Selamat',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child:
                      Text('Kamu mendapatkan', style: TextStyle(fontSize: 15)),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 50,
                      child: Image.asset(
                        'images/icon/coin.png',
                      ),
                    ),
                    Text('+$coin',
                        style: TextStyle(color: Colors.amber, fontSize: 30)),
                  ],
                )
              ],
            )),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width - 20,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 1 / 8),
            child: FloatingActionButton(
              backgroundColor: Colors.amberAccent,
              child: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
      )
    ],
  );
}

Future savetoPrefs(int currentCoin) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setInt('coin', currentCoin);

  print('saved $currentCoin');
}

Future saveHistory(int coin, String from) async {
  DbHelper dbHelper = DbHelper();

  DateTime now = DateTime.now();
  String formattedDate = DateFormat('d MMM yyyy, h:mm').format(now);

  HistoryModel historyModel =
      HistoryModel(formattedDate, from, '+${coin.toString()}');
  await dbHelper.insert(historyModel);

  print('object created');
}

Future savetoDBFirst(int rewards) async {
  FetchData fetchData = new FetchData();
  fetchData.updateRewardsFirst(rewards.toString());
}

Future savetoDB(int rewards) async {
  FetchData fetchData = new FetchData();
  fetchData.updateRewards(rewards.toString());
}
