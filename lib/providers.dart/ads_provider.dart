import 'package:admob_flutter/admob_flutter.dart';
import 'package:goodvibes/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdsProvider {
  SharedPreferences _preferences;
  AdmobBanner sliderBanner;

  AdmobBanner homeBanner;
  AdmobBanner adbanner;
  AdmobInterstitial interstitialAd;

  AdsProvider() {
    initAds();
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

  showinterestialAds() async {
    interstitialAd.load();
    if (await interstitialAd.isLoaded) {
      interstitialAd.show();
    }
  }
}
