import 'package:flutter/material.dart';
import 'pages/main_page.dart';

void main() {
  runApp(SnakeGame());
}

// SnakeGame 类是一个无状态小部件，表示贪吃蛇游戏的入口
class SnakeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '贪吃蛇游戏', // 应用的标题
      theme: ThemeData(
          fontFamily: 'ZCOOLKuaiLe', // 设置全局字体为 ZCOOLKuaiLe
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green, // 通过绿色种子颜色生成颜色方案
          ),
          filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      horizontal: 50, vertical: 25), // 设置按钮的内边距
                  backgroundColor: ColorScheme.fromSeed(
                    seedColor: Colors.green, // 设置按钮的背景颜色
                  ).primary,
                  foregroundColor: ColorScheme.fromSeed(
                    seedColor: Colors.green, // 设置按钮的前景颜色
                  ).onPrimary,
                  textStyle: TextStyle(
                      fontSize: 24, fontFamily: 'ZCOOLKuaiLe')))), // 设置按钮的文本样式
      home: MainPage(), // 应用的主页面，显示 MainPage 小部件
    );
  }
}
