import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ai.dart';
import 'dart:ui' as ui;

void main() {
  runApp(SnakeGame());
}

class SnakeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '贪吃蛇游戏',
      theme: ThemeData(primarySwatch: Colors.green),
      home: MainPage(), // 主页面入口
    );
  }
}

// 主页面
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/mainpage_back2.jpg'), // 设置背景图片
            fit: BoxFit.cover, // 图片填充整个页面
          ),
        ),
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF8F1FFF), Color(0xFFFF00FF)],
                  ).createShader(Offset.zero & bounds.size);
                },
                child: Text(
                  '贪吃蛇游戏',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6
                        ..color = Colors.white),
                ),
              ),
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Color(0xFFFFBDE9)],
                  ).createShader(Offset.zero & bounds.size);
                },
                child: Text(
                  '贪吃蛇游戏',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              backgroundColor: Colors.greenAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shadowColor: Colors.black.withOpacity(0.3),
              elevation: 10,
            ),
            child: Text(
              "开始游戏",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ])),
      ),
    );
  }
}

// 菜单页面
class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("菜单"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // 返回主页面
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/menu_back2.webp'), // 设置背景图片
              fit: BoxFit.cover, // 图片填充整个页面
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GamePage(mode: "normal"),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadowColor: Colors.black.withOpacity(0.3),
                    elevation: 8,
                  ),
                  child: Text(
                    "普通模式",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20), // 按钮之间的间隔
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GamePage(mode: "hell"),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadowColor: Colors.black.withOpacity(0.3),
                    elevation: 8,
                  ),
                  child: Text(
                    "地狱模式",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20), // 按钮之间的间隔
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HighScorePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadowColor: Colors.black.withOpacity(0.3),
                    elevation: 8,
                  ),
                  child: Text(
                    "最高分",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

// 游戏页面，支持“普通模式”和“地狱模式”
class GamePage extends StatefulWidget {
  final String mode; // 模式类型："normal" 或 "hell"
  GamePage({required this.mode});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const int rowCount = 40;
  static const int columnCount = 40;
  static int highScore = 0;

  List<Point<int>> snake = [Point(0, 0), Point(1, 0), Point(2, 0)];
  int direction = 1; // 0:上, 1:右, 2:下, 3:左
  Point<int> food =
      Point(Random().nextInt(columnCount), Random().nextInt(rowCount));
  List<Point<int>> obstacles = [];
  Timer? timer;
  bool isPaused = false;
  bool isAuto = false;
  int speed = 300; // 初始速度
  int score = 0; // 当前得分
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    initializeGame();
    startGame();
    _focusNode.requestFocus();
  }

  void initializeGame() {
    if (widget.mode == "hell") {
      obstacles = generateObstacles(10); // 地狱模式障碍物数量减少为 10
      speed = 150; // 地狱模式更快速度
    } else {
      obstacles = generateObstacles(5); // 普通模式障碍物数量减少为 5
      speed = 300; // 普通模式速度较慢
    }
  }

  List<Point<int>> generateObstacles(int count) {
    List<Point<int>> obstacles = [];
    for (int i = 0; i < count; i++) {
      Point<int> obstacle;
      do {
        obstacle =
            Point(Random().nextInt(columnCount), Random().nextInt(rowCount));
      } while (snake.contains(obstacle) ||
          obstacle == food ||
          obstacles.contains(obstacle));
      obstacles.add(obstacle);
    }
    return obstacles;
  }

  void startGame() {
    timer?.cancel();
    timer = Timer.periodic(Duration(milliseconds: speed), (Timer timer) {
      if (!isPaused) {
        setState(() {
          moveSnake();
          if (checkCollision()) {
            timer.cancel();
            updateHighScore();
            showGameOverDialog();
          } else if (snake.last == food) {
            growSnake();
            generateFood();
            increaseSpeed();
            score += 10; // 每次吃到食物增加得分
          }
          if (isAuto) {
            ai();
          }
        });
      }
    });
  }

  void increaseSpeed() {
    if (speed > 100) {
      speed -= 20;
    }
    startGame();
  }

  void togglePause() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  void toggleAi() {
    setState(() {
      isAuto = !isAuto;
    });
  }

  void moveSnake() {
    Point<int> newHead;
    switch (direction) {
      case 0:
        newHead = Point(snake.last.x, snake.last.y - 1);
        break;
      case 1:
        newHead = Point(snake.last.x + 1, snake.last.y);
        break;
      case 2:
        newHead = Point(snake.last.x, snake.last.y + 1);
        break;
      case 3:
        newHead = Point(snake.last.x - 1, snake.last.y);
        break;
      default:
        newHead = Point(snake.last.x + 1, snake.last.y);
    }
    snake.add(newHead);
    print(newHead.x.toString() +
        " and " +
        newHead.y.toString() +
        " duration " +
        direction.toString());
    snake.removeAt(0);
  }

  void growSnake() {
    snake.insert(0, snake.first);
  }

  void generateFood() {
    do {
      food = Point(Random().nextInt(columnCount), Random().nextInt(rowCount));
    } while (snake.contains(food) || obstacles.contains(food));
  }

  bool checkCollision() {
    Point<int> head = snake.last;
    if (head.x < 0 || head.x >= columnCount || head.y < 0 || head.y >= rowCount)
      return true;
    if (snake.sublist(0, snake.length - 1).contains(head)) return true;
    if (obstacles.contains(head)) return true;
    return false;
  }

  void updateHighScore() {
    if (score > highScore) {
      highScore = score;
    }
  }

  void ai() {
    direction = aStarPathfinding(rowCount, columnCount, obstacles, snake, food);
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("游戏结束"),
          content: Text("得分: $score"),
          actions: [
            TextButton(
              child: Text("返回菜单"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // 返回菜单页面
              },
            ),
          ],
        );
      },
    );
  }

  void onKeyPress(RawKeyEvent event) {
    // ignore: deprecated_member_use
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp && direction != 2) {
        direction = 0;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
          direction != 3) {
        direction = 1;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
          direction != 0) {
        direction = 2;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
          direction != 1) {
        direction = 3;
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        togglePause();
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("贪吃蛇游戏 - 分数: $score"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 返回菜单页面
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              toggleAi();
            },
            child: Text(
              isAuto ? "关闭AI" : "开启AI", // 根据isAuto的值显示不同文本
              style: TextStyle(color: Colors.black), // 确保文本颜色可见
            ),
          ),
        ],
      ),
      body: Center(
        child: Focus(
          autofocus: true,
          onKey: (FocusNode node, RawKeyEvent event) {
            // Intercept the arrow keys and prevent focus change
            if (event is RawKeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
                  direction != 2) {
                direction = 0;
              } else if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
                  direction != 3) {
                direction = 1;
              } else if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
                  direction != 0) {
                direction = 2;
              } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
                  direction != 1) {
                direction = 3;
              } else if (event.logicalKey == LogicalKeyboardKey.space) {
                togglePause();
              }
              return KeyEventResult.handled; // Mark the event as handled
            }
            return KeyEventResult.ignored; // Ignore other events
          },
          child: RawKeyboardListener(
            focusNode: _focusNode,
            autofocus: true,
            onKey: (RawKeyEvent
                event) {}, // Keep empty, as `Focus` now handles events
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: AspectRatio(
                      aspectRatio: rowCount /
                          (columnCount + 5), // Adjusts based on grid dimensions
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: rowCount * columnCount,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columnCount,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          int x = index % columnCount;
                          int y = index ~/ columnCount;
                          Point<int> point = Point(x, y);
        
                          if (point == snake.last) {
                            // Render snake head
                            return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/head2.webp'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          } else if (snake.contains(point)) {
                            // Render snake body
                            return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/body2.jpeg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          } else if (point == food) {
                            return LayoutBuilder(
                              builder: (context, constraints) {
                                return Container(
                                    decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/food2.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ));
                              },
                            );
                          } else if (obstacles.contains(point)) {
                            return Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage('assets/obstacle.webp'),
                              )),
                            );
                          } else {
                            return Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage('assets/ground.jpg'),
                              )),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                if (isPaused)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "游戏已暂停 (按空格继续)",
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }
}

// 最高分页面
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
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            "最高分：${_GamePageState.highScore}",
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
