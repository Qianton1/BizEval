import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _phoneNumber = '';

  bool get isLoggedIn => _isLoggedIn;
  String get phoneNumber => _phoneNumber;

  AuthProvider() {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      _phoneNumber = prefs.getString('phoneNumber') ?? '';
      notifyListeners();
    } catch (e) {
      // 处理可能的错误
      print('Error loading auth state: $e');
    }
  }

  Future<void> _saveAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', _isLoggedIn);
      await prefs.setString('phoneNumber', _phoneNumber);
    } catch (e) {
      // 处理可能的错误
      print('Error saving auth state: $e');
    }
  }

  Future<bool> login(String phoneNumber, String otp) async {
    // 简化版登录逻辑，任何 6 位数字都视为有效
    if (otp.length == 6 && int.tryParse(otp) != null) {
      _isLoggedIn = true;
      _phoneNumber = phoneNumber;
      await _saveAuthState();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _phoneNumber = '';
    await _saveAuthState();
    notifyListeners();
  }
}