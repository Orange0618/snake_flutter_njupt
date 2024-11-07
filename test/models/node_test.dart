import 'package:tanchishe/models/node.dart';
import 'package:test/test.dart';

void main() {
  group('Node', () {
    test('Constructor should initialize x, y, g, h, and parent correctly', () {
      final parent = Node(1, 2);
      final node = Node(3, 4, g: 10, h: 20, parent: parent);

      expect(node.x, equals(3));
      expect(node.y, equals(4));
      expect(node.g, equals(10));
      expect(node.h, equals(20));
      expect(node.parent, equals(parent));
    });

    test('f should be the sum of g and h', () {
      final node = Node(0, 0, g: 5, h: 15);
      expect(node.f, equals(20));
    });

    test('Nodes with the same x and y are equal', () {
      final node1 = Node(3, 4);
      final node2 = Node(3, 4);

      expect(node1, equals(node2));
    });

    test('Nodes with different x or y are not equal', () {
      final node1 = Node(3, 4);
      final node2 = Node(4, 3);

      expect(node1, isNot(equals(node2)));
    });

    test('hashCode should be the same for nodes with the same x and y', () {
      final node1 = Node(3, 4);
      final node2 = Node(3, 4);

      expect(node1.hashCode, equals(node2.hashCode));
    });

    test('hashCode should be different for nodes with different x or y', () {
      final node1 = Node(3, 4);
      final node2 = Node(4, 3);

      expect(node1.hashCode, isNot(equals(node2.hashCode)));
    });
  });
}
