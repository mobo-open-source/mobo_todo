import 'package:flutter/material.dart';

import 'package:mobo_todo/core/providers/logout_view_model.dart';
import 'package:mobo_todo/core/services/session_service.dart';
import 'package:mobo_todo/core/theme/theme_provider.dart';
import 'package:mobo_todo/features/company/providers/company_provider.dart';
import 'package:mobo_todo/features/login/pages/credentials_screen.dart';

import 'package:mobo_todo/features/profile/providers/profile_provider.dart';
import 'package:mobo_todo/features/settings/providers/settings_provider.dart';
import 'package:mobo_todo/core/theme/app_theme.dart';
import 'package:mobo_todo/features/onboarding/splashscreen.dart';
import 'package:mobo_todo/features/activity%20screen/provider/activity_provider.dart';
import 'package:mobo_todo/features/activity%20screen/provider/old_acitivity_provider.dart';
import 'package:mobo_todo/features/addTask%20screen/provider/personal_stage_provider.dart';
import 'package:mobo_todo/features/dashboard%20screen/provider/dash_board_provider.dart';
import 'package:mobo_todo/features/addTask%20screen/provider/tag_provider.dart';
import 'package:mobo_todo/features/addTask%20screen/provider/add_task_provider.dart';
import 'package:mobo_todo/features/task%20screen/provider/task_details_provider.dart';
import 'package:mobo_todo/features/task%20screen/provider/task_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        ChangeNotifierProvider(create: (context) => DashBoardProvider()),
        ChangeNotifierProvider(create: (context) => TaskProvider()),
        ChangeNotifierProvider(create: (context) => TagProvider()),
        ChangeNotifierProvider(create: (context) => AddTaskProvider()),
        ChangeNotifierProvider(create: (context) => TaskDetailsProvider()),
        ChangeNotifierProvider(create: (context) => PersonalStageProvider()),
        ChangeNotifierProvider(create: (context) => ActivityProvider()),
        ChangeNotifierProvider(create: (context) => OldAcitivityProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => LogoutViewModel()),
        ChangeNotifierProvider<SessionService>.value(
          value: SessionService.instance,
        ),
        // Provide CompanyProvider globally and initialize companies on app start
        ChangeNotifierProvider(
          create: (_) {
            final p = CompanyProvider();
            // Kick off initial load from server; will show loading in selector
            p.initialize();
            return p;
          },
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mobo todo App',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: provider.themeMode,
          // },
          // Entry decides between login flow and home based on saved session
          home: SplashScreen(),

          /// splash screen
          onGenerateRoute: (settings) {
            if (settings.name == '/login') {
              final args = settings.arguments as Map<String, dynamic>?;
              return MaterialPageRoute(
                builder: (_) => CredentialsScreen(
                  url: (args?['url'] ?? '') as String,
                  database: (args?['database'] ?? '') as String,
                ),
              );
            }
            return null;
          },
        );
      },
    );
    // MaterialApp(
    //   themeMode: ThemeMode.system,
    //   darkTheme: AppTheme.darkTheme,
    //   theme: AppTheme.lightTheme,
    //   debugShowCheckedModeBanner: false,
  }
}
