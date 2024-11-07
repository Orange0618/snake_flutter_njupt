import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:tanchishe/main.dart';
import 'package:tanchishe/pages/menu_page.dart';
import 'package:tanchishe/pages/game_page.dart';
import 'package:tanchishe/pages/high_score_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Snake Game App Integration Tests', () {
    testWidgets('Starts on MainPage and displays title',
        (WidgetTester tester) async {
      await tester.pumpWidget(SnakeGame());

      // 检查主页面是否显示了两个标题文本“贪吃蛇游戏”
      expect(find.text('贪吃蛇游戏'), findsNWidgets(2));
    });

    testWidgets('Navigates to MenuPage when "开始游戏" is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(SnakeGame());

      // 查找并点击“开始游戏”按钮
      final startButton = find.widgetWithText(FilledButton, '开始游戏');
      expect(startButton, findsOneWidget);
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // 验证是否成功导航至菜单页面
      expect(find.byType(MenuPage), findsOneWidget);
    });

    testWidgets('Navigates to GamePage and back to MenuPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(SnakeGame());

      // 进入菜单页面
      await tester.tap(find.text('开始游戏'));
      await tester.pumpAndSettle();

      // 验证是否在菜单页面
      expect(find.byType(MenuPage), findsOneWidget);

      // 使用文本查找“普通模式”按钮进入游戏页面
      final normalModeButton = find.text('普通模式');
      expect(normalModeButton, findsOneWidget);
      await tester.tap(normalModeButton);
      await tester.pumpAndSettle();

      // 验证是否在游戏页面
      expect(find.byType(GamePage), findsOneWidget);

      // 点击返回按钮返回菜单页面
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byType(MenuPage), findsOneWidget);
    });

    testWidgets('Navigates to HighScorePage and displays high score',
        (WidgetTester tester) async {
      await tester.pumpWidget(SnakeGame());

      // 进入菜单页面
      await tester.tap(find.text('开始游戏'));
      await tester.pumpAndSettle();

      // 验证是否在菜单页面
      expect(find.byType(MenuPage), findsOneWidget);

      // 使用完整的文本查找“  最高分  ”按钮进入最高分页面
      final highScoreButton = find.text('  最高分  ');
      expect(highScoreButton, findsOneWidget);
      await tester.tap(highScoreButton);
      await tester.pumpAndSettle();

      // 验证是否在最高分页面并显示最高分
      expect(find.byType(HighScorePage), findsOneWidget);
      expect(find.textContaining('最高分：'), findsOneWidget);
    });
  });
}
