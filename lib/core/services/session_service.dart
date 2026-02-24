import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/appsession.dart';
import 'odoo_session_manager.dart';
import 'secure_storage_service.dart';

/// Service that manages the application session state, account storage, and authentication lifecycle.
///
/// This service acts as a central hub for session management, coordinating between
/// [OdooSessionManager] for backend interaction and local storage for account persistence.
class SessionService extends ChangeNotifier {
  static final SessionService instance = SessionService._internal();
  factory SessionService() => instance;
  SessionService._internal();

  AppSessionData? _currentSession;
  bool _isInitialized = false;
  List<Map<String, dynamic>> _storedAccounts = [];

  AppSessionData? get currentSession => _currentSession;
  bool get isInitialized => _isInitialized;
  bool get hasValidSession => _currentSession != null;
  List<Map<String, dynamic>> get storedAccounts => _storedAccounts;

  /// Initializes the [SessionService].
  ///
  /// This sets up global session callbacks, loads the current session from persistent storage,
  /// retrieves the list of stored accounts, performing necessary password migrations,
  /// and ensures the current session is registered in the account list.
  Future<void> initialize() async {

    if (_isInitialized) {

      return;
    }

    // Set up session callbacks
    OdooSessionManager.setSessionCallbacks(
      onSessionUpdated: (sessionModel) {

        updateSession(sessionModel);
      },
      onSessionCleared: () {

        clearSession();
      },
    );

    // Load current session
    _currentSession = await OdooSessionManager.getCurrentSession();

    // Load stored accounts
    await _loadStoredAccounts();

    // Migrate passwords from SharedPreferences to secure storage
    await _migratePasswordsToSecureStorage();

    // Auto-store current session if not already stored
    if (_currentSession != null) {
      await _autoStoreCurrentSession();
    }

    _isInitialized = true;


    notifyListeners();
  }

  /// Updates the current session state and notifies listeners.
  void updateSession(AppSessionData newSession) {

    _currentSession = newSession;
    notifyListeners();
  }

  /// Clears the current session from memory and notifies listeners.
  void clearSession() {

    _currentSession = null;
    notifyListeners();
  }

  /// Performs a full logout.
  ///
  /// This clears the session on the Odoo server, wipes stored account metadata,
  /// removes all cached passwords, and resets the local service state.
  Future<void> logout() async {

    try {
      // Clear the session on the backend
      await OdooSessionManager.logout();

      // Clear stored accounts for privacy
      await _clearStoredAccountsData();

      // Clear password caches
      await _clearPasswordCaches();

      // Clear session service state
      clearSession();
    } catch (e, stackTrace) {


    }
  }

  // Account management methods

