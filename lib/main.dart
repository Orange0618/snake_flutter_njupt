import 'package:flutter/material.dart';
import 'pages/main_page.dart';

void main() {
  runApp(SnakeGame());
}

class SnakeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '贪吃蛇游戏',
      theme: ThemeData(
          fontFamily: 'ZCOOLKuaiLe',
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
          ),
          filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                  backgroundColor: ColorScheme.fromSeed(
                    seedColor: Colors.green,
                  ).primary,
                  foregroundColor: ColorScheme.fromSeed(
                    seedColor: Colors.green,
                  ).onPrimary,
                  textStyle:
                      TextStyle(fontSize: 24, fontFamily: 'ZCOOLKuaiLe')))),
      home: MainPage(), // 主页面入口
    );
  }
}
