import 'package:flutter/material.dart';
import 'game_page.dart';
import 'high_score_page.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "菜单",
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 返回主页面
          },
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/menupage_back.jpg'), // 设置背景图片
            fit: BoxFit.cover, // 图片填充整个页面
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                icon: Icon(Icons.mood),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GamePage(mode: "normal"),
                    ),
                  );
                },
                label: Text(
                  "普通模式",
                ),
              ),
              SizedBox(height: 20), // 按钮之间的间隔
              FilledButton.icon(
                icon: Icon(Icons.sentiment_neutral),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GamePage(mode: "mid"),
                    ),
                  );
                },
                label: Text(
                  "进阶模式",
                ),
              ),
              SizedBox(height: 20), // 按钮之间的间隔
              FilledButton.icon(
                icon: Icon(Icons.sentiment_very_dissatisfied_sharp),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GamePage(mode: "hell"),
                    ),
                  );
                },
                label: Text(
                  "地狱模式",
                ),
              ),
              SizedBox(height: 20),
              FilledButton.icon(
                icon: Icon(Icons.timer_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GamePage(mode: "limit")),
                  );
                },
                label: Text(
                  "限时模式",
                ),
              ),
              SizedBox(height: 20), // 按钮之间的间隔
              FilledButton.icon(
                icon: Icon(Icons.score_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HighScorePage(),
                    ),
                  );
                },
                label: Text(
                  "  最高分  ",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
