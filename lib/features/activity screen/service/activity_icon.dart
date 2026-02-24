import 'package:flutter/material.dart';
import 'package:mobo_todo/features/activity%20screen/provider/activity_provider.dart';

import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';

class ActivityIcon extends StatelessWidget {
  final String? activityType;
  final String? activityState;
  final bool filled;
  final bool isLabel; 
  final double radius;
  final double size;

  const ActivityIcon({
    super.key,
    this.activityType,
    this.activityState,
    this.filled = false,
    this.isLabel = false, 
    this.size = 17,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.access_time; // Default icon
    
    // Make activity type comparison case-insensitive and more flexible
    final activityTypeLower = activityType?.toLowerCase() ?? '';
    
    if (activityTypeLower.contains('email') || activityTypeLower.contains('mail')) {
      icon = Icons.email_outlined;
    } else if (activityTypeLower.contains('call') || activityTypeLower.contains('phone')) {
      icon = Icons.phone_outlined;
    } else if (activityTypeLower.contains('meeting') || activityTypeLower.contains('appointment')) {
      icon = Icons.event_outlined;
    } else if (activityTypeLower.contains('to-do') || activityTypeLower.contains('todo') || activityTypeLower.contains('task')) {
      icon = Icons.check_outlined;
    } else if (activityTypeLower.contains('upload') || activityTypeLower.contains('document')) {
      icon = Icons.upload_file_outlined;
    } else if (activityTypeLower.contains('exception') || activityTypeLower.contains('error')) {
      icon = Icons.warning_outlined;
    } else if (activityTypeLower.contains('follow') || activityTypeLower.contains('quote')) {
      icon = Icons.refresh_outlined;
    } else if (activityTypeLower.contains('demo')) {
      icon = Icons.video_call_outlined;
    } else if (activityTypeLower.contains('upsell') || activityTypeLower.contains('order')) {
      icon = Icons.bar_chart_outlined;
    } else {
      // Fallback to exact string matching for backward compatibility
      switch (activityType) {
        case 'Email':
          icon = Icons.email_outlined;
          break;
        case 'Call':
          icon = Icons.phone_outlined;
          break;
        case 'Meeting':
          icon = Icons.event_outlined;
          break;
        case 'To-Do':
          icon = Icons.check_outlined;
          break;
        case 'Upload Document':
          icon = Icons.upload_file_outlined;
          break;
        case 'Exception':
          icon = Icons.warning_outlined;
          break;
        case 'Follow-up Quote':
          icon = Icons.refresh_outlined;
          break;
        case 'Make Quote':
          icon = Icons.description_outlined;
          break;
        case 'Call for Demo':
          icon = Icons.video_call_outlined;
          break;
        case 'Email: Welcome Demo':
          icon = Icons.celebration_outlined;
          break;
        case 'Order Upsell':
          icon = Icons.bar_chart_outlined;
          break;
      }
    }

    Color color = Colors.grey;
    String stateText = '';
    if (activityState == 'planned' || activityState == 'tomorrow') {
      color = Colors.green;
      stateText = 'Planned';
    } else if (activityState == 'overdue') {
      color = Colors.red;
      stateText = 'Overdue';
    } else if (activityState == 'today') {
      color = Colors.orange;
      stateText = 'Today';
    }

    if (!isLabel) {
      return activityType != null
          ? CircleAvatar(
              radius: radius,
              backgroundColor: filled ? color : color.withOpacity(0.2),
              child:
                  Icon(icon, color: filled ? Colors.white : color, size: size),
            )
          : const Icon(Icons.access_time, color: Colors.grey, size: 20);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: size, color: color),
          const SizedBox(width: 6),
          Text(
            stateText,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityIconBadge extends StatelessWidget {
  final OdooClient client;

  const ActivityIconBadge({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityProvider>(
      builder: (context, mailProvider, child) {
        final activityCount = 10;

        return InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: Image.asset("assets/access_time.png"),
              ),
              if (activityCount > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints:  BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      activityCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}