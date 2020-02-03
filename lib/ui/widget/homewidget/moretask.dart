import 'package:adcolony/AdColony.dart';
import 'package:adcolony/AdColonyBanner.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:dapetduit/ui/history.dart';
import 'package:dapetduit/ui/menuprofile.dart';
import 'package:dapetduit/ui/widget/homewidget/invite.dart';
import 'package:dapetduit/ui/widget/homewidget/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ironsource/ironsource.dart';
import 'package:ironsource/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_pollfish/flutter_pollfish.dart';

class MoreTask extends StatefulWidget {
  @override
  _MoreTaskState createState() => _MoreTaskState();
}

class _MoreTaskState extends State<MoreTask> with IronSourceListener , WidgetsBindingObserver {
  int currentCoin;
  bool isChecked;
  bool isRatingDone;
  bool isFollowDone;
  int currentDuration;

  bool rewardeVideoAvailable = false;
  final String appKey = "b0d4544d";


  

  @override
  void initState() {
    super.initState();
    AdColony.initialize(
        appId: 'app43d32624bcd54bf4af',
        zoneId: ['vzc35e4f02cdce434283', 'vzbe82fdc5d1e742808e'],
        consent: true);
    WidgetsBinding.instance.addObserver(this);
    init();
    FlutterPollfish.instance.hide();
    getCurrentCoin();
    checkRemaining();
    checkAllDone();
  }

  _requestInterstitial(String zoneId) {
    AdColony.requestInterstitial(
        zoneId: zoneId,
        listener: (AdColonyEvent event) {
          if (AdColonyEvent.onRequestFilled == event)
            AdColony.showAd();
          else if (AdColonyEvent.onRequestNotFilled == event)
            {
              Fluttertoast.showToast(
          msg:
          'Video tidak tersedia. Coba lagi nanti',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 14.0,
          backgroundColor: Colors.grey,
          textColor: Colors.white);
            }
          else {
            setState(() {
              currentCoin += 20;
            });
            savetoPrefs(currentCoin);
            saveHistory(20, 'Video Rewards');
            savetoDB(20);
            showDialog(
                context: context,
                builder: (context) => _onGetRewards(context, 20));
          }
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
  }

  Future checkRemaining() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isRemaining = prefs.getBool('remaining');
    String timeRemaining = prefs.getString('timeremaining');

    if (isRemaining == false) {
      setState(() {
        isChecked = false;
      });
    } else {
      setState(() {
        isChecked = true;
      });
    }

    if (timeRemaining != null) {
      List<String> listlastTime = timeRemaining.split(' ');
      List<String> listDate = listlastTime[0].split('-');
      List<String> listTime = listlastTime[1].split(':');

      int years = int.parse(listDate[0]);
      int month = int.parse(listDate[1]);
      int date = int.parse(listDate[2]);

      int hour = int.parse(listTime[0]);
      int minute = int.parse(listTime[1]);
      List<String> second = (listTime[2].split('.'));
      int newSecond = int.parse(second[0]);

      DateTime now = DateTime.now();
      DateTime last = DateTime(years, month, date, hour, minute, newSecond);

      final difference = now.difference(last).inSeconds;

      int newDiff = 24 * 3600 - difference;

      setState(() {
        currentDuration = newDiff;
      });
    } else {
      setState(() {
        currentDuration = 24 * 3600;
      });
    }
  }

  Future checkAllDone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isRatingDone = prefs.getBool('isRatingDone');

    if (isRatingDone == true) {
      setState(() {
        this.isRatingDone = true;
      });
    } else {
      this.isRatingDone = false;
    }
    bool isFollowDone = prefs.getBool('isFollowDone');

    if (isFollowDone == true) {
      setState(() {
        this.isFollowDone = true;
      });
    } else {
      this.isFollowDone = false;
    }
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
  }

