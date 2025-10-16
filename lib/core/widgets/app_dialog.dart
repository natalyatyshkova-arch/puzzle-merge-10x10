import 'package:flutter/material.dart';
import '../theme/app_design_system.dart';
import '../theme/app_colors.dart';

/// Универсальный диалог приложения
///
/// Поддерживает:
/// - Заголовок и сообщение
/// - Опциональная иконка
/// - Кнопки подтверждения и отмены
/// - Адаптивный дизайн под светлую/темную тему
///
/// Использование:
/// ```dart
/// await AppDialog.show(
///   context: context,
///   title: 'Новая игра',
///   message: 'Начать новую игру? Текущий прогресс будет потерян.',
///   icon: Icons.refresh_rounded,
///   confirmText: 'Начать',
///   cancelText: 'Отмена',
/// );
/// ```
class AppDialog extends StatelessWidget {
  /// Заголовок диалога
  final String title;

  /// Сообщение диалога
  final String message;

  /// Иконка (опционально)
  final IconData? icon;

  /// Текст кнопки подтверждения
  final String confirmText;

  /// Текст кнопки отмены (если null - кнопка не показывается)
  final String? cancelText;

  /// Цвет иконки и кнопки подтверждения
  final Color? accentColor;

  const AppDialog({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    required this.confirmText,
    this.cancelText,
    this.accentColor,
  });

  /// Показать диалог и вернуть результат (true если подтверждено, false если отменено)
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
    required String confirmText,
    String? cancelText,
    Color? accentColor,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppDialog(
        title: title,
        message: message,
        icon: icon,
        confirmText: confirmText,
        cancelText: cancelText,
        accentColor: accentColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveAccentColor = accentColor ?? AppColors.getAccent(isDark);

    return Dialog(
      backgroundColor: AppColors.getSurface(isDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesignSystem.radiusLarge),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDesignSystem.paddingExtraLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Иконка (если есть)
            if (icon != null) ...[
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: effectiveAccentColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: effectiveAccentColor,
                ),
              ),
              SizedBox(height: AppDesignSystem.spacingLarge),
            ],

            // Заголовок
            Text(
              title,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 24,
                    color: AppColors.getPrimary(isDark),
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDesignSystem.spacingMedium),

            // Сообщение
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.getSecondary(isDark),
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDesignSystem.spacingExtraLarge),

            // Кнопки
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Кнопка отмены (если есть)
                if (cancelText != null) ...[
                  Expanded(
                    child: _DialogButton(
                      text: cancelText!,
                      onPressed: () => Navigator.of(context).pop(false),
                      isPrimary: false,
                      color: AppColors.getSecondary(isDark),
                    ),
                  ),
                  SizedBox(width: AppDesignSystem.spacingMedium),
                ],

                // Кнопка подтверждения
                Expanded(
                  child: _DialogButton(
                    text: confirmText,
                    onPressed: () => Navigator.of(context).pop(true),
                    isPrimary: true,
                    color: effectiveAccentColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Кнопка диалога
class _DialogButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final Color color;

  const _DialogButton({
    required this.text,
    required this.onPressed,
    required this.isPrimary,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPrimary ? color : Colors.transparent,
      borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppDesignSystem.paddingLarge,
            horizontal: AppDesignSystem.paddingExtraLarge,
          ),
          decoration: BoxDecoration(
            border: isPrimary ? null : Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(AppDesignSystem.radiusMedium),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isPrimary ? Colors.white : color,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
