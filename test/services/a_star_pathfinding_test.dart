import 'package:flutter_test/flutter_test.dart';
import 'package:tanchishe/services/a_star_pathfinding.dart';
import 'dart:math';

void main() {
  group('A* Pathfinding Algorithm Tests', () {
    test('Finds path in an open grid', () {
      int rowCount = 5;
      int columnCount = 5;
      List<Point<int>> obstacles = [];
      List<Point<int>> snake = [Point(1, 1)];
      Point<int> food = Point(4, 4);

      int direction =
          aStarPathfinding(rowCount, columnCount, obstacles, snake, food);

      expect(direction, isNot(0)); // A path should exist
    });

    test('Finds path in a grid with obstacles', () {
      int rowCount = 5;
      int columnCount = 5;
      List<Point<int>> obstacles = [Point(3, 3), Point(3, 2)];
      List<Point<int>> snake = [Point(0, 0), Point(1, 0), Point(2, 0)];
      Point<int> food = Point(4, 4);

      int direction =
          aStarPathfinding(rowCount, columnCount, obstacles, snake, food);

      expect(direction, isNot(0)); // A path should exist
    });

    testWidgets('No path if obstacles completely block the path',
        (WidgetTester tester) async {
      int rowCount = 5;
      int columnCount = 5;

      // 将障碍物完全围绕在食物周围，确保没有通路
      List<Point<int>> obstacles = [
        Point(3, 3),
        Point(3, 4),
        Point(4, 3),
        Point(4, 2),
        Point(2, 3),
        Point(2, 4),
        Point(3, 2),
        Point(4, 4)
      ];
      List<Point<int>> snake = [Point(0, 0), Point(1, 0), Point(2, 0)];
      Point<int> food = Point(3, 3);

      int direction =
          aStarPathfinding(rowCount, columnCount, obstacles, snake, food);

      expect(direction, equals(0)); // No path exists
    });

    test('Finds direct path if there are no obstacles or snake body', () {
      int rowCount = 3;
      int columnCount = 3;
      List<Point<int>> obstacles = [];
      List<Point<int>> snake = [Point(0, 0)];
      Point<int> food = Point(2, 2);

      int direction =
          aStarPathfinding(rowCount, columnCount, obstacles, snake, food);

      expect(direction, isIn([1, 2])); // Path should be either down or right
    });

    test('Avoids snake body while finding path', () {
      int rowCount = 5;
      int columnCount = 5;
      List<Point<int>> obstacles = [];
      List<Point<int>> snake = [
        Point(0, 0),
        Point(1, 0),
        Point(2, 0),
        Point(3, 0)
      ];
      Point<int> food = Point(4, 4);

      int direction =
          aStarPathfinding(rowCount, columnCount, obstacles, snake, food);

      expect(
          direction, isNot(0)); // A path should exist, avoiding the snake body
    });

    test('Correctly chooses initial direction to move towards food', () {
      int rowCount = 3;
      int columnCount = 3;
      List<Point<int>> obstacles = [];
      List<Point<int>> snake = [Point(0, 0)];
      Point<int> food = Point(0, 2);

      int direction =
          aStarPathfinding(rowCount, columnCount, obstacles, snake, food);

      expect(direction, equals(2)); // Expected direction is downwards
    });
  });
}
