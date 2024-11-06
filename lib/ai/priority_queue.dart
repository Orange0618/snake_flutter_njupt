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
