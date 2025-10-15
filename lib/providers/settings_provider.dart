import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Поддерживаемые языки
enum AppLanguage {
  english,
  ukrainian,
}

/// Провайдер для управления настройками приложения
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState());

  /// Переключить тему
  void toggleTheme() {
    state = state.copyWith(
      themeMode: state.themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light,
    );
  }

  /// Установить конкретную тему
  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  /// Переключить музыку
  void toggleMusic() {
    state = state.copyWith(isMusicEnabled: !state.isMusicEnabled);
  }

  /// Переключить звуки
  void toggleSounds() {
    state = state.copyWith(isSoundsEnabled: !state.isSoundsEnabled);
  }

  /// Переключить вибрацию
  void toggleVibration() {
    state = state.copyWith(isVibrationEnabled: !state.isVibrationEnabled);
  }

  /// Установить язык
  void setLanguage(AppLanguage language) {
    state = state.copyWith(language: language);
  }
}

/// Состояние настроек
class SettingsState {
  final ThemeMode themeMode;
  final bool isMusicEnabled;
  final bool isSoundsEnabled;
  final bool isVibrationEnabled;
  final AppLanguage language;

  SettingsState({
    this.themeMode = ThemeMode.light,
    this.isMusicEnabled = true,
    this.isSoundsEnabled = true,
    this.isVibrationEnabled = true,
    this.language = AppLanguage.english,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    bool? isMusicEnabled,
    bool? isSoundsEnabled,
    bool? isVibrationEnabled,
    AppLanguage? language,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      isMusicEnabled: isMusicEnabled ?? this.isMusicEnabled,
      isSoundsEnabled: isSoundsEnabled ?? this.isSoundsEnabled,
      isVibrationEnabled: isVibrationEnabled ?? this.isVibrationEnabled,
      language: language ?? this.language,
    );
  }
}

/// Провайдер настроек
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
