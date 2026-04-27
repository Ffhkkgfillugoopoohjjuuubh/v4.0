import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  final String appLanguage;
  final String voiceLanguage;
  final ThemeMode themeMode;
  final double fontSize;
  final double volume;
  final double pitch;
  final double speechRate;

  AppSettings({
    required this.appLanguage,
    required this.voiceLanguage,
    required this.themeMode,
    required this.fontSize,
    required this.volume,
    required this.pitch,
    required this.speechRate,
  });

  AppSettings copyWith({
    String? appLanguage,
    String? voiceLanguage,
    ThemeMode? themeMode,
    double? fontSize,
    double? volume,
    double? pitch,
    double? speechRate,
  }) {
    return AppSettings(
      appLanguage: appLanguage ?? this.appLanguage,
      voiceLanguage: voiceLanguage ?? this.voiceLanguage,
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      volume: volume ?? this.volume,
      pitch: pitch ?? this.pitch,
      speechRate: speechRate ?? this.speechRate,
    );
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  throw UnimplementedError();
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  final SharedPreferences _prefs;

  SettingsNotifier(this._prefs) : super(AppSettings(
    appLanguage: _prefs.getString('appLanguage') ?? 'en',
    voiceLanguage: _prefs.getString('voiceLanguage') ?? 'en',
    themeMode: ThemeMode.values[_prefs.getInt('themeMode') ?? 0],
    fontSize: _prefs.getDouble('fontSize') ?? 16.0,
    volume: _prefs.getDouble('volume') ?? 1.0,
    pitch: _prefs.getDouble('pitch') ?? 1.15,
    speechRate: _prefs.getDouble('speechRate') ?? 0.42,
  ));

  void updateAppLanguage(String lang) {
    state = state.copyWith(appLanguage: lang);
    _prefs.setString('appLanguage', lang);
  }

  void updateVoiceLanguage(String lang) {
    state = state.copyWith(voiceLanguage: lang);
    _prefs.setString('voiceLanguage', lang);
  }

  void updateThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _prefs.setInt('themeMode', mode.index);
  }

  void updateFontSize(double size) {
    state = state.copyWith(fontSize: size);
    _prefs.setDouble('fontSize', size);
  }

  void updateVolume(double vol) {
    state = state.copyWith(volume: vol);
    _prefs.setDouble('volume', vol);
  }

  void updatePitch(double pitch) {
    state = state.copyWith(pitch: pitch);
    _prefs.setDouble('pitch', pitch);
  }

  void updateSpeechRate(double rate) {
    state = state.copyWith(speechRate: rate);
    _prefs.setDouble('speechRate', rate);
  }
}
