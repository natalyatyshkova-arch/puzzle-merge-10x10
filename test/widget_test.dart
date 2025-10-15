// Тест для игры Puzzle Merge 10x10

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Puzzle Merge app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: PuzzleMergeApp()));

    // Verify that the score panel is displayed
    expect(find.text('СЧЁТ'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    // Verify that the new game button is displayed
    expect(find.text('Новая игра'), findsOneWidget);
  });
}
