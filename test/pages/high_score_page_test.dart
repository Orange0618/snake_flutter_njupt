import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanchishe/pages/game_page.dart';
import 'package:tanchishe/pages/high_score_page.dart';

void main() {
  group('HighScorePage Widget Tests', () {
    testWidgets('displays the correct high score', (WidgetTester tester) async {
      // 设置一个示例最高分
      GamePageState.highScore = 100;

      await tester.pumpWidget(
        MaterialApp(
          home: HighScorePage(),
        ),
      );

      // 验证页面上是否显示了正确的最高分
      expect(find.text('最高分：100'), findsOneWidget);
    });

    testWidgets('navigates back to previous page on back button press', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HighScorePage(),
        ),
      );

      // 查找返回按钮并点击
      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // 验证页面导航是否成功返回
      expect(find.byType(HighScorePage), findsNothing);
    });
  });
}
