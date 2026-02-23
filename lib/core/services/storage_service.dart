import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class StorageService {
  static const _accountsKey = 'loggedInAccounts';

  /// Persists a core Odoo session object to shared preferences.
  Future<void> saveSession(OdooSession session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sessionId', session.id);
    await prefs.setInt('userId', session.userId);
    await prefs.setInt('partnerId', session.partnerId);
    await prefs.setString('userLogin', session.userLogin);
    await prefs.setString('userName', session.userName);
    await prefs.setString('userLang', session.userLang);
    await prefs.setString('userTz', session.userTz);
    await prefs.setBool('isSystem', session.isSystem);
    await prefs.setString('dbName', session.dbName);
    await prefs.setString('serverVersion', session.serverVersion);
    await prefs.setInt('companyId', session.companyId);
  }

  /// Saves basic login state and credentials to shared preferences.
  Future<void> saveLoginState({
    required bool isLoggedIn,
    required String database,
    required String url,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
    await prefs.setString('database', database);
    await prefs.setString('serverUrl', url);
    await prefs.setString('password', password);
  }

  /// Retrieves the persisted login status and credentials.
  Future<Map<String, dynamic>> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'isLoggedIn': prefs.getBool('isLoggedIn') ?? false,
      'database': prefs.getString('database') ?? '',
      'serverUrl': prefs.getString('serverUrl') ?? '',
      'password': prefs.getString('password') ?? '',
    };
  }

  /// Adds or updates an account in the stored accounts list.
  Future<void> saveAccount(Map<String, dynamic> account) async {
    final prefs = await SharedPreferences.getInstance();
    final accounts = await getAccounts();

    accounts.removeWhere((a) =>
        a['userId']?.toString() == account['userId']?.toString() &&
        a['serverUrl'] == account['serverUrl'] &&
        a['database'] == account['database']);

    accounts.add(account);

    await prefs.setString(_accountsKey, jsonEncode(accounts));
  }

  /// Persists the entire list of accounts to shared preferences.
  Future<void> saveAccounts(List<Map<String, dynamic>> accounts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accountsKey, jsonEncode(accounts));
  }

  /// Retrieves the list of all stored accounts.
  Future<List<Map<String, dynamic>>> getAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final accountsJson = prefs.getString(_accountsKey);
    if (accountsJson == null) return [];
    try {
      final decoded = jsonDecode(accountsJson) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  /// Removes a specific account from the stored list.
  Future<void> removeAccount(String userId, String serverUrl, String database) async {
    final prefs = await SharedPreferences.getInstance();
    final accounts = await getAccounts();

    accounts.removeWhere((a) =>
        a['userId']?.toString() == userId &&
        a['serverUrl'] == serverUrl &&
        a['database'] == database);

    await prefs.setString(_accountsKey, jsonEncode(accounts));
  }

  /// Clears the list of stored accounts from shared preferences.
  Future<void> clearAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accountsKey);
  }
}
