import 'package:dapetduit/helper/dbhelperNotif.dart';
import 'package:dapetduit/service/fetchdata.dart';
import 'package:dapetduit/ui/menuprofile.dart';
import 'package:dapetduit/ui/menuprofile/notifmenu.dart';
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

  bool rewardeVideoAvailable = false,
      offerwallAvailable = false,
      showBanner = false,
      interstitialReady = false;
  @override
  void initState() {
    super.initState();

    getLastNotifFromdb();
    getCurrentCoin();
    WidgetsBinding.instance.addObserver(this);
    init();
    giftRewardIfHaveRefferal();
  }

  Future  getLastNotifFromdb() async {
    DBHelperNotif.db.getLastNotif().then((title){

       List<String> titleNotifs = title.split(' ');
       
       setState(() {
        this.titleNotif = '${titleNotifs[0]} ${titleNotifs[1]} ${titleNotifs[2]}'; 
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

    if(isHaveRefferal) {
      setState(() {
      currentCoin += 150;
    });

    savetoPrefs(currentCoin);
    saveHistory(150, 'Refferal');
    rewardConfirm(context, 150);
    savetoDBFirst(150);
    }

    prefs.setBool('haveRefferal', false);
    
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
          msg:
              "Tunggu sebentar. Offerwall sedang di persiapkan",
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
                  onTap: (){
                     Navigator.push(context, MaterialPageRoute(
                  builder: (context) => MenuProfile()
                ));
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
                            onTap: (){
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
                                        padding: const EdgeInsets.only(left: 12),
                                        child: Image.asset(
                                          'images/icon/is.png',
                                          height: 35,
                                          width: 35,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
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
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Image.asset(
                                        'images/icon/is.png',
                                        height: 35,
                                        width: 35,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
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
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => NotifMenu()
                      ));
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
                                  SizedBox(width: 10,),
                                  Container(
                                    width: 10,
                                    height: 10,
                                    child: FloatingActionButton(
                                      backgroundColor: Colors.red,
                                      onPressed: (){},
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  Text(titleNotif==null? 'Belum ada event' :'$titleNotif...',
                                  style: TextStyle(
                                    fontSize: 15,
                                  )),
                                ],
                              )
                            ))),
                  ),
                ),
              )
            ],
          ))
    ]);
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
    rewardConfirm(context, reward.credits);
    savetoDB(reward.credits);
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
    
    int coin = 2;

    setState(() {
      currentCoin += coin;
    });
    savetoPrefs(currentCoin);
    rewardConfirm(context, coin);
    saveHistory(coin, 'Video Rewards');
    savetoDB(coin);
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

Future saveHistory(int coin, String from) async {
  DbHelper dbHelper = DbHelper();

  DateTime now = DateTime.now();
  String formattedDate = DateFormat('EEE d MMM').format(now);

  HistoryModel historyModel =
      HistoryModel(formattedDate, from, '+${coin.toString()}');
  await dbHelper.insert(historyModel);

  print('object created');
}

Future savetoDBFirst(int rewards) async{
  FetchData fetchData = new FetchData();
  fetchData.updateRewardsFirst(rewards.toString());
}
Future savetoDB(int rewards) async{
  FetchData fetchData = new FetchData();
  fetchData.updateRewards(rewards.toString());
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
