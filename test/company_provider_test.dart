import 'package:flutter_test/flutter_test.dart';
import 'package:mobo_todo/features/company/providers/company_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CompanyProvider', () {
    late CompanyProvider provider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      provider = CompanyProvider();
    });

    // ─── Initial State ───────────────────────────────────────────────────────

    group('Initial State', () {
      test('should have empty companies list', () {
        expect(provider.companies, isEmpty);
      });

      test('should have null selectedCompanyId', () {
        expect(provider.selectedCompanyId, isNull);
      });

      test('should have empty selectedAllowedCompanyIds', () {
        expect(provider.selectedAllowedCompanyIds, isEmpty);
      });

      test('should not be loading', () {
        expect(provider.isLoading, isFalse);
      });

      test('should not be switching', () {
        expect(provider.isSwitching, isFalse);
      });

      test('should have no error', () {
        expect(provider.error, isNull);
      });

      test('selectedCompany should be null when no companies', () {
        expect(provider.selectedCompany, isNull);
      });
    });

    // ─── isCompanyAllowed ────────────────────────────────────────────────────

    group('isCompanyAllowed', () {
      test('should return false when company is not in allowed list', () {
        expect(provider.isCompanyAllowed(1), isFalse);
      });

      test('should return false for any company when list is empty', () {
        expect(provider.isCompanyAllowed(99), isFalse);
      });
    });

    // ─── toggleAllowedCompany ────────────────────────────────────────────────

    group('toggleAllowedCompany', () {
      test('should add company to allowed list when not present', () async {
        await provider.toggleAllowedCompany(99);
        expect(provider.selectedAllowedCompanyIds, contains(99));
      });

      test('should remove company from allowed list when already present', () async {
        await provider.toggleAllowedCompany(99); // add
        await provider.toggleAllowedCompany(99); // remove
        expect(provider.selectedAllowedCompanyIds, isNot(contains(99)));
      });

      test('should notify listeners when toggling', () async {
        bool notified = false;
        provider.addListener(() => notified = true);
        await provider.toggleAllowedCompany(99);
        expect(notified, isTrue);
      });
    });

    // ─── setAllowedCompanies ─────────────────────────────────────────────────

    group('setAllowedCompanies', () {
      test('should not throw for an empty list', () async {
        expect(() async => provider.setAllowedCompanies([]), returnsNormally);
      });
    });

    // ─── selectedCompany getter ──────────────────────────────────────────────

    group('selectedCompany getter', () {
      test('should return null when selectedCompanyId is null', () {
        expect(provider.selectedCompany, isNull);
      });
    });
  });
}
