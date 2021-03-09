import 'dart:async';

abstract class FilterController {
  static int _currentData;
  static int get currentData => _currentData;

  static StreamController _streamController;

  static void init() => _streamController = StreamController.broadcast();

  static Stream get stream => _streamController.stream;

  static void change(value) {
    _streamController.add(value);
    _currentData = value;
  }

  static void dispose() {
    _streamController.close();
    _currentData = null;
  }
}
