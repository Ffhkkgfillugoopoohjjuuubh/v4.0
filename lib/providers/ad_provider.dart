import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdProvider extends StateNotifier<bool> {
  AdProvider() : super(false);

  void setAdEnabled(bool enabled) {
    state = enabled;
  }
}

final adProvider = StateNotifierProvider<AdProvider, bool>((ref) => AdProvider());