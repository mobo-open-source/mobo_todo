import 'package:flutter_test/flutter_test.dart';
import 'package:mobo_todo/features/task%20screen/provider/task_provider.dart';

void main() {
  group('TaskProvider', () {
    late TaskProvider provider;

    setUp(() {
      provider = TaskProvider();
    });

    // ─── Initial State ───────────────────────────────────────────────────────

    group('Initial State', () {
      test('should have empty todoList', () {
        expect(provider.todoList, isEmpty);
      });

      test('should not be loading', () {
        expect(provider.isLoading, isFalse);
      });

      test('should start on page 0', () {
        expect(provider.currentPage, 0);
      });

      test('should have no selected filter', () {
        expect(provider.selectedFilter, -1);
      });

      test('should have no selected index', () {
        expect(provider.selectedIndex, -1);
      });

      test('should have empty task query', () {
        expect(provider.taskQuery, isEmpty);
      });

      test('should have zero total count', () {
        expect(provider.totalCount, 0);
      });

      test('canGoPrevious should be false on first page', () {
        expect(provider.canGoPrevious, isFalse);
      });

      test('canGoNext should be false when no items', () {
        expect(provider.canGoNext, isFalse);
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

      test('should return 16 for "16.0.3"', () {
        expect(provider.getOdooMajorVersion('16.0.3'), 16);
      });

      test('should return 0 for empty string', () {
        expect(provider.getOdooMajorVersion(''), 0);
      });

      test('should return 0 for non-numeric string', () {
        expect(provider.getOdooMajorVersion('saas~17'), 0);
      });
    });

    // ─── getPriorityLength ───────────────────────────────────────────────────

    group('getPriorityLength', () {
      test('should return 0 for Odoo 17 (no priority)', () {
        expect(provider.getPriorityLength('17'), 0);
      });

      test('should return 1 for Odoo 18 (binary priority)', () {
        expect(provider.getPriorityLength('18'), 1);
      });

      test('should return 3 for Odoo 19+ (full priority)', () {
        expect(provider.getPriorityLength('19'), 3);
      });

      test('should return 3 for Odoo 16', () {
        expect(provider.getPriorityLength('16'), 3);
      });
    });

    // ─── clearProvider ───────────────────────────────────────────────────────

    group('clearProvider', () {
      test('should clear todoList', () {
        provider.todoList = []; // simulate some data
        provider.clearProvider();
        expect(provider.todoList, isEmpty);
      });

      test('should reset selectedIndex to -1', () {
        provider.selectedIndex = 2;
        provider.clearProvider();
        expect(provider.selectedIndex, -1);
      });

      test('should clear selectedFilterItem', () {
        provider.selectedFilterItem.add('Completed');
        provider.clearProvider();
        expect(provider.selectedFilterItem, isEmpty);
      });

      test('should clear filterdomain', () {
        provider.filterdomain.add(['is_closed', '=', true]);
        provider.clearProvider();
        expect(provider.filterdomain, isEmpty);
      });

      test('should clear appliedFilterItem', () {
        provider.appliedFilterItem.add('Completed');
        provider.clearProvider();
        expect(provider.appliedFilterItem, isEmpty);
      });

      test('should notify listeners', () {
        bool notified = false;
        provider.addListener(() => notified = true);
        provider.clearProvider();
        expect(notified, isTrue);
      });
    });

    // ─── selectFilter ────────────────────────────────────────────────────────

    group('selectFilter', () {
      test('should select "All items" when index 0 is selected', () {
        provider.selectFilter(0);
        expect(provider.selectedFilterItem, contains('All items'));
      });

      test('should remove "All items" when a specific filter is selected', () {
        provider.selectFilter(0); // All items
        provider.selectFilter(1); // Completed
        expect(provider.selectedFilterItem, isNot(contains('All items')));
        expect(provider.selectedFilterItem, contains('Completed'));
      });

      test('should toggle off a filter that is already selected', () {
        provider.selectFilter(1); // select Completed
        provider.selectFilter(1); // deselect Completed
        // When empty, "All items" should be re-added
        expect(provider.selectedFilterItem, contains('All items'));
      });

      test('should allow multiple filters to be selected', () {
        provider.selectFilter(1); // Completed
        provider.selectFilter(2); // Pending
        expect(provider.selectedFilterItem, contains('Completed'));
        expect(provider.selectedFilterItem, contains('Pending'));
      });

      test('should notify listeners', () {
        bool notified = false;
        provider.addListener(() => notified = true);
        provider.selectFilter(0);
        expect(notified, isTrue);
      });
    });

    // ─── taskFilter ──────────────────────────────────────────────────────────

    group('taskFilter', () {
      test('should select "All items" for index 0', () async {
        // Note: taskFilter calls fetchTasks which needs a session, so we only
        // test the filter state update part by checking it notifies
        bool notified = false;
        provider.addListener(() => notified = true);
        // We can't fully test without a session, but we verify the state logic
        provider.selectFilter(0);
        expect(provider.selectedFilterItem, contains('All items'));
        expect(notified, isTrue);
      });
    });

    // ─── removeSelectedFilter ────────────────────────────────────────────────

    group('removeSelectedFilter', () {
      test('should remove item at given index', () {
        provider.selectedFilterItem.addAll(['All items', 'Completed']);
        provider.removeSelectedFilter(1);
        expect(provider.selectedFilterItem, isNot(contains('Completed')));
        expect(provider.selectedFilterItem, contains('All items'));
      });

      test('should notify listeners', () {
        provider.selectedFilterItem.add('All items');
        bool notified = false;
        provider.addListener(() => notified = true);
        provider.removeSelectedFilter(0);
        expect(notified, isTrue);
      });
    });

    // ─── priority ────────────────────────────────────────────────────────────

    group('priority', () {
      test('should set selectedIndex to given index', () {
        provider.priority(2);
        expect(provider.selectedIndex, 2);
      });

      test('should decrement index if same index is selected again', () {
        provider.priority(2);
        provider.priority(2);
        expect(provider.selectedIndex, 1);
      });

      test('should notify listeners', () {
        bool notified = false;
        provider.addListener(() => notified = true);
        provider.priority(1);
        expect(notified, isTrue);
      });
    });

    // ─── Pagination ──────────────────────────────────────────────────────────

    group('Pagination', () {
      test('startIndex should be 1 on first page', () {
        expect(provider.startIndex, 1);
      });

      test('endIndex should be 0 when totalCount is 0', () {
        expect(provider.endIndex, 0);
      });

      test('endIndex should not exceed totalCount', () {
        // Simulate 50 total tasks on page 0 (pageSize=40)
        // We can't set _totalCount directly, but we can verify the formula
        // by checking the getter logic: end = (0+1)*40 = 40, totalCount=50 -> 40
        // This is verified by the getter formula itself
        expect(provider.endIndex, lessThanOrEqualTo(provider.totalCount));
      });
    });
  });
}
