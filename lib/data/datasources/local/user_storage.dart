import 'package:shared_preferences/shared_preferences.dart';
import '../../model/user_model.dart';


class UserStorage {
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _passwordKey = 'user_password'; // For demo only

  static UserStorage? _instance;
  static UserStorage get instance => _instance ??= UserStorage._();
  UserStorage._();

  // Save user data after signup/login
  Future<void> saveUser(UserModel user, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save user data
      await prefs.setString(_userKey, user.toJsonString());
      await prefs.setString(_passwordKey, password); // Demo only - encrypt in real app
      await prefs.setBool(_isLoggedInKey, true);

      print('User saved successfully: ${user.name}');
    } catch (e) {
      print('Error saving user: $e');
      throw Exception('Failed to save user data');
    }
  }

  // Get current logged-in user
  Future<UserModel?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

      if (!isLoggedIn) {
        return null;
      }

      final userJsonString = prefs.getString(_userKey);
      if (userJsonString == null) {
        return null;
      }

      return UserModel.fromJsonString(userJsonString);
    } catch (e) {
      print('Error loading user: $e');
      return null;
    }
  }

  // Verify user credentials for login
  Future<UserModel?> verifyCredentials(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJsonString = prefs.getString(_userKey);
      final storedPassword = prefs.getString(_passwordKey);

      if (userJsonString == null || storedPassword == null) {
        return null; // No user registered
      }

      final user = UserModel.fromJsonString(userJsonString);

      // Verify email and password
      if (user.email.toLowerCase() == email.toLowerCase() &&
          storedPassword == password) {

        // Update login status
        await prefs.setBool(_isLoggedInKey, true);
        return user;
      }

      return null; // Invalid credentials
    } catch (e) {
      print('Error verifying credentials: $e');
      return null;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  // Update user profile
  Future<void> updateUser(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, user.toJsonString());
      print('User updated successfully: ${user.name}');
    } catch (e) {
      print('Error updating user: $e');
      throw Exception('Failed to update user data');
    }
  }

  // Clear all user data on logout
  Future<void> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_passwordKey);
      await prefs.setBool(_isLoggedInKey, false);
      print('User data cleared successfully');
    } catch (e) {
      print('Error clearing user data: $e');
      throw Exception('Failed to clear user data');
    }
  }

  // Check if user exists (for signup validation)
  Future<bool> userExists(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJsonString = prefs.getString(_userKey);

      if (userJsonString == null) {
        return false;
      }

      final user = UserModel.fromJsonString(userJsonString);
      return user.email.toLowerCase() == email.toLowerCase();
    } catch (e) {
      print('Error checking if user exists: $e');
      return false;
    }
  }
}
