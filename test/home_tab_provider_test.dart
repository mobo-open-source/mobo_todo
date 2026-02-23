import 'package:flutter_test/flutter_test.dart';
import 'package:mobo_todo/core/providers/home_tab_provider.dart';

void main() {
  group('HomeTabProvider', () {
    late HomeTabProvider provider;

    setUp(() {
      provider = HomeTabProvider();
    });

    test('initial currentIndex should be 0', () {
      expect(provider.currentIndex, 0);
    });

    test('setTab should update currentIndex and notify listeners', () {
      int notifications = 0;
      provider.addListener(() => notifications++);

      provider.setTab(1);

      expect(provider.currentIndex, 1);
      expect(notifications, 1);
    });

    test('setTab should not notify if index is the same', () {
      int notifications = 0;
      provider.addListener(() => notifications++);

      provider.setTab(0);

      expect(provider.currentIndex, 0);
      expect(notifications, 0);
    });

    test('reset should set currentIndex to 0 and notify listeners', () {
      provider.setTab(2);
      int notifications = 0;
      provider.addListener(() => notifications++);

      provider.reset();

      expect(provider.currentIndex, 0);
      expect(notifications, 1);
    });
  });
}
