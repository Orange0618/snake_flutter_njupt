import 'package:tanchishe/models/priority_queue.dart';
import 'package:test/test.dart';

void main() {
  group('PriorityQueue', () {
    test('add should insert elements in priority order', () {
      final queue = PriorityQueue<int>((a, b) => a - b);
      queue.add(3);
      queue.add(1);
      queue.add(2);

      expect(queue.removeFirst(), equals(1));
      expect(queue.removeFirst(), equals(2));
      expect(queue.removeFirst(), equals(3));
    });

    test('removeFirst should return the highest priority element', () {
      final queue = PriorityQueue<int>((a, b) => a - b);
      queue.add(10);
      queue.add(5);

      expect(queue.removeFirst(), equals(5));
      expect(queue.removeFirst(), equals(10));
      expect(queue.isEmpty, isTrue);
    });

    test('isEmpty should return true when queue is empty', () {
      final queue = PriorityQueue<int>((a, b) => a - b);
      expect(queue.isEmpty, isTrue);
    });

    test('isEmpty should return false when queue has elements', () {
      final queue = PriorityQueue<int>((a, b) => a - b);
      queue.add(1);
      expect(queue.isEmpty, isFalse);
    });

    test('any should return true if any element satisfies the condition', () {
      final queue = PriorityQueue<int>((a, b) => a - b);
      queue.add(1);
      queue.add(2);
      queue.add(3);

      expect(queue.any((element) => element > 2), isTrue);
    });

    test('any should return false if no elements satisfy the condition', () {
      final queue = PriorityQueue<int>((a, b) => a - b);
      queue.add(1);
      queue.add(2);
      queue.add(3);

      expect(queue.any((element) => element > 3), isFalse);
    });
  });
}
