
import 'package:admob_flutter/admob_flutter.dart';
import 'package:goodvibes/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdsProvider {
  SharedPreferences _preferences;
  AdmobBanner sliderBanner;

  AdmobBanner homeBanner;
//  AdmobInterstitial interestialAdVideo;
  AdmobInterstitial rewardAd;
  AdmobBanner adbanner;
  AdmobInterstitial interstitialAd;
  AdmobBanner footerBanner;

  AdsProvider() {
//    initAds();
  initTestAds();
  }
  initAds() async {
    _preferences = await SharedPreferences.getInstance();
    bool isPaid = _preferences.getBool('paid');
    if (isPaid == null || isPaid == false) {
      Admob.initialize(isAndroid
          ? 'ca-app-pub-7840965189622219~1267722474'
          : 'ca-app-pub-7840965189622219~3447224606');

      interstitialAd = AdmobInterstitial(
        adUnitId: isAndroid
            ? 'ca-app-pub-7840965189622219/2099690824'
            : 'ca-app-pub-7840965189622219/5250220857',
      );

      adbanner = AdmobBanner(
        adUnitId: isAndroid
            ? 'ca-app-pub-7840965189622219/7422067280'
            : 'ca-app-pub-7840965189622219/2442441727',
        adSize: AdmobBannerSize.LARGE_BANNER,
      );

      sliderBanner = AdmobBanner(
        adUnitId: isAndroid
            ? 'ca-app-pub-7840965189622219/7422067280'
            : 'ca-app-pub-7840965189622219/2442441727',
        adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
      );
      homeBanner = AdmobBanner(
        adUnitId: isAndroid
            ? 'ca-app-pub-7840965189622219/7422067280'
            : 'ca-app-pub-7840965189622219/2442441727',
        adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
      );
    }
  }

  initTestAds() async {
    _preferences = await SharedPreferences.getInstance();
    bool isPaid = _preferences.getBool('paid');
    if (isPaid == null || isPaid == false) {
      Admob.initialize(isAndroid
          ? 'ca-app-pub-7840965189622219~1267722474'
          : 'ca-app-pub-7840965189622219~3447224606');

      interstitialAd = AdmobInterstitial(
        adUnitId: isAndroid
            ? 'ca-app-pub-3940256099942544/1033173712'
            : 'ca-app-pub-3940256099942544/1033173712',
      );

//      interestialAdVideo = AdmobInterstitial(
//        adUnitId: isAndroid
//            ? 'ca-app-pub-3940256099942544/8691691433'
//            : 'ca-app-pub-3940256099942544/8691691433',
//          listener: (AdmobAdEvent event, Map<String, dynamic> args) {
//            handleEvent(event, args, 'Interstial Videos');
//          }
//      );

      adbanner = AdmobBanner(
        adUnitId: isAndroid
            ? 'ca-app-pub-3940256099942544/6300978111'
            : 'ca-app-pub-3940256099942544/6300978111',
        adSize: AdmobBannerSize.LARGE_BANNER,
      );

      sliderBanner = AdmobBanner(
        adUnitId: isAndroid
            ? 'ca-app-pub-3940256099942544/6300978111'
            : 'ca-app-pub-3940256099942544/6300978111',
        adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
      );

      homeBanner = AdmobBanner(
        adUnitId: isAndroid
            ? 'ca-app-pub-3940256099942544/6300978111'
            : 'ca-app-pub-3940256099942544/6300978111',
        adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
      );

      footerBanner = AdmobBanner(
        adUnitId: isAndroid
            ? 'ca-app-pub-3940256099942544/6300978111'
            : 'ca-app-pub-3940256099942544/6300978111',
        adSize: AdmobBannerSize.BANNER,
      );
      rewardAd = AdmobInterstitial(
        adUnitId: isAndroid
            ? 'ca-app-pub-3940256099942544/8691691433'
            : 'ca-app-pub-3940256099942544/8691691433',
          listener: (AdmobAdEvent event, Map<String, dynamic> args) {
            handleEvent(event, args, 'Reward Videos');
          }
      );

      rewardAd.load();
//      interestialAdVideo.load();
    }
  }

//  showinterestialAdsVideo() async {
//    interestialAdVideo.load();
//    if (await interestialAdVideo.isLoaded) {
//      interestialAdVideo.show();
//    }else
//      print('''
//          Log.d("TAG", "The interstitial wasn't loaded yet.")
//  ''');
//  }

  showRewardAdsVideo()  {
    rewardAd..load()..show();
//    if (await rewardAd.isLoaded) {
//      rewardAd.show();
//    }else
//      print('''
//          Log.d("TAG", "The interstitial wasn't loaded yet.")
//  ''');
  }


  showinterestialAds() async {
    if (await interstitialAd.isLoaded) {
      interstitialAd.show();
    }
  }
}

void handleEvent(AdmobAdEvent event, Map<String, dynamic>  args , String adsTypes) {
  switch(event){
    case AdmobAdEvent.loaded:{
      print('Admob $adsTypes loaded. :(');
      break;
    }

    case AdmobAdEvent.failedToLoad:
      print('Admob $adsTypes failed to load. :(');
      break;
    case AdmobAdEvent.clicked:
      // TODO: Handle this case.
      break;
    case AdmobAdEvent.impression:
      // TODO: Handle this case.
      break;
    case AdmobAdEvent.opened:
      print('Admob $adsTypes opened :(');
      break;
    case AdmobAdEvent.leftApplication:
      // TODO: Handle this case.
      break;
    case AdmobAdEvent.closed:
      print('Admob $adsTypes closed :(');
      break;
    case AdmobAdEvent.completed:
      print('Admob $adsTypes failed to complected :(');
      break;
    case AdmobAdEvent.rewarded:
      // TODO: Handle this case.
      break;
    case AdmobAdEvent.started:
      break;
  }
}

