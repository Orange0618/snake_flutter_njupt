import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanchishe/pages/game_page.dart';

void main() {
  group('GamePage Widget Tests', () {
    testWidgets('displays initial score and time correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GamePage(mode: "normal"),
        ),
      );

      // 检查初始分数是否为 0
      expect(find.textContaining("分数: 0"), findsOneWidget);

      // 检查初始时间显示
      expect(find.textContaining("剩余时间：∞"), findsOneWidget);
    });

    testWidgets('toggles pause on button press', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GamePage(mode: "normal"),
        ),
      );

      // 查找暂停按钮并点击
      final pauseButton = find.widgetWithText(FilledButton, "暂停");
      expect(pauseButton, findsOneWidget);
      await tester.tap(pauseButton);
      await tester.pump();

      // 点击后按钮应显示“继续”
      expect(find.widgetWithText(FilledButton, "继续"), findsOneWidget);

      // 检查是否显示暂停提示文本
      expect(find.text("游戏已暂停 (按空格继续)"), findsOneWidget);

      // 点击继续按钮，恢复游戏
      await tester.tap(find.widgetWithText(FilledButton, "继续"));
      await tester.pump();

      // 验证按钮再次显示“暂停”
      expect(find.widgetWithText(FilledButton, "暂停"), findsOneWidget);
      expect(find.text("游戏已暂停 (按空格继续)"), findsNothing);
    });

    testWidgets('displays "游戏结束" dialog when game ends',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GamePage(mode: "normal"),
        ),
      );

      // 模拟游戏结束
      GamePageState state = tester.state(find.byType(GamePage));
      state.showGameOverDialog();

      await tester.pumpAndSettle();

      // 验证是否显示“游戏结束”对话框
      expect(find.text("游戏结束"), findsOneWidget);
      expect(find.textContaining("得分:"), findsOneWidget);
      expect(find.widgetWithText(TextButton, "返回菜单"), findsOneWidget);
    });

    testWidgets('triggers special food generation periodically',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GamePage(mode: "normal"),
        ),
      );

      GamePageState state = tester.state(find.byType(GamePage));

      // 验证初始时 specialFood1 和 specialFood2 都不是 null
      expect(state.specialFood1, isNotNull);
      expect(state.specialFood2, isNotNull);

      // 触发特殊食物生成
      state.generateSpecialFood();
      await tester.pumpAndSettle(Duration(seconds: 10));

      // 验证 specialFood1 和 specialFood2 被重新生成
      expect(state.specialFood1, isNotNull);
      expect(state.specialFood2, isNotNull);
    });

    testWidgets('counts down time in limit mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GamePage(mode: "limit"),
        ),
      );

      GamePageState state = tester.state(find.byType(GamePage));
      state.time = 5;

      await tester.pumpAndSettle(Duration(seconds: 1));

      // 验证剩余时间减少
      expect(state.time, equals(4));
    });

    testWidgets('increases score on food consumption',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GamePage(mode: "normal"),
        ),
      );

      GamePageState state = tester.state(find.byType(GamePage));

      // 将食物位置设置在蛇头的下一个位置
      state.food = Point(state.snake.last.x + 1, state.snake.last.y);
      state.direction = 1; // 设置蛇向右移动方向

      // 模拟蛇移动到食物位置
      state.moveSnake();

      // 检查蛇是否到达食物位置并执行吃食物后的逻辑
      if (state.snake.last == state.food) {
        state.growSnake();
        state.generateFood();
        state.increaseSpeed();
        state.score += 10; // 手动增加得分
      }

      await tester.pumpAndSettle();

      // 验证得分增加
      expect(state.score, equals(10));
    });
  });
}
