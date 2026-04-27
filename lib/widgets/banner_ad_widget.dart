import 'package:flutter/material.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  final String adUnitId;
  final String position;

  const BannerAdWidget({
    super.key,
    required this.adUnitId,
    required this.position,
  });

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 0);
  }
}