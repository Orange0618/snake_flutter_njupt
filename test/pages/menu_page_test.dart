import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanchishe/pages/game_page.dart';
import 'package:tanchishe/pages/high_score_page.dart';
import 'package:tanchishe/pages/menu_page.dart';

void main() {
  group('MenuPage Widget Tests', () {
    testWidgets('should display all buttons with correct labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MenuPage(),
        ),
      );

      expect(find.text('普通模式'), findsOneWidget);
      expect(find.text('进阶模式'), findsOneWidget);
      expect(find.text('地狱模式'), findsOneWidget);
      expect(find.text('限时模式'), findsOneWidget);
      expect(find.text('  最高分  '), findsOneWidget);
    });

    testWidgets('should navigate to GamePage with correct mode when each button is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MenuPage(),
        ),
      );

      // 普通模式
      await tester.tap(find.text('普通模式'));
      await tester.pumpAndSettle();
      expect(find.byType(GamePage), findsOneWidget);
      expect((tester.widget(find.byType(GamePage)) as GamePage).mode, 'normal');
      Navigator.pop(tester.element(find.byType(GamePage)));
      await tester.pumpAndSettle();

      // 进阶模式
      await tester.tap(find.text('进阶模式'));
      await tester.pumpAndSettle();
      expect(find.byType(GamePage), findsOneWidget);
      expect((tester.widget(find.byType(GamePage)) as GamePage).mode, 'mid');
      Navigator.pop(tester.element(find.byType(GamePage)));
      await tester.pumpAndSettle();

      // 地狱模式
      await tester.tap(find.text('地狱模式'));
      await tester.pumpAndSettle();
      expect(find.byType(GamePage), findsOneWidget);
      expect((tester.widget(find.byType(GamePage)) as GamePage).mode, 'hell');
      Navigator.pop(tester.element(find.byType(GamePage)));
      await tester.pumpAndSettle();

      // 限时模式
      await tester.tap(find.text('限时模式'));
      await tester.pumpAndSettle();
      expect(find.byType(GamePage), findsOneWidget);
      expect((tester.widget(find.byType(GamePage)) as GamePage).mode, 'limit');
      Navigator.pop(tester.element(find.byType(GamePage)));
      await tester.pumpAndSettle();
    });

    testWidgets('should navigate to HighScorePage when "最高分" button is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MenuPage(),
        ),
      );

      await tester.tap(find.text('  最高分  '));
      await tester.pumpAndSettle();

      expect(find.byType(HighScorePage), findsOneWidget);
    });

    testWidgets('should navigate back when back button is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuPage(),
          ),
        ),
      );

      // Tap on the back button in the AppBar
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Check if the MenuPage is no longer in the widget tree (popped)
      expect(find.byType(MenuPage), findsNothing);
    });
  });
}
