import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanchishe/pages/main_page.dart';
import 'package:tanchishe/pages/menu_page.dart';

void main() {
  group('MainPage Widget Tests', () {
    testWidgets('displays the title correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MainPage(),
        ),
      );

      // 验证页面上显示了两个“贪吃蛇游戏”文本组件
      expect(find.text('贪吃蛇游戏'), findsNWidgets(2));
    });

    testWidgets('navigates to MenuPage on "开始游戏" button press',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MainPage(),
        ),
      );

      // 查找“开始游戏”按钮并点击
      final startButton = find.widgetWithText(FilledButton, '开始游戏');
      expect(startButton, findsOneWidget);
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // 验证页面导航是否成功进入 MenuPage
      expect(find.byType(MenuPage), findsOneWidget);
    });
  });
}
