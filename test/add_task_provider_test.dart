import 'package:flutter_test/flutter_test.dart';
import 'package:mobo_todo/features/addTask%20screen/model/user_model.dart';
import 'package:mobo_todo/features/addTask%20screen/provider/add_task_provider.dart';

void main() {
  group('AddTaskProvider', () {
    late AddTaskProvider provider;

    setUp(() {
      provider = AddTaskProvider();
    });

    // ─── Initial State ───────────────────────────────────────────────────────

    group('Initial State', () {
      test('should have empty userList', () {
        expect(provider.userList, isEmpty);
      });

      test('should have empty selectedUserItems', () {
        expect(provider.selectedUserItems, isEmpty);
      });

      test('should not be loading', () {
        expect(provider.isLoading, isFalse);
      });

      test('should not be empty', () {
        expect(provider.isEmpty, isFalse);
      });

      test('should have empty userQuery', () {
        expect(provider.userQuery, isEmpty);
      });
    });

    // ─── clearProvider ───────────────────────────────────────────────────────

    group('clearProvider', () {
      test('should clear selectedUserItems', () {
        provider.selectedUserItems.add(UserModel(id: 1, name: 'Alice'));
        provider.clearProvider();
        expect(provider.selectedUserItems, isEmpty);
      });

      test('should clear userQuery', () {
        provider.userQuery = 'test';
        provider.clearProvider();
        expect(provider.userQuery, isEmpty);
      });

      test('should notify listeners', () {
        bool notified = false;
        provider.addListener(() => notified = true);
        provider.clearProvider();
        expect(notified, isTrue);
      });
    });

    // ─── emptytask ───────────────────────────────────────────────────────────

    group('emptytask', () {
      test('should set isEmpty to true', () {
        provider.emptytask();
        expect(provider.isEmpty, isTrue);
      });

      test('should notify listeners', () {
        bool notified = false;
        provider.addListener(() => notified = true);
        provider.emptytask();
        expect(notified, isTrue);
      });
    });

    // ─── clearValidation ─────────────────────────────────────────────────────

    group('clearValidation', () {
      test('should set isEmpty to false', () {
        provider.emptytask(); // set to true first
        provider.clearValidation('any');
        expect(provider.isEmpty, isFalse);
      });

      test('should notify listeners', () {
        bool notified = false;
        provider.addListener(() => notified = true);
        provider.clearValidation('any');
        expect(notified, isTrue);
      });
    });

    // ─── getUsername ─────────────────────────────────────────────────────────

    group('getUsername', () {
      setUp(() {
        provider.userList = [
          UserModel(id: 1, name: 'Alice Smith'),
          UserModel(id: 2, name: 'Bob Jones'),
          UserModel(id: 3, name: 'Charlie Alice'),
        ];
      });

      test('should return users matching query (case-insensitive)', () {
        final result = provider.getUsername('alice');
        expect(result.length, 2);
        expect(result.map((u) => u.name), containsAll(['Alice Smith', 'Charlie Alice']));
      });

      test('should return empty list when no match', () {
        final result = provider.getUsername('xyz');
        expect(result, isEmpty);
      });

      test('should return all users for empty query', () {
        final result = provider.getUsername('');
        expect(result.length, 3);
      });
    });

    // ─── removeSelection ─────────────────────────────────────────────────────

    group('removeSelection', () {
      setUp(() {
        provider.selectedUserItems = [
          UserModel(id: 1, name: 'Alice'),
          UserModel(id: 2, name: 'Bob'),
        ];
      });

      test('should remove user by name', () {
        provider.removeSelection('Alice');
        expect(provider.selectedUserItems.map((u) => u.name), isNot(contains('Alice')));
      });

      test('should keep other users', () {
        provider.removeSelection('Alice');
        expect(provider.selectedUserItems.map((u) => u.name), contains('Bob'));
      });

      test('should notify listeners', () {
        bool notified = false;
        provider.addListener(() => notified = true);
        provider.removeSelection('Alice');
        expect(notified, isTrue);
      });
    });

    // ─── checkUserItem ───────────────────────────────────────────────────────

    group('checkUserItem', () {
      test('should add user when not already selected', () {
        final user = UserModel(id: 1, name: 'Alice');
        provider.checkUserItem(user);
        expect(provider.selectedUserItems, contains(user));
      });

      test('should remove user when already selected', () {
        final user = UserModel(id: 1, name: 'Alice');
        provider.selectedUserItems.add(user);
        provider.checkUserItem(user);
        expect(provider.selectedUserItems, isNot(contains(user)));
      });

      test('should notify listeners', () {
        bool notified = false;
        provider.addListener(() => notified = true);
        provider.checkUserItem(UserModel(id: 1, name: 'Alice'));
        expect(notified, isTrue);
      });
    });

    // ─── getInitialdate ──────────────────────────────────────────────────────

    group('getInitialdate', () {
      test('should return DateTime.now() for empty string', () {
        final result = provider.getInitialdate('');
        final now = DateTime.now();
        expect(result.year, now.year);
        expect(result.month, now.month);
        expect(result.day, now.day);
      });

      test('should parse valid date string', () {
        final result = provider.getInitialdate('2024-06-15');
        expect(result.year, 2024);
        expect(result.month, 6);
        expect(result.day, 15);
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
    });

    // ─── mapPriority ─────────────────────────────────────────────────────────

    group('mapPriority', () {
      test('should return null for Odoo 17 (no priority support)', () {
        final result = provider.mapPriority(selectedIndex: 2, serverVersion: '17');
        expect(result, isNull);
      });

      test('should return "1" for Odoo 18 when index >= 1', () {
        final result = provider.mapPriority(selectedIndex: 1, serverVersion: '18');
        expect(result, '1');
      });

      test('should return "0" for Odoo 18 when index is 0', () {
        final result = provider.mapPriority(selectedIndex: 0, serverVersion: '18');
        expect(result, '0');
      });

      test('should return index as string for Odoo 19+', () {
        final result = provider.mapPriority(selectedIndex: 2, serverVersion: '19');
        expect(result, '2');
      });

      test('should return "0" for Odoo 19+ when index is 0', () {
        final result = provider.mapPriority(selectedIndex: 0, serverVersion: '19');
        expect(result, '0');
      });
    });
  });
}
