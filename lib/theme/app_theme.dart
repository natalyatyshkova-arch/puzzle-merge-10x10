import 'package:flutter/material.dart';

/// Цветовая палитра для игровых блоков
class GameColors {
  static const Color shape1 = Color(0xFFFF6B6B); // Красный
  static const Color shape2 = Color(0xFF4ECDC4); // Бирюзовый
  static const Color shape3 = Color(0xFFFFE66D); // Жёлтый
  static const Color shape4 = Color(0xFF95E1D3); // Мятный
  static const Color shape5 = Color(0xFFF38181); // Розовый
  static const Color shape6 = Color(0xFFAA96DA); // Фиолетовый
  static const Color shape7 = Color(0xFFFCACAC); // Персиковый

  // Светлая тема
  static const Color gridBackgroundLight = Color(0xFFF5F5F5);
  static const Color gridLineLight = Color(0xFFE0E0E0);
  static const Color emptyCellFillLight = Colors.white;
  static const Color filledCellLight = Color(0xFF424242);

  // Тёмная тема
  static const Color gridBackgroundDark = Color(0xFF1E1E1E);
  static const Color gridLineDark = Color(0xFF3A3A3A);
  static const Color emptyCellFillDark = Color(0xFF2C2C2C);
  static const Color filledCellDark = Color(0xFFE0E0E0);

  static const List<Color> shapeColors = [
    shape1,
    shape2,
    shape3,
    shape4,
    shape5,
    shape6,
    shape7,
  ];
}

/// Размеры и отступы
class GameSizes {
  static const double cellSize = 95.0; // Размер ячейки поля
  static const double cellSpacing = 5.0; // Отступы между ячейками
  static const double shapeCellSize = 12.0; // Размер ячейки фигуры (подогнано под макс. 5x4)
  static const double shapeCellSpacing = 1.0; // Уменьшили для экономии места
  static const double cornerRadius = 8.0;
  static const double smallCornerRadius = 4.0; // Уменьшили для маленьких ячеек
}

/// Тема приложения Material 3
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      fontFamily: 'DrAguSans',
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          fontFamily: 'DrAguSans',
          color: Colors.black87,
        ),
        displayMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          fontFamily: 'DrAguSans',
          color: Colors.black87,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'DrAguSans',
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: 'DrAguSans',
          color: Colors.black87,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      fontFamily: 'DrAguSans',
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          fontFamily: 'DrAguSans',
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          fontFamily: 'DrAguSans',
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'DrAguSans',
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: 'DrAguSans',
          color: Colors.white,
        ),
      ),
    );
  }
}
