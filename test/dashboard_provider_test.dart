import 'package:flutter_test/flutter_test.dart';
import 'package:mobo_todo/features/dashboard%20screen/provider/dash_board_provider.dart';

void main() {
  group('DashBoardProvider', () {
    late DashBoardProvider provider;

    setUp(() {
      provider = DashBoardProvider();
    });

    // ─── Initial State ───────────────────────────────────────────────────────

    group('Initial State', () {
      test('should not be loading', () {
        expect(provider.isLoading, isFalse);
      });

      test('should have zero totalTaskCount', () {
        expect(provider.totalTaskCount, 0);
      });

      test('should have zero CompletedTaskCount', () {
        expect(provider.CompletedTaskCount, 0);
      });

      test('should have zero pendingTaskCount', () {
        expect(provider.pendingTaskCount, 0);
      });

      test('should have zero todayTaskCount', () {
        expect(provider.todayTaskCount, 0);
      });

      test('should have zero weekTaskCount', () {
        expect(provider.weekTaskCount, 0);
      });

      test('should have zero monthTaskCount', () {
        expect(provider.monthTaskCount, 0);
      });

      test('should have zero lowPriorityTaskCount', () {
        expect(provider.lowPriorityTaskCount, 0);
      });

      test('should have zero mediumPriorityTaskCount', () {
        expect(provider.mediumPriorityTaskCount, 0);
      });

      test('should have zero highPriorityTaskCount', () {
        expect(provider.highPriorityTaskCount, 0);
      });

      test('should have selectedScreen as 0', () {
        expect(provider.selectedScreen, 0);
      });

      test('should have empty username', () {
        expect(provider.username, isEmpty);
      });

      test('should have null userImage', () {
        expect(provider.userImage, isNull);
      });

      test('should have empty recentTasks', () {
        expect(provider.recentTasks, isEmpty);
      });
    });

    // ─── screens ─────────────────────────────────────────────────────────────

    group('screens', () {
      test('should update selectedScreen', () {
        provider.screens(2);
        expect(provider.selectedScreen, 2);
      });

      test('should notify listeners when screen changes', () {
        bool notified = false;
        provider.addListener(() => notified = true);
        provider.screens(3);
        expect(notified, isTrue);
      });

      test('should allow setting screen to 0', () {
        provider.screens(2);
        provider.screens(0);
        expect(provider.selectedScreen, 0);
      });
    });

    // ─── clearProvider ───────────────────────────────────────────────────────

    group('clearProvider', () {
      test('should reset totalTaskCount to 0', () {
        provider.totalTaskCount = 10;
        provider.clearProvider();
        expect(provider.totalTaskCount, 0);
      });

      test('should reset CompletedTaskCount to 0', () {
        provider.CompletedTaskCount = 5;
        provider.clearProvider();
        expect(provider.CompletedTaskCount, 0);
      });

      test('should reset pendingTaskCount to 0', () {
        provider.pendingTaskCount = 3;
        provider.clearProvider();
        expect(provider.pendingTaskCount, 0);
      });

      test('should reset todayTaskCount to 0', () {
        provider.todayTaskCount = 2;
        provider.clearProvider();
        expect(provider.todayTaskCount, 0);
      });

      test('should reset weekTaskCount to 0', () {
        provider.weekTaskCount = 7;
        provider.clearProvider();
        expect(provider.weekTaskCount, 0);
      });

      test('should reset monthTaskCount to 0', () {
        provider.monthTaskCount = 20;
        provider.clearProvider();
        expect(provider.monthTaskCount, 0);
      });

      test('should reset highPriorityTaskCount to 0', () {
        provider.highPriorityTaskCount = 4;
        provider.clearProvider();
        expect(provider.highPriorityTaskCount, 0);
      });

      test('should reset selectedScreen to 0', () {
        provider.screens(3);
        provider.clearProvider();
        expect(provider.selectedScreen, 0);
      });

      test('should reset userImage to null', () {
        provider.clearProvider();
        expect(provider.userImage, isNull);
      });

      test('should notify listeners', () {
        bool notified = false;
        provider.addListener(() => notified = true);
        provider.clearProvider();
        expect(notified, isTrue);
      });
    });

    // ─── getOdooMajorVersion ─────────────────────────────────────────────────

    group('getOdooMajorVersion', () {
      test('should return 17 for "17.0.1"', () {
        expect(provider.getOdooMajorVersion('17.0.1'), 17);
      });

      test('should return 18 for "18.0"', () {
        expect(provider.getOdooMajorVersion('18.0'), 18);
      });

      test('should return 0 for empty string', () {
        expect(provider.getOdooMajorVersion(''), 0);
      });

      test('should return 16 for "16.0.3"', () {
        expect(provider.getOdooMajorVersion('16.0.3'), 16);
      });
    });

    // ─── odooDateTime ────────────────────────────────────────────────────────

    group('odooDateTime', () {
      test('should format DateTime to Odoo-compatible string', () {
        final dt = DateTime(2024, 6, 15, 10, 30, 0);
        final result = provider.odooDateTime(dt);
        expect(result, isA<String>());
        expect(result, contains('2024'));
        expect(result, contains('06'));
        expect(result, contains('15'));
      });

      test('should return a non-empty string', () {
        final result = provider.odooDateTime(DateTime.now());
        expect(result, isNotEmpty);
      });

      test('should pad month and day with leading zeros', () {
        final dt = DateTime(2024, 1, 5, 9, 5, 0);
        final result = provider.odooDateTime(dt);
        expect(result, contains('01'));
        expect(result, contains('05'));
      });
    });
  });
}
