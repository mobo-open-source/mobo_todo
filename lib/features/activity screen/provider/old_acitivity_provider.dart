import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobo_todo/core/services/odoo_session_manager.dart';
import 'package:mobo_todo/shared/widgets/snackbars/custom_snackbar.dart';
import 'package:mobo_todo/features/activity%20screen/model/activity_model.dart';
import 'package:mobo_todo/features/activity%20screen/service/activity_service.dart';

class OldAcitivityProvider extends ChangeNotifier {
  // State management
  bool _isLoading = false;
  bool _isCreating = false;
  bool _isUpdating = false;
  String? _error;

  ActivityService? _activityService;
  // Activities data
  List<ActivityModel> _activities = [];
  List<ActivityModel> _allActivities = [];
  Map<String, int> _activitySummary = {};

  // Cache for activity counts per record
  final Map<String, Map<String, int>> _activityCountCache = {};
  // Getters
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  bool get isUpdating => _isUpdating;
  String? get error => _error;
  List<ActivityModel> get activities => _activities;
  List<ActivityModel> get allActivities => _allActivities;
  Map<String, int> get activitySummary => _activitySummary;

  void clearProvider() {
    activities.clear();
    allActivities.clear();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  void initActivityData(ActivityService service) {
    _activityService = service;
  }

  // Get cached activity count for a record
  Map<String, int>? getCachedActivityCount({
    required int resId,
    required String resModel,
  }) {
    final key = '${resModel}_$resId';
    return _activityCountCache[key];
  }

  // Fetch activities for a specific record
  Future<void> fetchActivities({
    required int resId,
    required String resModel,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      _activities = await _activityService!.fetchActivities(
        resId: resId,
        resModel: resModel,
      );
      // Update activity summary
      await _updateActivitySummary(resId: resId, resModel: resModel);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load activities: ${e.toString()}';
      _isLoading = false;
      notifyListeners();

    }
  }

  Future<void> fetchAllActivities() async {
    notifyListeners();
    try {
      final session = await OdooSessionManager.getCurrentSession();
      final userId = session!.userId;

      final data = await Future.any([
        OdooSessionManager.safeCallRPC(
          '/web/session/get_session_info',
          'call',
          {},
        ),
        Future.delayed(const Duration(seconds: 15)).then(
          (_) => throw TimeoutException(
            'Request timed out',
            const Duration(seconds: 15),
          ),
        ),
      ]);

      final isAdmin = data['is_admin'];
      final activities = await OdooSessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['project_id', '=', false],
            ['parent_id', '=', false],
            ['display_in_project', '=', true],
            ['res_model', '=', 'project.task'],
            if (!isAdmin) ['user_id', '=', userId],
          ],
          'fields': [
            'summary',
            'note',
            'res_id',
            'res_name',
            'date_deadline',
            'user_id',
            'activity_type_id',
            'state',
          ],
          // 'limit': 20,
          // 'order': 'date_deadline asc',
        },
      });
      _allActivities.clear();

      final activityList = activities as List;
      _allActivities.addAll(activityList.map((e) => ActivityModel.fromJson(e)));

      notifyListeners();


      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  // Create a new activity
  Future<bool> createActivity({
    required int resId,
    required String resModel,
    required int activityTypeId,
    required String summary,
    required String note,
    required int userId,
    required String dateDeadline,
    required BuildContext context,
  }) async {
    try {
      _isCreating = true;
      _error = null;
      notifyListeners();
      await _activityService!.scheduleActivity(
        assignedUserId: userId,
        noteHtml: note,
        // plannerUserId:,
        // note: note,
        // userId: userId,
        // context: context,
        resId: resId,
        resModel: resModel,
        activityTypeId: activityTypeId,
        summary: summary,
        dateDeadline: dateDeadline,
      );
      // Refresh activities after creation

      await fetchActivities(resId: resId, resModel: resModel);
      Navigator.pop(context);
      CustomSnackbar.showSuccess(context, "Activity created successfully");
      // Clear cache for this record
      _clearCacheForRecord(resId: resId, resModel: resModel);
      _isCreating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to create activity: ${e.toString()}';
      CustomSnackbar.showError(context, "Activity creating failed");
      _isCreating = false;
      notifyListeners();

      return false;
    }
  }

  // Mark activity as done
  Future<bool> markActivityDone({
    required int activityId,
    required int resId,
    required String resModel,
  }) async {
    try {
      _isUpdating = true;
      _error = null;
      notifyListeners();
      await _activityService!.markActivityDone(activityId);
      notifyListeners();
      // Clear cache for this record before refreshing
      _clearCacheForRecord(resId: resId, resModel: resModel);

      // Refresh activities after marking as done
      await fetchActivities(resId: resId, resModel: resModel);

      _isUpdating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to mark activity as done: ${e.toString()}';
      _isUpdating = false;
      notifyListeners();

      return false;
    }
  }
  // Update an activity
  //   required int activityId,
  //   required Map<String, dynamic> updates,
  //   required int resId,
  //   required String resModel,

  //     await _activityService!.updateActivity(
  //       activityId: activityId,
  //       updates: updates,

  //     // Refresh activities after update

  //     // Clear cache for this record



  // Delete an activity
  Future<bool> deleteActivity({
    required int activityId,
    required int resId,
    required String resModel,
  }) async {
    try {
      _isUpdating = true;
      _error = null;
      notifyListeners();

      await _activityService!.deleteActivity(activityId);

      // Clear cache for this record before refreshing
      _clearCacheForRecord(resId: resId, resModel: resModel);

      // Refresh activities after deletion
      await fetchActivities(resId: resId, resModel: resModel);

      _isUpdating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete activity: ${e.toString()}';
      _isUpdating = false;
      notifyListeners();

      return false;
    }
  }

  // Get activity count for a record (with caching)
  Future<Map<String, int>> getActivityCount({
    required int resId,
    required String resModel,
    bool forceRefresh = false,
  }) async {
    final key = '${resModel}_$resId';

    // Return cached data if available and not forcing refresh
    if (!forceRefresh && _activityCountCache.containsKey(key)) {
      return _activityCountCache[key]!;
    }

    try {
      final summary = await _activityService!.getActivitySummary(
        resId: resId,
        resModel: resModel,
      );

      // Cache the result
      _activityCountCache[key] = summary;

      return summary;
    } catch (e) {

      return {'total': 0, 'overdue': 0, 'today': 0, 'planned': 0};
    }
  }

  // Update activity summary for current activities
  Future<void> _updateActivitySummary({
    required int resId,
    required String resModel,
  }) async {
    try {
      _activitySummary = await _activityService!.getActivitySummary(
        resId: resId,
        resModel: resModel,
      );

      // Update cache
      final key = '${resModel}_$resId';
      _activityCountCache[key] = _activitySummary;
    } catch (e) {

    }
  }

  // Clear cache for a specific record
  void _clearCacheForRecord({required int resId, required String resModel}) {
    final key = '${resModel}_$resId';
    _activityCountCache.remove(key);

  }

  // Clear all cached data
  void clearCache() {
    _activityCountCache.clear();
    notifyListeners();
  }

  // Get activity types (cached)
  List<Map<String, dynamic>>? _activityTypes;

  Future<List<Map<String, dynamic>>> getActivityTypes() async {
    if (_activityTypes != null) {
      return _activityTypes!;
    }

    try {
      _activityTypes = await _activityService!.getActivityTypes();
      return _activityTypes!;
    } catch (e) {

      return [];
    }
  }

  // Get users (cached)
  List<Map<String, dynamic>>? _users;

  Future<List<Map<String, dynamic>>> getUsers() async {
    if (_users != null) {
      return _users!;
    }

    try {
      _users = await _activityService!.getUsers();
      return _users!;
    } catch (e) {

      return [];
    }
  }

  // Reset provider state
  void reset() {
    _activities = [];
    _activitySummary = {};
    _activityCountCache.clear();
    _activityTypes = null;
    _users = null;
    _isLoading = false;
    _isCreating = false;
    _isUpdating = false;
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _activities.clear();
    _activitySummary.clear();
    _activityCountCache.clear();
    super.dispose();
  }
}
