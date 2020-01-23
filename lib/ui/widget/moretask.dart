import 'package:flutter/material.dart';
import 'package:ironsource/ironsource.dart';
import 'package:ironsource/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoreTask extends StatefulWidget {
  @override
  _MoreTaskState createState() => _MoreTaskState();
}

class _MoreTaskState extends State<MoreTask> with IronSourceListener , WidgetsBindingObserver {

  int currentCoin = 0;

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
    }
    else {
      setState(() {
       currentCoin = coin; 
      });
    }  
  }


  @override
void didChangeAppLifecycleState(AppLifecycleState state) { 
 switch(state){

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
      print("Offerwall not available");
    }
  }

  void showRewardedVideo() async {
    if (await IronSource.isRewardedVideoAvailable()) {
      IronSource.showRewardedVideol();
    } else {
      print("RewardedVideo not available");
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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Text('Rewarded Task'),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.stars),
                      title: Text('Fantastic Offer Wall'),
                      subtitle: Text('Unlimited credits. Complete task'),
                      trailing: Icon(Icons.fiber_dvr),
                      onTap: offerwallAvailable ? showOfferwall : null,
                    ),
                    ListTile(
                      leading: Icon(Icons.stars),
                      title: Text('Awesome Offer Wall'),
                      subtitle: Text('Unlimited credits. Complete task'),
                      trailing: Icon(Icons.fiber_dvr),
                    ),
                    ListTile(
                      leading: Icon(Icons.stars),
                      title: Text('Super Offer Wall'),
                      subtitle: Text('Highly Rewarded Task. Unlimited'),
                      trailing: Icon(Icons.fiber_dvr),
                    ),
                    ListTile(
                      leading: Icon(Icons.stars, size: 50,),
                      title: Text('Watch Videos'),
                      subtitle: Text('Get Credits per video view'),
                      trailing: Icon(Icons.fiber_dvr),
                      onTap: rewardeVideoAvailable ? showRewardedVideo : null,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text('Starter Tasks'),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.star),
                      title: Text('Review Task'),
                      trailing: RaisedButton(
                        child: Icon(Icons.favorite),
                        onPressed: (){},
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text('Complete Profile Task'),
                      trailing: RaisedButton(
                        child: Text('+50'),
                        onPressed: (){},
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.face),
                      title: Text('Facebook Task'),
                      trailing: RaisedButton(
                        child: Text('+100'),
                        onPressed: (){},
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.people),
                      title: Text('Invite Friends'),
                      trailing: RaisedButton(
                        child: Icon(Icons.favorite),
                        onPressed: (){},
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

    print("onOfferwallAdCredited : $reward");
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

    print("onRewardedVideoAdRewarded: ${placement.placementName}");
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