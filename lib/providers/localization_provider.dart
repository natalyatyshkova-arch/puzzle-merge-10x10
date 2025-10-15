import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_provider.dart';

/// Провайдер локализации
final localizationProvider = Provider<AppLocalizations>((ref) {
  final language = ref.watch(settingsProvider.select((s) => s.language));
  return AppLocalizations(language);
});

/// Локализация приложения
class AppLocalizations {
  final AppLanguage language;

  AppLocalizations(this.language);

  // Общие
  String get settings => language == AppLanguage.english ? 'SETTINGS' : 'НАЛАШТУВАННЯ';
  String get close => language == AppLanguage.english ? 'Close' : 'Закрити';
  String get cancel => language == AppLanguage.english ? 'CANCEL' : 'СКАСУВАТИ';
  String get ok => language == AppLanguage.english ? 'OK' : 'ОК';

  // Игра
  String get score => language == AppLanguage.english ? 'SCORE' : 'РАХУНОК';
  String get newGame => language == AppLanguage.english ? 'NEW GAME' : 'НОВА ГРА';
  String get newGameTitle => language == AppLanguage.english ? 'New Game' : 'Нова гра';
  String get newGameMessage =>
      language == AppLanguage.english
          ? 'Start a new game? Current progress will be lost.'
          : 'Почати нову гру? Поточний прогрес буде втрачено.';
  String get gameOver => language == AppLanguage.english ? 'Game Over!' : 'Гра закінчена!';
  String get gameOverMessage =>
      language == AppLanguage.english
          ? 'No more moves available!'
          : 'Більше немає доступних ходів!';
  String get finalScore => language == AppLanguage.english ? 'Final score' : 'Фінальний рахунок';

  // Настройки
  String get darkTheme => language == AppLanguage.english ? 'DARK THEME' : 'ТЕМНА ТЕМА';
  String get enabled => language == AppLanguage.english ? 'Enabled' : 'Увімкнено';
  String get disabled => language == AppLanguage.english ? 'Disabled' : 'Вимкнено';
  String get music => language == AppLanguage.english ? 'MUSIC' : 'МУЗИКА';
  String get sounds => language == AppLanguage.english ? 'SOUNDS' : 'ЗВУКИ';
  String get vibration => language == AppLanguage.english ? 'VIBRATION' : 'ВІБРАЦІЯ';
  String get languageLabel => language == AppLanguage.english ? 'LANGUAGE' : 'МОВА';
  String get selectLanguage =>
      language == AppLanguage.english ? 'SELECT LANGUAGE' : 'ВИБЕРІТЬ МОВУ';
  String get english => 'English';
  String get ukrainian => 'Українська';
}
