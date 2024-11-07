import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tanchishe/services/a_star_pathfinding.dart';

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

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: '关闭',
        onPressed: () {
          // 点击关闭按钮后的处理
        },
      ),
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
          _showSnackBar(context, "加速 5 秒");
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
          _showSnackBar(context, "减速 5 秒");
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
          _showSnackBar(context, "缩短 1 格");
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
    print("${newHead.x} and ${newHead.y} duration $direction");
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
                    child: AspectRatio(
                      aspectRatio: columnCount / rowCount,
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
                              margin: const EdgeInsets.all(1),
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
                              margin: const EdgeInsets.all(1),
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
                                return Container(
                                  margin: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryFixed,
                                      image: DecorationImage(
                                    image: AssetImage('assets/food2.png'),
                                    fit: BoxFit.fill,
                                  )),
                                );
                              },
                            );
                          } else if (point == specialFood1 ||
                              point == specialFood2) {
                            return Container(
                              margin: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryFixed,
                                  image: DecorationImage(
                                    image: AssetImage('assets/specialfood.png'),
                                    fit: BoxFit.fill,
                                  )),
                            );
                          } else if (obstacles.contains(point)) {
                            return Container(
                              margin: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryFixed,
                                image: DecorationImage(
                                  image: AssetImage('assets/obstacle.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              margin: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryFixed,
                              ),
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
    specialFoodTimer?.cancel();
    timeLimitTimer?.cancel();
    super.dispose();
  }
}
