import 'package:flutter_test/flutter_test.dart';
import 'package:rndroma/unit_test/counter.dart';

void main() {
  test('Counter value should be incremented', () {
    final Counter counter = Counter();
    counter.increment();
    expect(counter.value, 1);
  });

  // multiple test
  group('Counter', () {
    test('value should start at 0', () {
      expect(Counter().value, 0);
    });

    test('value should be incremented', () {
      final Counter counter = Counter();
      counter.increment();
      expect(counter.value, 1);
    });

    test('value should be decremented', () {
      final Counter counter = Counter();
      counter.decrement();
      expect(counter.value, -1);
    });
  });
}
