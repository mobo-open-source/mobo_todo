import 'package:flutter_test/flutter_test.dart';
import 'package:mobo_todo/features/activity%20screen/model/activity_model.dart';
import 'package:mobo_todo/features/activity%20screen/model/activity_type_model.dart';
import 'package:mobo_todo/features/activity%20screen/provider/activity_provider.dart';
import 'package:mobo_todo/features/addTask%20screen/model/user_model.dart';

void main() {
  group('ActivityProvider', () {
    late ActivityProvider provider;

    setUp(() {
      provider = ActivityProvider();
    });

    test('initial state should be correct', () {
      expect(provider.isloding, isFalse);
      expect(provider.activityUser, isEmpty);
      expect(provider.activity, isEmpty);
      expect(provider.activityType, isEmpty);
      expect(provider.selecteActivity, isNull);
      expect(provider.selectUser, isNull);
      expect(provider.userQuery, isEmpty);
      expect(provider.activityQuery, isEmpty);
    });

    test('clearProvider should reset state and notify listeners', () {
      provider.activityUser.add(UserModel(id: 1, name: 'User 1'));
      provider.activity.add(ActivityModel(
        id: 1,
        summary: 'A1',
        resName: 'Name',
        dateDeadline: '2024-01-01',
        state: 'todo',
        activityTypeId: [1, 'Type'],
        note: '',
        userId: [1, 'User'],
        createDate: '2024-01-01',
        writeDate: '2024-01-01',
      ));
      provider.selecteActivity = ActivityTypeModel(id: 1, name: 'Type 1', icon: 'icon');
      provider.userQuery = 'user';
      provider.activityQuery = 'act';

      int notifications = 0;
      provider.addListener(() => notifications++);

      provider.clearProvider();

      expect(provider.activityUser, isEmpty);
      expect(provider.activity, isEmpty);
      expect(provider.selecteActivity, isNull);
      expect(provider.userQuery, isEmpty);
      expect(provider.activityQuery, isEmpty);
      expect(notifications, 1);
    });

    test('onSelecteeUser should update selectUser', () {
      final user = UserModel(id: 1, name: 'User 1');
      provider.onSelecteeUser(user);
      expect(provider.selectUser, user);
    });

    test('onSelectedtype should update selecteActivity', () {
      final type = ActivityTypeModel(id: 1, name: 'Type 1', icon: 'icon');
      provider.onSelectedtype(type);
      expect(provider.selecteActivity, type);
    });

    test('getUsernames should filter activityUser by query', () {
      provider.activityUser = [
        UserModel(id: 1, name: 'Alice'),
        UserModel(id: 2, name: 'Bob'),
        UserModel(id: 3, name: 'Charlie'),
      ];

      final results = provider.getUsernames('a');
      expect(results.length, 2);
      expect(results.map((u) => u.name), containsAll(['Alice', 'Charlie']));
    });

    test('getActivityType should filter activityType by query', () {
      provider.activityType = [
        ActivityTypeModel(id: 1, name: 'Call', icon: 'c'),
        ActivityTypeModel(id: 2, name: 'Email', icon: 'e'),
        ActivityTypeModel(id: 3, name: 'Meeting', icon: 'm'),
      ];

      final results = provider.getActivityType('e');
      expect(results.length, 2);
      expect(results.map((t) => t.name), containsAll(['Email', 'Meeting']));
    });
  });
}
