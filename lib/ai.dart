import 'dart:collection';
import 'dart:math';
import 'main.dart';
export 'main.dart';

class PriorityQueue<T> {
  final List<T> _elements = [];
  final int Function(T, T) _compare;

  PriorityQueue(this._compare);

  void add(T element) {
    _elements.add(element);
    _elements.sort(_compare); // 按优先级排序
  }

  T removeFirst() => _elements.removeAt(0);

  bool get isEmpty => _elements.isEmpty;

  bool any(bool Function(T) test) {
    for (var element in _elements) {
      if (test(element)) {
        return true;
      }
    }
    return false;
  }
}

class Node {
  final int x, y;
  int g, h;
  Node? parent;

  Node(this.x, this.y, {this.g = 0, this.h = 0, this.parent});

  int get f => g + h;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Node &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

// 使用 PriorityQueue 处理优先队列
int aStarPathfinding(rowCount, columnCount, List<Point<int>> obstacles,
    List<Point<int>> snake, Point<int> food) {
  print(obstacles);
  int rows = rowCount;
  int cols = columnCount;
  List<List<bool>> closedSet =
      List.generate(rows, (_) => List.filled(cols, false));

  // 创建优先队列，根据节点的 f 值排序
  PriorityQueue<Node> openSet = PriorityQueue<Node>((a, b) => a.f - b.f);

  Node startNode = Node(snake.last.x, snake.last.y);
  Node endNode = Node(food.x, food.y);
  print(startNode.x.toString() + " snake " + startNode.y.toString());
  openSet.add(startNode);

  List<List<int>> directions = [
    [0, -1], // 上
    [0, 1], // 下
    [-1, 0], // 左
    [1, 0], // 右
  ];

  while (!openSet.isEmpty) {
    Node current = openSet.removeFirst();
    if (current.x == endNode.x && current.y == endNode.y) {
      return reconstructPath(current);
    }

    closedSet[current.x][current.y] = true;

    for (var i = 0; i < directions.length; i++) {
      int newX = current.x + directions[i][0];
      int newY = current.y + directions[i][1];

      if (newX < 0 ||
          newX >= rows ||
          newY < 0 ||
          newY >= cols ||
          obstacles.contains(Point(newX, newY)) ||
          snake.contains(Point(newX, newY)) ||
          closedSet[newX][newY]) {
        continue;
      }

      int gScore = current.g + 1;
      int hScore = (endNode.x - newX).abs() + (endNode.y - newY).abs();
      Node neighbor = Node(newX, newY, g: gScore, h: hScore, parent: current);

      bool inOpenSet =
          openSet.any((node) => node == neighbor && node.f <= neighbor.f);
      if (!inOpenSet) {
        openSet.add(neighbor);
      }
    }
  }

  return 1; // 没有路径
}

int reconstructPath(Node current) {
  List<int> path = [];
  while (current.parent != null) {
    int dx = current.x - current.parent!.x;
    int dy = current.y - current.parent!.y;

    if (dx == -1 && dy == 0) {
      path.add(3); //  left
    } else if (dx == 1 && dy == 0) {
      path.add(1); // right
    } else if (dx == 0 && dy == -1) {
      path.add(0); // up
    } else if (dx == 0 && dy == 1) {
      path.add(2); // down
    }

    current = current.parent!;
  }
  path = path.reversed.toList();
  print(path);
  return path.first;
}

// void main() {
//   Stopwatch stopwatch = Stopwatch();
//   // 开始计时
//   stopwatch.start();
//   // 调用待测试的函数
//   int result = aStarPathfinding(10, 10, [Point(6, 2), Point(2, 1), Point(5, 3)],
//       [Point(5, 0), Point(5, 1), Point(5, 2)], Point(8, 8));
//   // 停止计时
//   stopwatch.stop();

//   // 输出结果和执行时间
//   print('Result: $result');
//   print('Execution time: ${stopwatch.elapsedMilliseconds} ms');
// }
