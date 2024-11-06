import 'package:flutter/material.dart';
import 'menu_page.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/mainpage_back.jpg'), // 背景图片
            fit: BoxFit.cover, // 使图片填充整个页面
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary
                        ],
                      ).createShader(Offset.zero & bounds.size);
                    },
                    child: Text(
                      '贪吃蛇游戏',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 6
                          ..color = theme.colorScheme.surface,
                      ),
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.surface,
                          theme.colorScheme.onPrimary,
                        ],
                      ).createShader(Offset.zero & bounds.size);
                    },
                    child: Text(
                      '贪吃蛇游戏',
                      style: TextStyle(
                        color: Colors.lightGreen,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MenuPage()),
                  );
                },
                child: Text(
                  "开始游戏",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
