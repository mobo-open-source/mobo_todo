import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:mobo_todo/shared/widgets/snackbars/custom_snackbar.dart';
import 'package:mobo_todo/core/utils/color_constants.dart';
import 'package:mobo_todo/features/activity%20screen/model/activity_model.dart';
import 'package:mobo_todo/features/activity%20screen/provider/old_acitivity_provider.dart';
import 'package:mobo_todo/features/activity%20screen/service/activity_icon.dart';
import 'package:mobo_todo/features/activity%20screen/service/add_activitiy.dart';

import 'package:provider/provider.dart';

class CompactActivityOverlay extends StatefulWidget {
  final int resId;
  final String resModel;
  final String recordName;
  final VoidCallback? onActivityChanged;

  const CompactActivityOverlay({
    super.key,
    required this.resId,
    required this.resModel,
    required this.recordName,
    this.onActivityChanged,
  });

  @override
  State<CompactActivityOverlay> createState() => _CompactActivityOverlayState();
}

class _CompactActivityOverlayState extends State<CompactActivityOverlay> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _fetchActivities();
    });
  }

  Future<void> _fetchActivities() async {

    final _activityProvider = Provider.of<OldAcitivityProvider>(
      context,
      listen: false,
    );
    await _activityProvider.fetchActivities(
      resId: widget.resId,
      resModel: widget.resModel,
    );

    // Debug log each activity
    for (var activity in _activityProvider.activities) {
      final activityTypeName = activity.activityTypeId.isNotEmpty
          ? (activity.activityTypeId[1]?.toString() ?? 'Unknown')
          : 'No Type';

    }
  }

  Future<void> _markActivityDone(ActivityModel activity) async {
    final _activityProvider = Provider.of<OldAcitivityProvider>(
      context,
      listen: false,
    );
    final success = await _activityProvider.markActivityDone(
      activityId: activity.id,
      resId: widget.resId,
      resModel: widget.resModel,
    );

    if (success) {
      // Call the parent callback to refresh kanban view
      widget.onActivityChanged?.call();

      if (mounted) {
        CustomSnackbar.showSuccess(
          context,
          "Activity Marked as done successfully",
        );

        // Close the overlay after successful completion
        // This allows the user to click the activity icon again to see updated state
        Navigator.of(context).pop();
      }
    } else if (_activityProvider.error != null) {
      if (mounted) {
        CustomSnackbar.showError(context, "Activity Marked as done failed");
        // CustomSnackBar.showCustomSnackBar(
        //   context: context,
        //   type: SnackBarType.error,
        //   message: _activityProvider.error!,
      }
    }
  }

  Future<void> _deleteActivity(ActivityModel activity) async {
    final _activityProvider = Provider.of<OldAcitivityProvider>(
      context,
      listen: false,
    );

    final success = await _activityProvider.deleteActivity(
      activityId: activity.id,
      resId: widget.resId,
      resModel: widget.resModel,
    );

    if (success) {
      // Call the parent callback to refresh kanban view
      widget.onActivityChanged?.call();

      if (mounted) {
        CustomSnackbar.showSuccess(context, "Activity deleted successfully");
        // CustomSnackBar.showCustomSnackBar(
        //   context: context,
        //   type: SnackBarType.success,
        //   message: 'Activity deleted',

        // Close the overlay after successful deletion
        // This allows the user to click the activity icon again to see updated state
        Navigator.of(context).pop();
      }
    } else if (_activityProvider.error != null) {
      if (mounted) {
        CustomSnackbar.showError(context, "Activity deleted failed");
        // CustomSnackBar.showCustomSnackBar(
        //   context: context,
        //   type: SnackBarType.error,
        //   message: _activityProvider.error!,
      }
    }
  }

  void _showCreateActivityDialog() {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) => AddActivityDialog(
        resId: widget.resId,
        model: widget.resModel,
        onSuccess: () {
          _fetchActivities();
          widget.onActivityChanged?.call();
        },
      ),
    );
  }

  void _showDeleteConfirmation(ActivityModel activity, bool isdarkmode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isdarkmode
            ? ColorConstants.Grey800
            : ColorConstants.mainWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedDelete02,
              color: Colors.red,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Delete Activity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,

                color: isdarkmode
                    ? ColorConstants.mainWhite
                    : ColorConstants.mainBlack,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete this activity? This action cannot be undone.',
          style: TextStyle(
            fontSize: 14,

            color: isdarkmode
                ? ColorConstants.mainWhite
                : ColorConstants.mainBlack,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteActivity(activity);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _getActivityState(ActivityModel activity) {
    final now = DateTime.now();
    final deadline = DateTime.parse(activity.dateDeadline);

    if (deadline.isBefore(now)) {
      return 'overdue';
    } else if (deadline.day == now.day &&
        deadline.month == now.month &&
        deadline.year == now.year) {
      return 'today';
    } else if (deadline.difference(now).inDays == 1) {
      return 'tomorrow';
    } else {
      return 'planned';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Consumer<OldAcitivityProvider>(
      builder: (context, provider, child) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
              maxWidth: 400,
            ),
            decoration: BoxDecoration(
              color: isDarkTheme
                  ? ColorConstants.Grey800
                  : ColorConstants.mainWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkTheme
                        ? ColorConstants.Grey800
                        : ColorConstants.mainWhite,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      // HugeIcon(
                      //   icon:  HugeIcons.strokeRoundedCalendar03,
                      //   color:  isDarkTheme ? ColorConstants.mainWhite : ColorConstants.mainBlack,
                      //   size: 20,
                      // ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Activities',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDarkTheme
                                    ? ColorConstants.mainWhite
                                    : ColorConstants.mainBlack,
                              ),
                            ),
                            Text(
                              widget.recordName,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (provider.activities.isNotEmpty)
                        IconButton(
                          onPressed: provider.isCreating
                              ? null
                              : _showCreateActivityDialog,
                          icon: provider.isCreating
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : HugeIcon(
                                  icon: HugeIcons.strokeRoundedAdd01,
                                  size: 18,
                                  color: isDarkTheme
                                      ? ColorConstants.mainWhite
                                      : Theme.of(context).primaryColor,
                                ),
                          style: IconButton.styleFrom(
                            backgroundColor: isDarkTheme
                                ? ColorConstants.mainBlack
                                : Colors.white,
                            foregroundColor: Theme.of(context).primaryColor,
                            padding: const EdgeInsets.all(6),
                            minimumSize: const Size(32, 32),
                          ),
                        ),
                      SizedBox(width: 4),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedCancel01,
                          size: 18,
                          color: isDarkTheme
                              ? ColorConstants.mainWhite
                              : ColorConstants.mainBlack,
                        ),
                        style: IconButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                          padding: EdgeInsets.all(6),
                          minimumSize: Size(32, 32),
                        ),
                      ),
                    ],
                  ),
                ),

                // Activities List
                Flexible(
                  child: provider.isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(
                                'Loading activities...',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : provider.activities.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedCalendar03,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 12),
                              Text(
                                'No activities found',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Create your first activity',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                              const SizedBox(height: 16),

                              ElevatedButton.icon(
                                onPressed: provider.isCreating
                                    ? null
                                    : _showCreateActivityDialog,
                                icon: const HugeIcon(
                                  icon: HugeIcons.strokeRoundedAdd01,
                                  size: 16,
                                ),
                                label: const Text('Create Activity'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  elevation: 0,
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(12),
                          itemCount: provider.activities.length,
                          itemBuilder: (context, index) {
                            final activity = provider.activities[index];
                            final activityState = _getActivityState(activity);
                            final activityTypeName =
                                activity.activityTypeId.isNotEmpty
                                ? (activity.activityTypeId[1]?.toString() ??
                                      'Activity')
                                : 'Activity';
                            final assigneeName = activity.userId.isNotEmpty
                                ? (activity.userId[1]?.toString() ??
                                      'Unassigned')
                                : 'Unassigned';

                            // Handle summary properly - check for empty, null, or "false" string
                            final hasValidSummary =
                                activity.summary.isNotEmpty &&
                                activity.summary != 'false' &&
                                activity.summary != 'null';
                            final displaySummary = hasValidSummary
                                ? activity.summary
                                : activityTypeName;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: isDarkTheme
                                    ? ColorConstants.Grey800
                                    : ColorConstants.mainWhite,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey[200]!,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        ActivityIcon(
                                          activityType: activityTypeName,
                                          activityState: activityState,
                                          filled: true,
                                          size: 16,
                                          radius: 12,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                displaySummary,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: isDarkTheme
                                                      ? ColorConstants.mainWhite
                                                      : ColorConstants
                                                            .mainBlack,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                assigneeName,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: isDarkTheme
                                                      ? ColorConstants.mainWhite
                                                      : Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Action buttons
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () =>
                                                  _markActivityDone(activity),
                                              icon: HugeIcon(
                                                icon: HugeIcons
                                                    .strokeRoundedCheckmarkCircle01,
                                                size: 20,
                                              ),
                                              style: IconButton.styleFrom(
                                                foregroundColor: Colors.green,
                                                padding: const EdgeInsets.all(
                                                  4,
                                                ),
                                                minimumSize: const Size(28, 28),
                                              ),
                                              tooltip: 'Mark as Done',
                                            ),
                                            IconButton(
                                              onPressed: () =>
                                                  _showDeleteConfirmation(
                                                    activity,
                                                    isDarkTheme,
                                                  ),
                                              icon: const HugeIcon(
                                                icon: HugeIcons
                                                    .strokeRoundedDelete02,
                                                size: 20,
                                              ),
                                              style: IconButton.styleFrom(
                                                foregroundColor: Colors.red,
                                                padding: const EdgeInsets.all(
                                                  4,
                                                ),
                                                minimumSize: const Size(28, 28),
                                              ),
                                              tooltip: 'Delete',
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    if (activity.note.isNotEmpty) ...[
                                      Container(
                                        padding: EdgeInsets.all(0),
                                        decoration: BoxDecoration(
                                          color: isDarkTheme
                                              ? ColorConstants.Grey800
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Html(
                                          data: activity.note,
                                          style: {
                                            "body": Style(
                                              margin: Margins.zero,
                                              padding: HtmlPaddings.zero,
                                              fontSize: FontSize(11),
                                              color: ColorConstants.mainGrey,
                                            ),
                                          },
                                        ),
                                        // Text(
                                        //   activity.note,
                                        //   style: TextStyle(
                                        //     fontSize: 11,
                                        //     color: Colors.grey[700],
                                        //   ),
                                        //   maxLines: 2,
                                        //   overflow: TextOverflow.ellipsis,
                                        // ),
                                      ),
                                    ],
                                    Row(
                                      children: [
                                        HugeIcon(
                                          icon:
                                              HugeIcons.strokeRoundedCalendar03,
                                          size: 12,
                                          color: isDarkTheme
                                              ? ColorConstants.mainWhite
                                              : Colors.grey[500],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          DateFormat('MMM dd, yyyy').format(
                                            DateTime.parse(
                                              activity.dateDeadline,
                                            ),
                                          ),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: isDarkTheme
                                                ? ColorConstants.mainWhite
                                                : Colors.grey[600],
                                          ),
                                        ),
                                        const Spacer(),
                                        ActivityIcon(
                                          activityType: activityTypeName,
                                          activityState: activityState,
                                          isLabel: true,
                                          size: 10,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Helper function to show the compact activity overlay
class CompactActivityOverlayHelper {
  static void showActivityOverlay({
    required BuildContext context,
    required int resId,
    required String resModel,
    required String recordName,
    VoidCallback? onActivityChanged,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CompactActivityOverlay(
        resId: resId,
        resModel: resModel,
        recordName: recordName,
        onActivityChanged: onActivityChanged,
      ),
    );
  }
}