    void showRewardedVideo() async {
    if (await IronSource.isRewardedVideoAvailable()) {
      IronSource.showRewardedVideol();
    } else {
      print("RewardedVideo not available");
    }
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffefeff4),
      appBar: AppBar(
        title: Text('Misi Lainnya'),
        backgroundColor: Color(0xff24bd64),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MenuProfile()));
          },
          child: Container(
              padding: EdgeInsets.all(15),
              child: Image.asset('images/icon/menu.png')),
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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(10),
                child: Text('Daily Tasks'),
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                    leading: Image.asset('images/icon/kalendar.png'),
                    title: Text('Misi Harian'),
                    subtitle: Text('Check-in Setiap Hari'),
                    trailing: RaisedButton(
                        color: Colors.amber,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: isChecked == null
                            ? SizedBox()
                            : isChecked
                                ? Text(
                                    '+120 Free',
                                    style: TextStyle(color: Colors.white),
                                  )
                                : CountdownFormatted(
                                    duration:
                                        Duration(seconds: currentDuration),
                                    onFinish: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setBool('remaining', true);
                                      prefs.setString('timeremaining', null);
                                      setState(() {
                                        isChecked = true;
                                      });
                                    },
                                    builder:
                                        (BuildContext ctx, String remaining) {
                                      return Text(
                                        remaining,
                                        style: TextStyle(color: Colors.white),
                                      );
                                    },
                                  ),
                        onPressed: () {
                          isChecked == true
                              ? giftMoreTask(150, 'Daily Task')
                              : gifNothing();
                          setState(() {
                            isChecked = false;
                          });
                        })),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(10),
                child: Text('Misi video'),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                        leading: Image.asset('images/icon/video.png'),
                        title: Text('Tonton Video (Jaringan 1)'),
                        subtitle: Text('Dapatkan koin untuk setiap view'),
                        trailing: RaisedButton(
                            color: Color(0xff24bd64),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            child: Text(
                              '+20',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              showRewardedVideo();
                            }),),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                        leading: Image.asset('images/icon/video2.png'),
                        title: Text('Tonton Video (Jaringan 2)'),
                        subtitle: Text('Dapatkan koin untuk setiap view'),
                        trailing: RaisedButton(
                            color: Color(0xff24bd64),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            child: Text(
                              '+20',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              _requestInterstitial('vzc35e4f02cdce434283');

                            }),),
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
                    isRatingDone == null
                        ? SizedBox()
                        : isRatingDone
                            ? SizedBox()
                            : ListTile(
                                leading: Image.asset('images/icon/star.png'),
                                title: Text('Misi Rating'),
                                trailing: RaisedButton(
                                    color: Color(0xff24bd64),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0)),
                                    child: Text(
                                      '+500',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              _giftRatingFollowDialog(
                                                  context,
                                                  'Silahkan Rating bintang 5 untuk mendapatkan 500 koin',
                                                  true));
                                    }),
                              ),
                    isFollowDone == null
                        ? SizedBox()
                        : isFollowDone
                            ? SizedBox()
                            : ListTile(
                                leading: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Image.asset(
                                    'images/icon/instagram.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                                title: Text('Misi Instagram'),
                                trailing: RaisedButton(
                                  color: Color(0xff24bd64),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0)),
                                  child: Text('+500',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            _giftRatingFollowDialog(
                                                context,
                                                'Silahkan Follow instagram untuk mendapatkan 500 koin',
                                                false));
                                  },
                                ),
                              ),
                    ListTile(
                      leading: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Image.asset(
                            'images/icon/people.png',
                            width: 30,
                            height: 30,
                          )),
                      title: Text('Undang Teman'),
                      trailing: RaisedButton(
                        color: Color(0xff24bd64),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: Icon(
                          Icons.monetization_on,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Invite()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future saveRemaining() async {
    DateTime now = DateTime.now();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('timeremaining', '$now');
    await prefs.setBool('remaining', false);
  }

  giftMoreTask(int newCoin, String from) async {
    await saveRemaining();
    checkRemaining();
    setState(() {
      currentCoin += newCoin;
    });
    savetoPrefs(currentCoin);
    saveHistory(newCoin, from);
    savetoDB(newCoin);
    showDialog(
        context: context,
        builder: (context) => _onGetRewards(context, newCoin));
  }

  gifNothing() {}

  _giftRatingFollowDialog(BuildContext context, String des, bool giftRating) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width - 30,
          height: MediaQuery.of(context).size.height * 1 / 2,
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 150,
                    height: 150,
                    child: FloatingActionButton(
                      elevation: 0.0,
                      backgroundColor: Colors.greenAccent,
                      child: Icon(
                        Icons.announcement,
                        size: 100,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Misi ini hanya berlaku satu kali',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(des,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width - 20,
                    margin: EdgeInsets.only(bottom: 20),
                    child: RaisedButton(
                      color: Color(0xff20d59e),
                      child:
                          Text('Lanjut', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.pop(context);
                        giftRating
                            ? _giftRatingFollow(
                                true,
                                'isRatingDone',
                                'https://play.google.com/store/apps/details?id=id.deris.dapetduit',
                                'Rating App')
                            : _giftRatingFollow(
                                false,
                                'isFollowDone',
                                'https://www.instagram.com/derisfl/',
                                'Follow Instagram');
                      },
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Future _giftRatingFollow(
      bool isRating, String keySet, String url, String from) async {
    isRating
        ? setState(() {
            this.isRatingDone = true;
          })
        : setState(() {
            this.isFollowDone = true;
          });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(keySet, true);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    await Future.delayed(Duration(seconds: 10));
    setState(() {
      currentCoin += 500;
    });
    savetoPrefs(currentCoin);
    saveHistory(500, from);
    savetoDB(500);
    showDialog(
        context: context, builder: (context) => _onGetRewards(context, 500));
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
    });

 
  }

  @override
  void onInterstitialAdReady() {
    print("onInterstitialAdReady");
    setState(() {
    });
  
  }

  @override
  void onInterstitialAdShowFailed(IronSourceError error) {

    print("onInterstitialAdShowFailed : ${error.toString()}");
    setState(() {
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

    print("onOfferwallAdCredited : $reward");
  }

  @override
  void onOfferwallAvailable(bool available) {
    print("onOfferwallAvailable : $available");

    setState(() {
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
    setState(() {
      currentCoin += 20;
    });

    savetoPrefs(currentCoin);
    saveHistory(20, 'Video Rewards');
    showDialog(
        context: context,
        builder: (context) => _onGetRewards(context, 20));
    savetoDB(20);
  }
 
  @override
  void onRewardedVideoAdShowFailed(IronSourceError error) {
  
    Fluttertoast.showToast(
          msg:
          'Video tidak tersedia. Coba lagi nanti',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 14.0,
          backgroundColor: Colors.grey,
          textColor: Colors.white);
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
