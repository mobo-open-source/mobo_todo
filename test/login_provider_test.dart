import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobo_todo/features/login/providers/login_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginProvider', () {
    late LoginProvider provider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      provider = LoginProvider();
    });

    tearDown(() {
      provider.dispose();
    });

    // ─── Initial State ───────────────────────────────────────────────────────

    group('Initial State', () {
      test('should have empty URL controller on init', () {
        expect(provider.urlController.text, isEmpty);
      });

      test('should have empty email controller on init', () {
        expect(provider.emailController.text, isEmpty);
      });

      test('should have empty password controller on init', () {
        expect(provider.passwordController.text, isEmpty);
      });

      test('should default to https:// protocol', () {
        expect(provider.selectedProtocol, 'https://');
      });

      test('should not be loading on init', () {
        expect(provider.isLoading, isFalse);
      });

      test('should not be loading databases on init', () {
        expect(provider.isLoadingDatabases, isFalse);
      });

      test('should have no error message on init', () {
        expect(provider.errorMessage, isNull);
      });

      test('should have empty dropdown items on init', () {
        expect(provider.dropdownItems, isEmpty);
      });

      test('should obscure password by default', () {
        expect(provider.obscurePassword, isTrue);
      });

      test('should have no database selected on init', () {
        expect(provider.database, isNull);
      });
    });

    // ─── togglePasswordVisibility ────────────────────────────────────────────

    group('togglePasswordVisibility', () {
      test('should toggle obscurePassword from true to false', () {
        expect(provider.obscurePassword, isTrue);
        provider.togglePasswordVisibility();
        expect(provider.obscurePassword, isFalse);
      });

      test('should toggle obscurePassword from false to true', () {
        provider.togglePasswordVisibility(); // now false
        provider.togglePasswordVisibility(); // back to true
        expect(provider.obscurePassword, isTrue);
      });

      test('should notify listeners when toggled', () {
        bool notified = false;
        provider.addListener(() => notified = true);
        provider.togglePasswordVisibility();
        expect(notified, isTrue);
      });
    });

    // ─── setProtocol ─────────────────────────────────────────────────────────

    group('setProtocol', () {
      test('should set protocol to http://', () {
        provider.setProtocol('http://');
        expect(provider.selectedProtocol, 'http://');
      });

      test('should set protocol to https://', () {
        provider.setProtocol('http://');
        provider.setProtocol('https://');
        expect(provider.selectedProtocol, 'https://');
      });
    });

    // ─── extractProtocol ─────────────────────────────────────────────────────

    group('extractProtocol', () {
      test('should return https:// for https URL', () {
        expect(provider.extractProtocol('https://example.com'), 'https://');
      });

      test('should return http:// for http URL', () {
        expect(provider.extractProtocol('http://example.com'), 'http://');
      });

      test('should return selected protocol for URL without protocol', () {
        provider.setProtocol('https://');
        expect(provider.extractProtocol('example.com'), 'https://');
      });
    });

    // ─── extractDomain ───────────────────────────────────────────────────────

    group('extractDomain', () {
      test('should strip https:// from URL', () {
        expect(provider.extractDomain('https://example.com'), 'example.com');
      });

      test('should strip http:// from URL', () {
        expect(provider.extractDomain('http://example.com'), 'example.com');
      });

      test('should return URL as-is if no protocol prefix', () {
        expect(provider.extractDomain('example.com'), 'example.com');
      });
    });

    // ─── setUrlFromFullUrl ────────────────────────────────────────────────────

    group('setUrlFromFullUrl', () {
      test('should set protocol and domain from https URL', () {
        provider.setUrlFromFullUrl('https://odoo.example.com');
        expect(provider.selectedProtocol, 'https://');
        expect(provider.urlController.text, 'odoo.example.com');
      });

      test('should set protocol and domain from http URL', () {
        provider.setUrlFromFullUrl('http://odoo.example.com');
        expect(provider.selectedProtocol, 'http://');
        expect(provider.urlController.text, 'odoo.example.com');
      });
    });

    // ─── getFullUrl ───────────────────────────────────────────────────────────

    group('getFullUrl', () {
      test('should return empty string when URL controller is empty', () {
        expect(provider.getFullUrl(), '');
      });

      test('should prepend selected protocol when URL has no protocol', () {
        provider.urlController.text = 'example.com';
        provider.setProtocol('https://');
        expect(provider.getFullUrl(), 'https://example.com');
      });

      test('should return URL as-is when it already has https://', () {
        provider.urlController.text = 'https://example.com';
        expect(provider.getFullUrl(), 'https://example.com');
      });

      test('should return URL as-is when it already has http://', () {
        provider.urlController.text = 'http://example.com';
        expect(provider.getFullUrl(), 'http://example.com');
      });
    });

    // ─── isValidUrl ───────────────────────────────────────────────────────────

    group('isValidUrl', () {
      test('should return true for valid domain', () {
        expect(provider.isValidUrl('example.com'), isTrue);
      });

      test('should return true for https URL', () {
        expect(provider.isValidUrl('https://example.com'), isTrue);
      });

      test('should return true for http URL', () {
        expect(provider.isValidUrl('http://example.com'), isTrue);
      });

      test('should return false for empty string', () {
        expect(provider.isValidUrl(''), isFalse);
      });

      test('should return false for URL with only spaces', () {
        expect(provider.isValidUrl('   '), isFalse);
      });
    });

    // ─── clearForm ────────────────────────────────────────────────────────────

    group('clearForm', () {
      test('should clear all form fields and state', () {
        provider.urlController.text = 'example.com';
        provider.emailController.text = 'user@example.com';
        provider.passwordController.text = 'password';
        provider.database = 'mydb';
        provider.dropdownItems = ['db1', 'db2'];
        provider.urlCheck = true;
        provider.errorMessage = 'some error';
        provider.isLoading = true;

        provider.clearForm();

        expect(provider.urlController.text, isEmpty);
        expect(provider.emailController.text, isEmpty);
        expect(provider.passwordController.text, isEmpty);
        expect(provider.database, isNull);
        expect(provider.dropdownItems, isEmpty);
        expect(provider.urlCheck, isFalse);
        expect(provider.errorMessage, isNull);
        expect(provider.isLoading, isFalse);
      });

      test('should notify listeners after clearing', () {
        bool notified = false;
        provider.addListener(() => notified = true);
        provider.clearForm();
        expect(notified, isTrue);
      });
    });

    // ─── setDatabase ──────────────────────────────────────────────────────────

    group('setDatabase', () {
      test('should set database value', () {
        provider.setDatabase('mydb');
        expect(provider.database, 'mydb');
      });

      test('should set database to null', () {
        provider.setDatabase('mydb');
        provider.setDatabase(null);
        expect(provider.database, isNull);
      });
    });

    // ─── fetchDatabaseList validation ─────────────────────────────────────────

    group('fetchDatabaseList - validation', () {
      test('should set error when URL is empty', () async {
        provider.urlController.text = '';
        await provider.fetchDatabaseList();
        expect(provider.errorMessage, isNotNull);
        expect(provider.errorMessage, contains('server URL'));
      });

      test('should set error when URL is invalid', () async {
        provider.urlController.text = 'not a valid url';
        await provider.fetchDatabaseList();
        expect(provider.errorMessage, isNotNull);
      });
    });

    // ─── seedUrlToHistory ─────────────────────────────────────────────────────

    group('seedUrlToHistory', () {
      test('should not throw for a valid URL', () async {
        expect(
          () async => provider.seedUrlToHistory('https://example.com'),
          returnsNormally,
        );
      });
    });
  });
}
