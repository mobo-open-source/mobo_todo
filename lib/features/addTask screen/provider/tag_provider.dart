import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobo_todo/core/services/odoo_session_manager.dart';
import 'package:mobo_todo/features/login%20screen/provider/session_provider.dart';
import 'package:mobo_todo/features/addTask%20screen/model/tag_model.dart';

class TagProvider with ChangeNotifier {

  List<TaskTag> tagList = [];
  List<TaskTag> selectedTagItems = [];

  int tagPage = 0;
  String tagQuery = "";


  void clearProvider(){

   selectedTagItems.clear();
   tagQuery = "";
   notifyListeners();

  }

  void tagFocus(FocusNode tagNode) {
    tagNode.addListener(() {
      notifyListeners();
    });
  }

  Future<void> searchTags(String query) async {
    tagQuery = query;
    await fetchTags();
  }

  List<TaskTag> getTags(String query) {
    return tagList
        .where((tag) => tag.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void removeTagSelection(String tagName) {
    selectedTagItems.removeWhere((item) => item.name == tagName);
    notifyListeners();
  }

  //////// check tag items already selected or not /////
  void SelectTag(TaskTag tag) {
    final exists = selectedTagItems.any(
      (item) => item.name.toLowerCase() == tag.name.toLowerCase(),
    );
    if (exists) {
      selectedTagItems.removeWhere(
        (item) => item.name.toLowerCase() == tag.name.toLowerCase(),
      );
    } else {
      selectedTagItems.add(tag);
    }

    notifyListeners();
  }

  Future<void> fetchTags() async {
    try {
      

      final tags = await OdooSessionManager.callKwWithCompany({
        'model': 'project.tags',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': tagQuery.isNotEmpty
              ? [
                  ['name', 'ilike', tagQuery],
                ]
              : [],
          'fields': ['id', 'name', 'color'],
          'limit': 8,
        },
      });

      final List<dynamic> items = tags;

      tagList.clear();

      tagList.addAll(items.map((tag) => TaskTag.fromJson(tag)).toList());

      notifyListeners();
    } catch (e) {
      notifyListeners();

    }
  }
}
