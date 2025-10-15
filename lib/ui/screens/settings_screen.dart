import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/localization_provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_colors.dart';

/// Диалог настроек
class SettingsDialog extends ConsumerWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final locale = ref.watch(localizationProvider);
    final isDark = settings.themeMode == ThemeMode.dark;

    return Dialog(
      backgroundColor: AppColors.getBackground(isDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Заголовок
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 16, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locale.settings,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.getPrimary(isDark),
                      letterSpacing: 1.0,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 28),
                    color: AppColors.getSecondary(isDark),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            // Содержимое
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // Переключатель темы
                  _buildSwitchTile(
                    context: context,
                    locale: locale,
                    isDark: isDark,
                    icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    iconColor: AppColors.getSecondary(isDark),
                    title: locale.darkTheme,
                    value: isDark,
                    onChanged: (value) => settingsNotifier.toggleTheme(),
                  ),
                  const SizedBox(height: 8),
                  // Переключатель звуков
                  _buildSwitchTile(
                    context: context,
                    locale: locale,
                    isDark: isDark,
                    icon: Icons.volume_up_rounded,
                    iconColor: AppColors.getSecondary(isDark),
                    title: locale.sounds,
                    value: settings.isSoundsEnabled,
                    onChanged: (value) => settingsNotifier.toggleSounds(),
                  ),
                  const SizedBox(height: 8),
                  // Переключатель музыки
                  _buildSwitchTile(
                    context: context,
                    locale: locale,
                    isDark: isDark,
                    icon: Icons.music_note_rounded,
                    iconColor: AppColors.getSecondary(isDark),
                    title: locale.music,
                    value: settings.isMusicEnabled,
                    onChanged: (value) => settingsNotifier.toggleMusic(),
                  ),
                  const SizedBox(height: 8),
                  // Переключатель вибрации
                  _buildSwitchTile(
                    context: context,
                    locale: locale,
                    isDark: isDark,
                    icon: Icons.vibration_rounded,
                    iconColor: AppColors.getSecondary(isDark),
                    title: locale.vibration,
                    value: settings.isVibrationEnabled,
                    onChanged: (value) => settingsNotifier.toggleVibration(),
                  ),
                  const SizedBox(height: 8),
                  // Notifications (заглушка)
                  _buildSwitchTile(
                    context: context,
                    locale: locale,
                    isDark: isDark,
                    icon: Icons.notifications_rounded,
                    iconColor: AppColors.getSecondary(isDark),
                    title: 'Notifications',
                    value: false,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  // Выбор языка
                  _buildNavigationTile(
                    context: context,
                    isDark: isDark,
                    icon: Icons.language_rounded,
                    iconColor: AppColors.getSecondary(isDark),
                    title: locale.languageLabel,
                    subtitle: settings.language == AppLanguage.english
                        ? locale.english
                        : locale.ukrainian,
                    onTap: () => _showLanguageDialog(context, ref),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required AppLocalizations locale,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.getSurface(isDark).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          icon,
          color: iconColor,
          size: 28,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.getPrimary(isDark),
          ),
        ),
        trailing: Transform.scale(
          scale: 0.85,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.getAccent(isDark),
            activeTrackColor: AppColors.getAccent(isDark),
            inactiveThumbColor: AppColors.getSurface(isDark),
            inactiveTrackColor: AppColors.getSecondary(isDark).withValues(alpha: 0.3),
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ),
        onTap: () => onChanged(!value),
      ),
    );
  }

  Widget _buildNavigationTile({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.getSurface(isDark).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          icon,
          color: iconColor,
          size: 28,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.getPrimary(isDark),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.getSecondary(isDark),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: AppColors.getSecondary(isDark),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const LanguageSelectionDialog(),
    );
  }
}

/// Диалог выбора языка
class LanguageSelectionDialog extends ConsumerWidget {
  const LanguageSelectionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final locale = ref.watch(localizationProvider);
    final isDark = settings.themeMode == ThemeMode.dark;

    return Dialog(
      backgroundColor: AppColors.getBackground(isDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 350),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Заголовок
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  locale.selectLanguage,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.getPrimary(isDark),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 26),
                  color: AppColors.getSecondary(isDark),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Список языков
            _buildLanguageOption(
              context: context,
              isDark: isDark,
              title: locale.english,
              isSelected: settings.language == AppLanguage.english,
              onTap: () {
                settingsNotifier.setLanguage(AppLanguage.english);
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 12),
            _buildLanguageOption(
              context: context,
              isDark: isDark,
              title: locale.ukrainian,
              isSelected: settings.language == AppLanguage.ukrainian,
              onTap: () {
                settingsNotifier.setLanguage(AppLanguage.ukrainian);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required bool isDark,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.getAccent(isDark).withValues(alpha: 0.3)
              : AppColors.getSurface(isDark).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppColors.getAccent(isDark), width: 2)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: isSelected ? AppColors.getAccent(isDark) : AppColors.getSecondary(isDark),
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.getPrimary(isDark) : AppColors.getTertiary(isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Показать диалог настроек
void showSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const SettingsDialog(),
  );
}
