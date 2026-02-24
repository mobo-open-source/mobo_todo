import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/profile/providers/profile_provider.dart';
import '../../features/dashboard screen/provider/dash_board_provider.dart';
import '../../features/task screen/provider/task_provider.dart';
import '../providers/home_tab_provider.dart';
import '../../features/addTask screen/provider/add_task_provider.dart';
import '../../features/addTask screen/provider/tag_provider.dart';
import '../../features/activity screen/provider/activity_provider.dart';

/// Resets all major app providers to their initial state.
/// This should be called when switching accounts to prevent data leakage.
void resetAllAppProviders(BuildContext context) {
  try {
    // Reset Profile & User Data
    context.read<ProfileProvider>().resetState();
    
    // Reset Dashboard Data
    context.read<DashBoardProvider>().clearProvider();
    
    // Reset Task Data
    context.read<TaskProvider>().clearProvider();
    
    // Reset Add Task Data
    context.read<AddTaskProvider>().clearProvider();
    
    // Reset Tag Data
    context.read<TagProvider>().clearProvider();
    
    // Reset Activity Data
    context.read<ActivityProvider>().clearProvider();
    
    // Reset Home Tab Navigation
    context.read<HomeTabProvider>().reset();
    
  } catch (e) {
  }
}
