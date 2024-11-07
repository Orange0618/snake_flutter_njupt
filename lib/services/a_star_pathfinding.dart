import 'dart:math';
import '../models/priority_queue.dart';
import '../models/node.dart';

int aStarPathfinding(
    int rowCount,
    int columnCount,
    List<Point<int>> obstacles,
    List<Point<int>> snake,
    Point<int> food) {
  int rows = rowCount;
  int cols = columnCount;
  List<List<bool>> closedSet = List.generate(rows, (_) => List.filled(cols, false));

  PriorityQueue<Node> openSet = PriorityQueue<Node>((a, b) => a.f - b.f);

  Node startNode = Node(snake.last.x, snake.last.y);
  Node endNode = Node(food.x, food.y);
  openSet.add(startNode);

  List<List<int>> directions = [
    [0, -1], // 上
    [0, 1],  // 下
    [-1, 0], // 左
    [1, 0],  // 右
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
  return 0; // 没有路径
}

int reconstructPath(Node current) {
  List<int> path = [];
  while (current.parent != null) {
    int dx = current.x - current.parent!.x;
    int dy = current.y - current.parent!.y;

    if (dx == -1 && dy == 0) {
      path.add(3); // 左
    } else if (dx == 1 && dy == 0) {
      path.add(1); // 右
    } else if (dx == 0 && dy == -1) {
      path.add(0); // 上
    } else if (dx == 0 && dy == 1) {
      path.add(2); // 下
    }

    current = current.parent!;
  }
  path = path.reversed.toList();
  return path.first;
}
