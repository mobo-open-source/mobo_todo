// Widget-level smoke test for the MoboTodo app.
// The default Flutter counter test has been replaced because this app
// uses a multi-provider setup and does not have a counter widget.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobo_todo/features/login/providers/login_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App renders a MaterialApp without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => LoginProvider(),
        child: const MaterialApp(
          home: Scaffold(
            body: Center(child: Text('MoboTodo')),
          ),
        ),
      ),
    );

    expect(find.text('MoboTodo'), findsOneWidget);
  });

  testWidgets('LoginProvider togglePasswordVisibility works in widget tree', (WidgetTester tester) async {
    final provider = LoginProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(
          home: Scaffold(
            body: Consumer<LoginProvider>(
              builder: (ctx, p, _) => Text(p.obscurePassword ? 'hidden' : 'visible'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('hidden'), findsOneWidget);

    provider.togglePasswordVisibility();
    await tester.pump();

    expect(find.text('visible'), findsOneWidget);

    provider.dispose();
  });
}
