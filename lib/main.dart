import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ai.dart';

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

// 主页面
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                      ..color = theme.colorScheme.surface),
              ),
            ),
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.surfaceBright,
                    theme.colorScheme.onPrimary
                  ],
                ).createShader(Offset.zero & bounds.size);
              },
              child: Text(
                '贪吃蛇游戏',
                style: TextStyle(
                    color: Colors.lightGreen,
                    fontSize: 60,
                    fontWeight: FontWeight.bold),
              ),
            )
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
      ])),
    );
  }
}

// 菜单页面
class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        body: Center(
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
        ));
  }
}

// 游戏页面，支持“普通模式”和“地狱模式”
class GamePage extends StatefulWidget {
  final String mode; // 模式类型："normal" 、 "hell" 或 "limit"
  GamePage({required this.mode});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  static const int rowCount = 40;
  static const int columnCount = 40;
  static int highScore = 0;

  List<Point<int>> snake = [Point(0, 0), Point(1, 0), Point(2, 0)];
  int direction = 1; // 0:上, 1:右, 2:下, 3:左
  Point<int> food =
      Point(Random().nextInt(columnCount), Random().nextInt(rowCount));
  Point<int>? specialFood1 =
      Point(Random().nextInt(columnCount), Random().nextInt(rowCount));
  Point<int>? specialFood2 =
      Point(Random().nextInt(columnCount), Random().nextInt(rowCount));
  Timer? specialFoodTimer; // 特殊食物计时器
  List<Point<int>> obstacles = [];
  Timer? timer;
  Timer? timeLimitTimer;
  bool isPaused = false;
  bool isAuto = false;
  int speed = 300; // 初始速度
  int time = -1; // 初始限时
  int score = 0; // 当前得分
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    initializeGame();
    startGame();
    generateSpecialFood(); // 生成特殊食物
    _focusNode.requestFocus();
  }

  // 每10秒刷新两个特殊食物
  void generateSpecialFood() {
    specialFoodTimer?.cancel();
    specialFoodTimer = Timer.periodic(Duration(seconds: 10), (Timer timer) {
      setState(() {
        specialFood1 =
            Point(Random().nextInt(columnCount), Random().nextInt(rowCount));
        specialFood2 =
            Point(Random().nextInt(columnCount), Random().nextInt(rowCount));
      });
    });
  }

  void initializeGame() {
    if (widget.mode == "hell") {
      obstacles = generateObstacles(10);
      speed = 150;
    } else if (widget.mode == "normal") {
      obstacles = generateObstacles(5);
      speed = 300;
    } else if (widget.mode == "mid") {
      obstacles = generateObstacles(5);
      speed = 200;
    } else {
      obstacles = generateObstacles(5);
      speed = 300;
      time = 60;
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
          checkSpecialFoodEffects();
          if (isAuto) {
            ai();
          }
        });
      }
    });

    // 倒计时模式
    if (widget.mode == "limit" && time > 0) {
      timeLimitTimer?.cancel();
      timeLimitTimer =
          Timer.periodic(Duration(seconds: 1), (Timer countdownTimer) {
        if (time <= 0) {
          countdownTimer.cancel();
          timer?.cancel(); // 结束游戏
          updateHighScore();
          showGameOverDialog();
        } else {
          setState(() {
            time--;
          });
        }
      });
    }
  }

  // 检查特殊食物效果
  void checkSpecialFoodEffects() {
    Point<int> head = snake.last;

    if (head == specialFood1) {
      triggerRandomEffect();
      specialFood1 = null;
    }
    if (head == specialFood2) {
      triggerRandomEffect();
      specialFood2 = null;
    }
  }

  // 随机触发效果
  void triggerRandomEffect() {
    int effect = Random().nextInt(3); // 随机生成0-2的数

    switch (effect) {
      case 0: // 加速效果
        setState(() {
          speed = speed - 100;
          startGame();
        });
        Timer(Duration(seconds: 5), () {
          setState(() {
            speed = speed + 100; // 5秒后恢复原速
            startGame();
          });
        });
        break;
      case 1: // 减速效果
        setState(() {
          speed = speed + 100;
          startGame();
        });
        Timer(Duration(seconds: 5), () {
          setState(() {
            speed = speed - 100; // 5秒后恢复原速
            startGame();
          });
        });
        break;
      case 2: // 缩短效果
        if (snake.length > 3) {
          snake.removeAt(0); // 移除蛇尾
        }
        break;
    }
  }

  void increaseSpeed() {
    if (speed > 50) {
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
    if (head.x < 0 ||
        head.x >= columnCount ||
        head.y < 0 ||
        head.y >= rowCount) {
      return true;
    }
    if (snake.sublist(0, snake.length - 1).contains(head)) return true;
    if (obstacles.contains(head)) return true;
    return false;
  }

  void updateHighScore() {
    if (score > highScore) {
      highScore = score;
    }
  }

  // 渲染特殊食物
  Widget buildSpecialFood(Point<int>? point) {
    return point == null
        ? Container()
        : Icon(Icons.question_mark, color: Colors.yellowAccent);
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

  void onKeyPress(KeyEvent event) {
    // ignore: deprecated_member_use
    if (event is KeyDownEvent) {
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "分数: $score - 剩余时间：${time == -1 ? "∞" : "$time"}",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                color: const Color.fromARGB(255, 155, 69, 69).withOpacity(0.3),
                blurRadius: 3,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 返回菜单页面
          },
        ),
        actions: [
          FilledButton(
            onPressed: () {
              togglePause();
            },
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              textStyle: TextStyle(fontSize: 15, fontFamily: "ZCOOLKuaiLe"),
            ),
            child: Text(
              isPaused ? "继续" : "暂停",
            ),
          ),
          SizedBox(
            width: 20,
          ),
          FilledButton(
            onPressed: () {
              toggleAi();
            },
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              textStyle: TextStyle(fontSize: 15, fontFamily: "ZCOOLKuaiLe"),
            ),
            child: Text(
              isAuto ? "关闭辅助" : "开启辅助",
            ),
          ),
          SizedBox(
            width: 30,
          ),
        ],
      ),
      body: Center(
        child: Focus(
          autofocus: true,
          onKeyEvent: (FocusNode node, KeyEvent event) {
            // Intercept the arrow keys and prevent focus change
            if (event is KeyDownEvent) {
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
          child: KeyboardListener(
            focusNode: _focusNode,
            autofocus: true,
            onKeyEvent: (KeyEvent
                event) {}, // Keep empty, as `Focus` now handles events
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (direction != 0 && details.delta.dy > 0) {
                        direction = 2;
                      } else if (direction != 2 && details.delta.dy < 0) {
                        direction = 0;
                      }
                    },
                    onHorizontalDragUpdate: (details) {
                      if (direction != 3 && details.delta.dx > 0) {
                        direction = 1;
                      } else if (direction != 1 && details.delta.dx < 0) {
                        direction = 3;
                      }
                    },
                    child: Container(
                      color: theme.colorScheme.primary,
                      child: AspectRatio(
                        aspectRatio: columnCount / rowCount,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: rowCount * columnCount,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            } else if (snake.contains(point)) {
                              // Render snake body
                              return Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/body2.jpeg'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            } else if (point == food) {
                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  return Icon(
                                    Icons.apple,
                                    color: Colors.blue,
                                  );
                                },
                              );
                            } else if (point == specialFood1 ||
                                point == specialFood2) {
                              return buildSpecialFood(point); // 渲染特殊食物
                            } else if (obstacles.contains(point)) {
                              return Icon(
                                Icons.warning_rounded,
                                color: Colors.redAccent,
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
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
    specialFoodTimer?.cancel();
    timeLimitTimer?.cancel();
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
