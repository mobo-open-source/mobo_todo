import 'package:flutter_test/flutter_test.dart';
import 'package:mobo_todo/features/profile/providers/profile_provider.dart';

void main() {
  group('ProfileProvider', () {
    late ProfileProvider provider;

    setUp(() {
      provider = ProfileProvider();
    });

    tearDown(() {
      provider.dispose();
    });

    // ─── Initial State ───────────────────────────────────────────────────────

    group('Initial State', () {
      test('should be loading initially (fetches on init)', () {
        expect(provider.isLoading, isTrue);
      });

      test('should have null user data', () {
        expect(provider.userData, isNull);
      });

      test('should have null error on init', () {
        expect(provider.error, isNull);
      });

      test('should have empty countries list', () {
        expect(provider.countries, isEmpty);
      });

      test('should have empty states list', () {
        expect(provider.states, isEmpty);
      });
    });

    // ─── normalizeForEdit ────────────────────────────────────────────────────

    group('normalizeForEdit', () {
      test('should return empty string for false', () {
        expect(provider.normalizeForEdit(false), '');
      });

      test('should return empty string for null', () {
        expect(provider.normalizeForEdit(null), '');
      });

      test('should return string as-is', () {
        expect(provider.normalizeForEdit('hello'), 'hello');
      });

      test('should convert int to string', () {
        expect(provider.normalizeForEdit(42), '42');
      });

      test('should return toString() of a list (Odoo many2one format)', () {
        final result = provider.normalizeForEdit([1, 'Company Name']);
        expect(result, isNotEmpty);
        expect(result, contains('Company Name'));
      });

      test('should return toString() of an empty list', () {
        final result = provider.normalizeForEdit([]);
        expect(result, isNotEmpty); // returns '[]'
      });
    });

    // ─── formatAddress ───────────────────────────────────────────────────────

    group('formatAddress', () {
      test('should format full address correctly', () {
        final data = {
          'street': '123 Main St',
          'city': 'Springfield',
          'zip': '12345',
          'country_id': [1, 'United States'],
        };
        final result = provider.formatAddress(data);
        expect(result, contains('123 Main St'));
        expect(result, contains('Springfield'));
        expect(result, contains('12345'));
        expect(result, contains('United States'));
      });

      test('should handle missing fields gracefully', () {
        final data = <String, dynamic>{};
        final result = provider.formatAddress(data);
        expect(result, isA<String>());
      });

      test('should handle false values from Odoo', () {
        final data = {
          'street': false,
          'city': 'Springfield',
          'zip': false,
          'country_id': false,
        };
        final result = provider.formatAddress(data);
        expect(result, contains('Springfield'));
      });
    });

    // ─── resetState ──────────────────────────────────────────────────────────

    group('resetState', () {
      test('should reset userData to null', () {
        provider.resetState();
        expect(provider.userData, isNull);
      });

      test('should reset error to null', () {
        provider.resetState();
        expect(provider.error, isNull);
      });

      test('should reset isLoading to true after resetState (triggers re-fetch)', () {
        provider.resetState();
        expect(provider.isLoading, isTrue);
      });

      test('should notify listeners', () {
        bool notified = false;
        provider.addListener(() => notified = true);
        provider.resetState();
        expect(notified, isTrue);
      });
    });

    // ─── clearStates ─────────────────────────────────────────────────────────

    group('clearStates', () {
      test('should clear states list', () {
        provider.clearStates();
        expect(provider.states, isEmpty);
      });
    });
  });
}
