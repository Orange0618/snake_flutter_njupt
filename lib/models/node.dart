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
  int get hashCode => x * 31 + y;
}
