import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_todo/core/utils/color_constants.dart';
import 'package:mobo_todo/features/activity%20screen/overlay/compact_activity_overlay.dart';
import 'package:mobo_todo/features/activity%20screen/provider/old_acitivity_provider.dart';
import 'package:mobo_todo/features/activity%20screen/service/activity_icon.dart';
import 'package:mobo_todo/features/activity%20screen/service/activity_utils.dart';

import 'package:provider/provider.dart';

class EnhancedActivityIcon extends StatefulWidget {
  final bool isDarkmode;
  final int resId;
  final String resModel;
  final String recordName;
  final String? activityType;
  final String? activityState;
  final bool showBadge;
  final double size;
  final double radius;
  final VoidCallback? onActivityChanged;

  const EnhancedActivityIcon({
    super.key,
    required this.resId,
    required this.resModel,
    required this.recordName,
    this.activityType,
    this.activityState,
    this.showBadge = true,
    this.size = 17,
    this.radius = 14,
    this.onActivityChanged,
    required this.isDarkmode,
  });

  @override
  State<EnhancedActivityIcon> createState() => _EnhancedActivityIconState();
}

class _EnhancedActivityIconState extends State<EnhancedActivityIcon> {
  Map<String, int>? _activityCount;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.showBadge) {
        _loadActivityCount();
      }
    });
  }

  Future<void> _loadActivityCount() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final activityProvider = Provider.of<OldAcitivityProvider>(
        context,
        listen: false,
      );

      final count = await activityProvider.getActivityCount(
        resId: widget.resId,
        resModel: widget.resModel,
      );
      if (mounted) {
        setState(() {
          _activityCount = count;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showActivityOverlay() {
    CompactActivityOverlayHelper.showActivityOverlay(
      context: context,
      resId: widget.resId,
      resModel: widget.resModel,
      recordName: widget.recordName,
      onActivityChanged: () {
        // Call parent callback first
        widget.onActivityChanged?.call();
        // Force refresh activity count after changes
        if (widget.showBadge) {
          _loadActivityCount();
        }
        // Force rebuild of the widget to reflect changes
        if (mounted) {
          setState(() {
            // This will trigger a rebuild with updated activity count
          });
        }
      },
    );
  }

        

  Color _getBadgeColor() {
  
    if (_activityCount == null) return Colors.grey;
    final overdue = _activityCount!['overdue'] ?? 0;
    final today = _activityCount!['today'] ?? 0;
    if (overdue > 0) return Colors.red;
    if (today > 0) return Colors.orange;
    return Colors.green;
  }

  String _getBadgeText() {
    if (_activityCount == null) return '';
    final total = _activityCount!['total'] ?? 0;
    if (total > 99) return '99+';
    return total.toString();
  }

  Widget _buildActivityIcon() {
    // If we have specific activity type and state, use the standard ActivityIcon
    if (widget.activityType != null && widget.activityState != null) {
      return ActivityIcon(
        activityType: widget.activityType,
        activityState: widget.activityState,
        size: widget.size,
        radius: widget.radius,
      );
    }
    // Otherwise, show a generic activity icon based on activity count
    Color iconColor = Colors.grey;
    HugeIcon iconData = HugeIcon(
      icon: HugeIcons.strokeRoundedCalendar03,
      color: Colors.black,
    );

    if (_activityCount != null) {
      final overdue = _activityCount!['overdue'] ?? 0;
      final today = _activityCount!['today'] ?? 0;
      final total = _activityCount!['total'] ?? 0;

      if (total == 0) {
        iconColor = Colors.grey[400]!;

        iconData = HugeIcon(
          icon: HugeIcons.strokeRoundedCalendar03,
          color: Colors.black,
        );
      } else if (overdue > 0) {
        iconColor = Colors.red;

        iconData = HugeIcon(
          icon: HugeIcons.strokeRoundedAlarmClock,
          color: Colors.black,
        );
      } else if (today > 0) {
        iconColor = Colors.orange;

        iconData = HugeIcon(
          icon: HugeIcons.strokeRoundedCalendar03,
          color: Colors.black,
        );
      } else {
        iconColor = Colors.green;

        iconData = HugeIcon(
          icon: HugeIcons.strokeRoundedCalendar03,
          color: Colors.black,
        );
      }
    }
    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: widget.isDarkmode
          ? ColorConstants.grey100
          : ColorConstants.backgroundWhite,
      child: iconData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showActivityOverlay,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main activity icon
          _isLoading
              ? SizedBox(
                  width: widget.radius * 2,
                  height: widget.radius * 2,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : _buildActivityIcon(),
          // Badge for activity count
          if (widget.showBadge &&
              _activityCount != null &&
              (_activityCount!['total'] ?? 0) > 0 &&
              !_isLoading)
            Positioned(
              top: -2,
              right: -1,

              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _getBadgeColor(),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 10),
                child: Text(
                  _getBadgeText(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          // Priority indicator for overdue activities
          if (widget.showBadge &&
              _activityCount != null &&
              (_activityCount!['overdue'] ?? 0) > 0 &&
              !_isLoading)
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Enhanced Activity Icon for Kanban Tiles
class ActivityIconCustom extends StatelessWidget {
  final bool isdarkmode;
  final Map<dynamic, dynamic> record;
  final VoidCallback? onActivityChanged;

  const ActivityIconCustom({
    super.key,
    required this.record,
    this.onActivityChanged,
    required this.isdarkmode,
  });
  @override
  Widget build(BuildContext context) {
    // Extract activity information using utilities
    final activityInfo = ActivityUtils.extractActivityInfo(record);
    final recordId = ActivityUtils.getRecordId(record);
    final recordName = ActivityUtils.getRecordName(record);
    final recordModel = ActivityUtils.getRecordModel(record);
    // Determine activity state from deadline if not explicitly set
    String? activityState = activityInfo['state'];
    if (activityState == null && activityInfo['deadline'] != null) {
      activityState = ActivityUtils.determineActivityState(
        activityInfo['deadline'],
      );
    }
    return EnhancedActivityIcon(
      isDarkmode: isdarkmode,
      resId: recordId,
      resModel: recordModel,
      recordName: recordName,
      activityType: activityInfo['type'],
      activityState: activityState,
      showBadge: false,
      onActivityChanged: onActivityChanged,
    );
  }
}

// Simple Activity Counter Widget
class ActivityCounter extends StatefulWidget {
  final int resId;
  final String resModel;
  final TextStyle? textStyle;
  final bool showIcon;

  const ActivityCounter({
    super.key,
    required this.resId,
    required this.resModel,
    this.textStyle,
    this.showIcon = true,
  });

  @override
  State<ActivityCounter> createState() => _ActivityCounterState();
}

class _ActivityCounterState extends State<ActivityCounter> {
  Map<String, int>? _activityCount;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActivityCount();
  }

  Future<void> _loadActivityCount() async {
    if (!mounted) return;

    try {
      final activityProvider = Provider.of<OldAcitivityProvider>(
        context,
        listen: false,
      );
      final count = await activityProvider.getActivityCount(
        resId: widget.resId,
        resModel: widget.resModel,
      );
      if (mounted) {
        setState(() {
          _activityCount = count;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    if (_activityCount == null || (_activityCount!['total'] ?? 0) == 0) {
      return const SizedBox.shrink();
    }
    final total = _activityCount!['total'] ?? 0;
    final overdue = _activityCount!['overdue'] ?? 0;
    final today = _activityCount!['today'] ?? 0;

    Color textColor = Colors.grey[600]!;
    if (overdue > 0) {
      textColor = Colors.red;
    } else if (today > 0) {
      textColor = Colors.orange;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showIcon) ...[
          HugeIcon(
            icon: HugeIcons.strokeRoundedCalendar03,
            size: 14,
            color: textColor,
          ),
          const SizedBox(width: 4),
        ],
        Text(
          total.toString(),
          style:
              widget.textStyle?.copyWith(color: textColor) ??
              TextStyle(
                fontSize: 12,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
