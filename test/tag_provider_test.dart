import 'package:flutter_test/flutter_test.dart';
import 'package:mobo_todo/features/addTask%20screen/model/tag_model.dart';
import 'package:mobo_todo/features/addTask%20screen/provider/tag_provider.dart';

void main() {
  group('TagProvider', () {
    late TagProvider provider;

    setUp(() {
      provider = TagProvider();
    });

    test('initial state should be empty', () {
      expect(provider.tagList, isEmpty);
      expect(provider.selectedTagItems, isEmpty);
      expect(provider.tagQuery, isEmpty);
    });

    test('clearProvider should clear selectedTagItems and tagQuery', () {
      provider.selectedTagItems.add(TaskTag(id: 1, name: 'Tag1', color: 1));
      provider.tagQuery = 'search';
      
      int notifications = 0;
      provider.addListener(() => notifications++);

      provider.clearProvider();

      expect(provider.selectedTagItems, isEmpty);
      expect(provider.tagQuery, isEmpty);
      expect(notifications, 1);
    });

    test('SelectTag should add tag if not present', () {
      final tag = TaskTag(id: 1, name: 'Tag1', color: 1);
      
      provider.SelectTag(tag);

      expect(provider.selectedTagItems.length, 1);
      expect(provider.selectedTagItems.first.name, 'Tag1');
    });

    test('SelectTag should remove tag if already present', () {
      final tag = TaskTag(id: 1, name: 'Tag1', color: 1);
      provider.selectedTagItems.add(tag);
      
      provider.SelectTag(tag);

      expect(provider.selectedTagItems, isEmpty);
    });

    test('removeTagSelection should remove tag by name', () {
      provider.selectedTagItems.add(TaskTag(id: 1, name: 'Tag1', color: 1));
      provider.selectedTagItems.add(TaskTag(id: 2, name: 'Tag2', color: 2));
      
      provider.removeTagSelection('Tag1');

      expect(provider.selectedTagItems.length, 1);
      expect(provider.selectedTagItems.first.name, 'Tag2');
    });

    test('getTags should filter tagList by query', () {
      provider.tagList = [
        TaskTag(id: 1, name: 'Work', color: 1),
        TaskTag(id: 2, name: 'Home', color: 2),
        TaskTag(id: 3, name: 'Personal', color: 3),
      ];

      final results = provider.getTags('o');
      
      expect(results.length, 3);
      expect(results.map((t) => t.name), containsAll(['Work', 'Home', 'Personal']));
    });
  });
}
