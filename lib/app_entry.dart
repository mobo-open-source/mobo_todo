


//   @override

//   @override

//     // Start monitoring connectivity centrally

//     // Validate session if logged in

//         // Extra safeguard: ensure we can actually authenticate a client.
//         // If this fails due to temporary connectivity or server issues, DO NOT logout.
//         // Let the app proceed so the user can retry inside the app.
//           final sessionInfo = await client.callRPC(
//             '/web/session/get_session_info',
//             'call',
//             {},
//           // company_id is usually in: sessionInfo['user_companies']['current_company']


//           // Intentionally do not clear session here.
//     bool inventoryInstalled = true; // Force true for now
//           'model': 'ir.module.module',
//           'method': 'search_count',
//           'args': [
//             [
//               ['name', '=', 'project_todo'],
//               ['state', '=', 'installed'],
//             ],
//           ],
//           'kwargs': {},

//         // Keep as false; the MissingInventoryScreen will allow retry
//       'isLoggedIn': isLoggedIn && sessionValid,
//       'biometricEnabled': biometricEnabled,
//       'inventoryInstalled': inventoryInstalled,
//   @override
//     return FutureBuilder<Map<String, dynamic>>(
//       future: _initFuture,



//         // Check if biometric should be skipped
//         final shouldSkipBiometric =

//         // Show biometric lock screen if enabled and logged in
//           return AppLockScreen(
//               // so that startup checks (including inventory module check)
//               // can run and route either to HomeScaffold or MissingInventoryScreen.
//               Navigator.pushReplacement(
//                 context,
//             },
//           // If logged in but inventory not installed, show guidance screen
//           /*
//             return MissingInventoryScreen(
//               },
//           */
//           // No biometric, go directly to app

//         // Not logged in, show login screen
//       },

import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:mobo_todo/core/widget/bottom_navigation_bar.dart';
import 'package:mobo_todo/core/widget/module_missing_dailoque.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared/widgets/loaders/loading_indicator.dart';
import 'features/login/pages/server_setup_screen.dart';
import 'features/login/pages/app_lock_screen.dart';
import 'core/services/session_service.dart';
import 'core/services/odoo_session_manager.dart';
import 'core/services/biometric_context_service.dart';
import 'core/routing/page_transition.dart';
import 'core/services/connectivity_service.dart';

class AppEntry extends StatefulWidget {
  final bool skipBiometric;

  const AppEntry({super.key, this.skipBiometric = false});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  late Future<Map<String, dynamic>> _initFuture;
  bool _handledMissingModule = false;

  @override
  void initState() {
    super.initState();
    ConnectivityService.instance.startMonitoring();
    _initFuture = _checkAuthStatus();
  }

  Future<Map<String, dynamic>> _checkAuthStatus() async {
    await SessionService.instance.initialize();

    final prefs = await SharedPreferences.getInstance();
    final session = SessionService.instance.currentSession;

    final isLoggedIn = session != null;
    final biometricEnabled = prefs.getBool('biometric_enabled') ?? false;
    bool sessionValid = false;

    if (isLoggedIn) {
      sessionValid = await OdooSessionManager.isSessionValid();
    }

    bool todoInstalled = false;

    if (isLoggedIn && sessionValid) {
      try {
        final client = await OdooSessionManager.getClientEnsured();
        final count = await client.callKw({
          'model': 'ir.module.module',
          'method': 'search_count',
          'args': [
            [
              ['name', '=', 'project_todo'],
              ['state', '=', 'installed'],
            ],
          ],
          'kwargs': {},
        });

        todoInstalled = count is int && count > 0;
      } catch (e) {

      }
    }

    return {
      'isLoggedIn': isLoggedIn && sessionValid,
      'biometricEnabled': biometricEnabled,
      'todoInstalled': todoInstalled,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: LoadingIndicator()));
        }

        if (!snapshot.hasData) {
          return const ServerSetupScreen();
        }

        final isLoggedIn = snapshot.data!['isLoggedIn'] as bool;
        final biometricEnabled = snapshot.data!['biometricEnabled'] as bool;
        final todoInstalled = snapshot.data!['todoInstalled'] as bool? ?? false;

        final biometricContext = BiometricContextService();
        final shouldSkipBiometric =
            widget.skipBiometric || biometricContext.shouldSkipBiometric;

        if (biometricEnabled && isLoggedIn && !shouldSkipBiometric) {
          return AppLockScreen(
            onAuthenticationSuccess: () {
              Navigator.pushReplacement(
                context,
                dynamicRoute(context, const AppEntry(skipBiometric: true)),
              );
            },
          );
        }
        if (isLoggedIn && !todoInstalled && !_handledMissingModule) {
          _handledMissingModule = true;

          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (!mounted) return;
            await OdooSessionManager.logout();
            if (!mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const ServerSetupScreen()),
              (_) => false,
            );
            showModuleMissingDialog(context);
          });
        }
        if (isLoggedIn) {
          return BottomNavig();
        }
        return const ServerSetupScreen();
      },
    );
  }
}
