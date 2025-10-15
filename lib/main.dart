import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/settings/domain/providers/settings_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/game/presentation/screens/game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Блокируем ландшафтную ориентацию для мобильных (только портретная)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    // Оборачиваем приложение в ProviderScope для Riverpod
    const ProviderScope(
      child: PuzzleMergeApp(),
    ),
  );
}

/// Главный виджет приложения
class PuzzleMergeApp extends ConsumerWidget {
  const PuzzleMergeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(settingsProvider.select((s) => s.themeMode));

    return MaterialApp(
      title: 'Puzzle Merge 10x10',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const GameScreen(),
    );
  }
}

/// Обёртка для фиксированного размера окна
class FixedSizeWrapper extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const FixedSizeWrapper({
    super.key,
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: width,
          height: height,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(),
          child: child,
        ),
      ),
    );
  }
}
