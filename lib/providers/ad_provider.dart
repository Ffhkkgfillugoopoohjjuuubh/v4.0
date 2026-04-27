import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdProvider extends ChangeNotifier {
  BannerAd? _topBannerAd;
  BannerAd? _bottomBannerAd;
  bool _isTopLoaded = false;
  bool _isBottomLoaded = false;

  BannerAd? get topBannerAd => _topBannerAd;
  BannerAd? get bottomBannerAd => _bottomBannerAd;
  bool get isTopLoaded => _isTopLoaded;
  bool get isBottomLoaded => _isBottomLoaded;

  static const String topAdUnitId = 'ca-app-pub-4160048627212561/6528052382';
  static const String bottomAdUnitId = 'ca-app-pub-4160048627212561/5539450520';

  void reloadAds() {
    _topBannerAd?.dispose();
    _bottomBannerAd?.dispose();
    _isTopLoaded = false;
    _isBottomLoaded = false;
    
    _loadTopBanner();
    _loadBottomBanner();
  }

  void _loadTopBanner() {
    _topBannerAd = BannerAd(
      adUnitId: topAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _isTopLoaded = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _isTopLoaded = false;
          notifyListeners();
        },
      ),
    )..load();
  }

  void _loadBottomBanner() {
    _bottomBannerAd = BannerAd(
      adUnitId: bottomAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _isBottomLoaded = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _isBottomLoaded = false;
          notifyListeners();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _topBannerAd?.dispose();
    _bottomBannerAd?.dispose();
    super.dispose();
  }
}

final adProvider = ChangeNotifierProvider((ref) => AdProvider());
