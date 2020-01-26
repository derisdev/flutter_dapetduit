import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dapetduit/ui/user/phoneverification.dart';
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
  int currentOfferwallDone;

  List<HistoryModel> listHistory = [];

  final String appKey = "b0d4544d";

  bool rewardeVideoAvailable = false,
      offerwallAvailable = false,
      showBanner = false,
      interstitialReady = false;
  @override
  void initState() {
    super.initState();

    getCurrentCoin();
    WidgetsBinding.instance.addObserver(this);
    init();
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

  Future getCurrentOfferwallDone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentDone = prefs.getInt('offerwallDone');
    if (currentDone == null) {
      setState(() {
        currentOfferwallDone = 0;
      });
    } else {
      setState(() {
        currentOfferwallDone = currentDone;
      });
    }
    print('currentOfferwallDone $currentOfferwallDone');

    if (currentOfferwallDone == 2) {
      giftRewards();
    }
  }

  Future giftRewards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String refferalCodeRefferer = prefs.getString('refferal_code_refferer');
    String refferalCodeOwner = prefs.getString('refferal_code_owner');

    String baseUrl =
        "https://dapetduitrestapi.000webhostapp.com/api/v1/user/gift_refferal";
    var response = await http.post(baseUrl, headers: {
      "Accept": "application/json"
    }, body: {
      'refferal_code_refferer': refferalCodeRefferer,
      'refferal_code_owner': refferalCodeOwner
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        currentCoin += 2;
      });

      savetoPrefs(currentCoin);
      final jsonData = json.decode(response.body);
      int rewards = jsonData['refferal_code_owner'];

      DbHelper dbHelper = DbHelper();
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('EEE d MMM').format(now);

      int totalRewards = 2;

      HistoryModel historyModel =
          HistoryModel(formattedDate, 'Refferal', '+$totalRewards');
      await dbHelper.insert(historyModel);

      print('Data rewards refferal inserted');

      prefs.setInt('rewards_from_refferal', rewards);
    }
    print(response.body);
    prefs.setInt('offerwallDone', 5);
  }

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
    rewardeVideoAvailable = await IronSource.isRewardedVideoAvailable();
    offerwallAvailable = await IronSource.isOfferwallAvailable();
    setState(() {});
  }

  void loadInterstitial() {
    IronSource.loadInterstitial();
  }

  void showInterstitial() async {
    if (await IronSource.isInterstitialReady()) {
      IronSource.showInterstitial();
    } else {
      print(
        "Interstial is not ready. use 'Ironsource.loadInterstial' before showing it",
      );
    }
  }

  void showOfferwall() async {
    if (await IronSource.isOfferwallAvailable()) {
      IronSource.showOfferwall();
    } else {
      Fluttertoast.showToast(
          msg: "Offerwall belum tersedia untuk saat ini. Tunggu beberapa saat lagi",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Color(0xff24bd64),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void showRewardedVideo() async {
    if (await IronSource.isRewardedVideoAvailable()) {
      IronSource.showRewardedVideol();
    } else {
      Fluttertoast.showToast(
          msg: "Video Rewards tidak tersedia untuk saat ini",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Color(0xff24bd64),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void showHideBanner() {
    setState(() {
      showBanner = !showBanner;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Misi'),
        backgroundColor: Color(0xff24bd64),
        leading: IconButton(
          icon: Icon(Icons.phone),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PhoneVerification()));
          },
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => History()));
            },
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
                        : Text('$currentCoin', style: TextStyle(fontSize: 30)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      backgroundColor: Color(0xffefeff4),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 5),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(10),
                child: Text('Rewarded Task'),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                        leading: Image.asset('images/icon/offerwall.png'),
                        title: Text('Iron Source Offer Wall'),
                        subtitle: Text('Unlimited credits. Complete task'),
                        trailing: RaisedButton(
                            color: Color(0xff24bd64),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            child: Text(
                              '+2000',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: showOfferwall),
                        onTap: () {}),
                    Divider(),
                    ListTile(
                        leading: Image.asset('images/icon/video.png'),
                        title: Text('Tonton Video'),
                        subtitle: Text('Dapatkan koin untuk setiap view'),
                        trailing: RaisedButton(
                            color: Color(0xff24bd64),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            child: Text(
                              '+20',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: showRewardedVideo),
                        onTap: () {}),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(10),
                child: Text('Misi Pemula'),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Image.asset('images/icon/star.png'),
                      title: Text('Misi Review'),
                      trailing: RaisedButton(
                        color: Color(0xff24bd64),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: Text(
                          '+200',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Image.asset(
                          'images/icon/fb.png',
                          width: 30,
                          height: 30,
                        ),
                      ),
                      title: Text('Misi Facebook'),
                      trailing: RaisedButton(
                        color: Color(0xff24bd64),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child:
                            Text('+100', style: TextStyle(color: Colors.white)),
                        onPressed: () {},
                      ),
                    ),
                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: Icon(
                          Icons.people_outline,
                          size: 40,
                          color: Colors.cyan,
                        ),
                      ),
                      title: Text('Undang Teman'),
                      trailing: RaisedButton(
                        color: Color(0xff24bd64),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: Icon(
                          Icons.monetization_on,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onInterstitialAdClicked() {
    print("onInterstitialAdClicked");
  }

  @override
  void onInterstitialAdClosed() {
    print("onInterstitialAdClosed");
  }

  @override
  void onInterstitialAdLoadFailed(IronSourceError error) {
    print("onInterstitialAdLoadFailed : ${error.toString()}");
  }

  @override
  void onInterstitialAdOpened() {
    print("onInterstitialAdOpened");
    setState(() {
      interstitialReady = false;
    });
  }

  @override
  void onInterstitialAdReady() {
    print("onInterstitialAdReady");
    setState(() {
      interstitialReady = true;
    });
  }

  @override
  void onInterstitialAdShowFailed(IronSourceError error) {
    print("onInterstitialAdShowFailed : ${error.toString()}");
    setState(() {
      interstitialReady = false;
    });
  }

  @override
  void onInterstitialAdShowSucceeded() {
    print("nInterstitialAdShowSucceeded");
  }

  @override
  void onGetOfferwallCreditsFailed(IronSourceError error) {
    print("onGetOfferwallCreditsFailed : ${error.toString()}");
  }

  @override
  void onOfferwallAdCredited(OfferwallCredit reward) {
    print("onOfferwallAdCredited : ${reward.credits}");
    setState(() {
      currentCoin += reward.credits;
    });

    savetoPrefs(currentCoin);

    saveHistory(reward.credits, 'Offerwall Rewards');

    //memberikan rewards rfferal ketika user menyelesaikan 2 offerwall

    setState(() {
      currentOfferwallDone += 1;
    });

    cekDone(currentOfferwallDone);
    getCurrentOfferwallDone();

  }

  @override
  void onOfferwallAvailable(bool available) {
    print("onOfferwallAvailable : $available");

    setState(() {
      offerwallAvailable = available;
    });
  }

  @override
  void onOfferwallClosed() {
    print("onOfferwallClosed");
  }

  @override
  void onOfferwallOpened() {
    print("onOfferwallOpened");
  }

  @override
  void onOfferwallShowFailed(IronSourceError error) {
    print("onOfferwallShowFailed ${error.toString()}");
  }

  @override
  void onRewardedVideoAdClicked(Placement placement) {
    print("onRewardedVideoAdClicked");
  }

  @override
  void onRewardedVideoAdClosed() {
    print("onRewardedVideoAdClosed");

    int coin = 2;

    setState(() {
      currentCoin += coin;
    });
    savetoPrefs(currentCoin);
    rewardConfirm(context, coin);
    saveHistory(coin, 'Video Rewards');
  }

  @override
  void onRewardedVideoAdEnded() {
    print("onRewardedVideoAdEnded");
  }

  @override
  void onRewardedVideoAdOpened() {
    print("onRewardedVideoAdOpened");
  }

  @override
  void onRewardedVideoAdRewarded(Placement placement) {
    print("onRewardedVideoAdRewarded: ${placement.rewardAmount}");
  }

  @override
  void onRewardedVideoAdShowFailed(IronSourceError error) {
    print("onRewardedVideoAdShowFailed : ${error.toString()}");
  }

  @override
  void onRewardedVideoAdStarted() {
    print("onRewardedVideoAdStarted");
  }

  @override
  void onRewardedVideoAvailabilityChanged(bool available) {
    print("onRewardedVideoAvailabilityChanged : $available");
    setState(() {
      rewardeVideoAvailable = available;
    });
  }
}

Future<Null> rewardConfirm(BuildContext context, int coin) async {
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            SimpleDialogOption(
                onPressed: () {},
                child: Container(child: Center(child: Text('Great!!')))),
            SimpleDialogOption(
                onPressed: () {},
                child: Text('Kamu Mendapatkan koin sebesar: $coin'))
          ],
        );
      });
}

Future savetoPrefs(int currentCoin) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setInt('coin', currentCoin);

  print('saved $currentCoin');
}

saveHistory(int coin, String from) async {
  DbHelper dbHelper = DbHelper();

  DateTime now = DateTime.now();
  String formattedDate = DateFormat('EEE d MMM').format(now);

  HistoryModel historyModel =
      HistoryModel(formattedDate, from, '+${coin.toString()}');
  await dbHelper.insert(historyModel);

  print('object created');
}

Future cekDone(int currentOfferwallDone) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('offerwallDone', currentOfferwallDone);
  
}

class BannerAdListener extends IronSourceBannerListener {
  @override
  void onBannerAdClicked() {
    print("onBannerAdClicked");
  }

  @override
  void onBannerAdLeftApplication() {
    print("onBannerAdLeftApplication");
  }

  @override
  void onBannerAdLoadFailed(Map<String, dynamic> error) {
    print("onBannerAdLoadFailed");
  }

  @override
  void onBannerAdLoaded() {
    print("onBannerAdLoaded");
  }

  @override
  void onBannerAdScreenDismissed() {
    print("onBannerAdScreenDismisse");
  }

  @override
  void onBannerAdScreenPresented() {
    print("onBannerAdScreenPresented");
  }
}
