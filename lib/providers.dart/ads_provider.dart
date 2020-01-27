import 'package:admob_flutter/admob_flutter.dart';
import 'package:goodvibes/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdsProvider {
  SharedPreferences _preferences;
  AdmobBanner sliderBanner;

  AdmobBanner homeBanner;
  AdmobBanner adbanner;
  AdmobBanner footerBanner;

  AdsProvider() {
    initTestAds();
  }

  initTestAds() async {
    _preferences = await SharedPreferences.getInstance();
    bool isPaid = _preferences.getBool('paid');
    if (isPaid == null || isPaid == false) {
      Admob.initialize(isAndroid
          ? 'ca-app-pub-4284307101881172~6388287871'
          : 'ca-app-pub-4284307101881172~6359328012');
//          : 'ca-app-pub-7840965189622219~3447224606');

      adbanner = AdmobBanner(
//        unit test
//        adUnitId: isAndroid
//            ? 'ca-app-pub-3940256099942544/6300978111'
//            : 'ca-app-pub-3940256099942544/6300978111',
//        adSize: AdmobBannerSize.LARGE_BANNER,

        adUnitId: isAndroid
            ? 'ca-app-pub-4284307101881172/8509038420'
            : 'ca-app-pub-4284307101881172/2594797960',
        adSize: AdmobBannerSize.LARGE_BANNER,
      );

      sliderBanner = AdmobBanner(
//        adUnitId: isAndroid
//            ? 'ca-app-pub-3940256099942544/6300978111'
//            : 'ca-app-pub-3940256099942544/6300978111',
//        adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
        adUnitId: isAndroid
            ? 'ca-app-pub-4284307101881172/8509038420'
            : 'ca-app-pub-4284307101881172/2594797960',
        adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
      );

      homeBanner = AdmobBanner(
        adUnitId: isAndroid
            ? 'ca-app-pub-4284307101881172/8509038420'
            : 'ca-app-pub-4284307101881172/2594797960',
        adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
      );

      footerBanner = AdmobBanner(
        adUnitId: isAndroid
            ? 'ca-app-pub-4284307101881172/8509038420'
            : 'ca-app-pub-4284307101881172/2594797960',
        adSize: AdmobBannerSize.BANNER,
      );
    }
  }
}
