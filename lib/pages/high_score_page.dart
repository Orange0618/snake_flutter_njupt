import 'package:flutter/material.dart';
import 'game_page.dart';

class HighScorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("最高分"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 返回菜单页面
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/high_back.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Text(
            "最高分：${GamePageState.highScore}",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.yellowAccent,
              shadows: [
                Shadow(
                  offset: Offset(3, 3),
                  color: Colors.black54,
                  blurRadius: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