  /// Loads the list of accounts previously saved to [SharedPreferences].
  Future<void> _loadStoredAccounts() async {

    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> storedAccountsJson =
          prefs.getStringList('stored_accounts') ?? [];

      _storedAccounts = storedAccountsJson
          .map((json) {
            try {
              final decoded = Map<String, dynamic>.from(jsonDecode(json));

              return decoded;
            } catch (e) {

              return null;
            }
          })
          .where((account) => account != null)
          .cast<Map<String, dynamic>>()
          .toList();

      // Clean up any duplicate accounts
      await _cleanupDuplicateAccounts();

      notifyListeners();
    } catch (e) {

      _storedAccounts = [];
    }
  }

  /// Ensures the active session is present in the persistent account list.
  Future<void> _autoStoreCurrentSession() async {
    if (_currentSession == null) return;

    // Check if current session is already stored
    final currentExists = _storedAccounts.any(
      (account) =>
          account['userId'] == _currentSession!.userId.toString() &&
          account['serverUrl'] == _currentSession!.serverUrl &&
          account['database'] == _currentSession!.database,
    );

    if (!currentExists) {

      await storeAccount(
        _currentSession!,
        '',
      ); // Store with empty password initially
    }
  }

  /// Removes duplicate account entries from the local storage list.
  Future<void> _cleanupDuplicateAccounts() async {

    final uniqueAccounts = <String, Map<String, dynamic>>{};

    for (final account in _storedAccounts) {
      final userId = account['userId']?.toString() ?? '';
      final serverUrl = account['serverUrl']?.toString() ?? '';
      final database = account['database']?.toString() ?? '';

      if (userId.isEmpty || serverUrl.isEmpty || database.isEmpty) {

        continue;
      }

      final key = '${userId}_${serverUrl}_$database';

      if (!uniqueAccounts.containsKey(key)) {
        uniqueAccounts[key] = account;
      } else {
        final existing = uniqueAccounts[key]!;
        final currentHasPassword =
            account['password']?.toString().isNotEmpty == true;
        final existingHasPassword =
            existing['password']?.toString().isNotEmpty == true;

        if (currentHasPassword && !existingHasPassword) {
          uniqueAccounts[key] = account;
        }
      }
    }

    final originalCount = _storedAccounts.length;
    _storedAccounts = uniqueAccounts.values.toList();

    if (_storedAccounts.length != originalCount) {

      await _saveStoredAccountsWithRetry();
    }
  }

  /// Saves an account's metadata and password for future sessions.
  ///
  /// Metadata such as user name and server URL are stored in [SharedPreferences],
  /// while the [password] is stored using [SecureStorageService].
  Future<void> storeAccount(
      AppSessionData session,
    String password, {
    bool markAsCurrent = true,
  }) async {


    try {
      String? imageBase64;
      String userDisplayName = session.userLogin;

      // Try to fetch user details including image
      try {
        final client = await OdooSessionManager.getClient();

        if (client != null && session.userId != null) {
          final userDetails = await client.callKw({
            'model': 'res.users',
            'method': 'read',
            'args': [
              [session.userId],
              ['name', 'image_1920'],
            ],
            'kwargs': {}, // Add missing 'kwargs': {} here
          });

          if (userDetails is List && userDetails.isNotEmpty) {
            final user = userDetails.first as Map;
            final n = user['name'];
            if (n != null && n != false) {
              userDisplayName = n.toString();
            }
            final img = user['image_1920'];
            if (img != null && img != false) {
              imageBase64 = img.toString();
            }
          }
        }
      } catch (e) {

      }

      // Create account data (WITHOUT password - stored securely)
      final accountData = {
        'id': session.userId.toString(),
        'name': userDisplayName,
        'email': session.userLogin,
        'url': session.serverUrl.trim(),
        'database': session.database,
        'username': session.userLogin,
        'isCurrent': markAsCurrent,
        'lastLogin': DateTime.now().toIso8601String(),
        'imageBase64': imageBase64?.isNotEmpty == true ? imageBase64 : null,
        // Keep compatibility fields
        'userId': session.userId.toString(),
        'userName': userDisplayName,
        'serverUrl': session.serverUrl,
        // DON'T store password here - use secure storage
        'sessionId': session.sessionId,
      };

      // Mark all other accounts as not current only if this account is being marked as current
      if (markAsCurrent) {
        for (var account in _storedAccounts) {
          account['isCurrent'] = false;
        }
      }

      // Check if account already exists
      final existingIndex = _storedAccounts.indexWhere(
        (account) =>
            account['id'] == accountData['id'] &&
            account['url'] == accountData['url'] &&
            account['database'] == accountData['database'],
      );

      if (existingIndex != -1) {

        _storedAccounts[existingIndex] = accountData;
      } else {

        _storedAccounts.insert(0, accountData);
      }

      await _saveStoredAccountsWithRetry();

      // Store password with multiple patterns
      if (password.isNotEmpty) {
        await _storePasswordWithMultiplePatterns(session, password);
      }

      notifyListeners();
    } catch (e) {

      rethrow;
    }
  }

  /// Securely stores the [password] using multiple key patterns for robustness.
  Future<void> _storePasswordWithMultiplePatterns(
      AppSessionData session,
    String password,
  ) async {
    if (password.isEmpty) return;

    try {
      final secureStorage = SecureStorageService.instance;

      // Store password with multiple patterns for reliable retrieval
      await secureStorage.storePassword(
        'password_${session.userId}_${session.database}',
        password,
      );
      await secureStorage.storePassword(
        'password_${session.userLogin}_${session.database}',
        password,
      );

    } catch (e) {

    }
  }

  /// Attempts to retrieve a password from secure storage using various key patterns.
  Future<String?> retrievePasswordWithMultiplePatterns(
    Map<String, dynamic> accountData,
  ) async {
    try {
      final secureStorage = SecureStorageService.instance;
      final userId = accountData['id'] ?? accountData['userId'];
      final username = accountData['username'] ?? accountData['email'];
      final database = accountData['database'];

      // Try multiple password patterns in secure storage
      List<String> passwordKeys = [
        'password_${userId}_$database',
        'password_${username}_$database',
      ];

      // Try each password key pattern
      for (String key in passwordKeys) {
        final password = await secureStorage.getPassword(key);
        if (password != null && password.isNotEmpty) {

          return password;
        }
      }

      return null;
    } catch (e) {

      return null;
    }
  }

  /// Persists the [_storedAccounts] list to local storage with exponential backoff retry.
  Future<void> _saveStoredAccountsWithRetry() async {
    int maxRetries = 3;
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {

        final prefs = await SharedPreferences.getInstance();

        // JSON encode accounts
        final updatedAccountsJson = _storedAccounts
            .map((account) => jsonEncode(account))
            .toList();

        await prefs.setStringList('stored_accounts', updatedAccountsJson);

        return; // Success
      } catch (e) {

        if (attempt == maxRetries) {

        } else {
          await Future.delayed(Duration(milliseconds: 100 * attempt));
        }
      }
    }
  }

  /// Removes an account and its metadata from the stored account list.
  Future<void> removeStoredAccount(int accountIndex) async {
    if (accountIndex < 0 || accountIndex >= _storedAccounts.length) {

      return;
    }

    final accountData = _storedAccounts[accountIndex];

    _storedAccounts.removeAt(accountIndex);
    await _saveStoredAccountsWithRetry();
    notifyListeners();
  }

  /// Direct update of both memory state and global Odoo session manager.
  Future<bool> updateSessionDirectly(AppSessionData newSession) async {

    try {
      // Update the current session
      _currentSession = newSession;

      // Update OdooSessionManager
      await OdooSessionManager.updateSession(newSession);

      // Notify listeners
      notifyListeners();

      return true;
    } catch (e) {

      return false;
    }
  }

  /// Convenience method to switch the active session to a different account.
  Future<bool> switchToAccount(AppSessionData newSession) async {
    return await updateSessionDirectly(newSession);
  }

  // Legacy method for compatibility with login provider
  /// Compatibility method for updating credentials of the current active session.
  Future<void> updateAccountCredentials(
    String username,
    String password,
  ) async {
    if (_currentSession != null) {
      await _storePasswordWithMultiplePatterns(_currentSession!, password);
    }
  }

  /// Permanently removes account list metadata from storage.
  Future<void> _clearStoredAccountsData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('stored_accounts');
      _storedAccounts = [];

    } catch (e) {

    }
  }

  /// Wipes all stored passwords from the device's secure storage.
  Future<void> _clearPasswordCaches() async {
    try {
      // Clear all passwords from secure storage
      await SecureStorageService.instance.clearAll();

    } catch (e) {

    }
  }

  /// Migrate passwords from SharedPreferences to secure storage
  Future<void> _migratePasswordsToSecureStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if migration already done
      if (prefs.getBool('passwords_migrated') == true) {

        return;
      }

      final secureStorage = SecureStorageService.instance;
      int migratedCount = 0;

      // Migrate all password keys from SharedPreferences
      final allKeys = prefs.getKeys();
      for (final key in allKeys) {
        if (key.startsWith('password_')) {
          final password = prefs.getString(key);
          if (password != null && password.isNotEmpty) {
            await secureStorage.storePassword(key, password);
            await prefs.remove(key);
            migratedCount++;
          }
        }
      }

      // Mark migration as complete
      await prefs.setBool('passwords_migrated', true);

    } catch (e) {

    }
  }
}
