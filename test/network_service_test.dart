import 'package:flutter_test/flutter_test.dart';
import 'package:mobo_todo/core/services/network_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('NetworkService', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    // ─── isSslBypassEnabled ──────────────────────────────────────────────────

    group('isSslBypassEnabled', () {
      test('should return false by default', () async {
        final result = await NetworkService.isSslBypassEnabled();
        expect(result, isFalse);
      });

      test('should return true after enabling', () async {
        await NetworkService.setSslBypassEnabled(true);
        final result = await NetworkService.isSslBypassEnabled();
        expect(result, isTrue);
      });

      test('should return false after disabling', () async {
        await NetworkService.setSslBypassEnabled(true);
        await NetworkService.setSslBypassEnabled(false);
        final result = await NetworkService.isSslBypassEnabled();
        expect(result, isFalse);
      });
    });

    // ─── setSslBypassEnabled ─────────────────────────────────────────────────

    group('setSslBypassEnabled', () {
      test('should persist the enabled state', () async {
        await NetworkService.setSslBypassEnabled(true);
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('ssl_bypass_enabled'), isTrue);
      });

      test('should persist the disabled state', () async {
        await NetworkService.setSslBypassEnabled(false);
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('ssl_bypass_enabled'), isFalse);
      });
    });

    // ─── getClient ───────────────────────────────────────────────────────────

    group('getClient', () {
      test('should return a non-null client', () async {
        final client = await NetworkService.getClient();
        expect(client, isNotNull);
      });

      test('should return a client when SSL bypass is disabled', () async {
        await NetworkService.setSslBypassEnabled(false);
        final client = await NetworkService.getClient();
        expect(client, isNotNull);
      });

      test('should return a client when SSL bypass is enabled', () async {
        await NetworkService.setSslBypassEnabled(true);
        final client = await NetworkService.getClient();
        expect(client, isNotNull);
      });
    });
  });
}
