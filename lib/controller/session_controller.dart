import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view/login_page.dart';

class SessionController {
  static final SessionController _instance = SessionController._internal();

  factory SessionController() {
    return _instance;
  }

  SessionController._internal();

  Timer? _sessionTimer;
  final int _sessionTimeoutMinutes = 15;
  static const String _lastActivityTimeKey = 'lastActivityTime';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _usernameKey = 'username';

  Future<void> startSession(
    BuildContext context, {
    String username = '',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);

    if (username.isNotEmpty) {
      await prefs.setString(_usernameKey, username);
    }

    updateLastActivityTime();
    startSessionTimer(context);
  }

  Future<bool> isSessionActive() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    if (!isLoggedIn) return false;

    final lastActivityTimeMs = prefs.getInt(_lastActivityTimeKey) ?? 0;
    final lastActivityTime = DateTime.fromMillisecondsSinceEpoch(
      lastActivityTimeMs,
    );
    final now = DateTime.now();
    final difference = now.difference(lastActivityTime).inMinutes;

    return difference < _sessionTimeoutMinutes;
  }

  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey) ?? 'User';
  }

  Future<String> getUserInitials() async {
    String username = await getUsername();
    if (username.length >= 2) {
      return username.substring(0, 2).toUpperCase();
    } else if (username.isNotEmpty) {
      return username[0].toUpperCase();
    }
    return 'US';
  }

  void startSessionTimer(BuildContext context) {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(Duration(minutes: 1), (timer) async {
      if (!await checkSessionTimeout(context)) {
        timer.cancel();
      }
    });
  }

  Future<void> updateLastActivityTime() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt(_lastActivityTimeKey, now);
  }

  Future<void> userActivity(BuildContext context) async {
    await updateLastActivityTime();

    if (_sessionTimer == null || !_sessionTimer!.isActive) {
      startSessionTimer(context);
    }
  }

  Future<bool> checkSessionTimeout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final lastActivityTimeMs = prefs.getInt(_lastActivityTimeKey) ?? 0;
    final lastActivityTime = DateTime.fromMillisecondsSinceEpoch(
      lastActivityTimeMs,
    );
    final now = DateTime.now();
    final difference = now.difference(lastActivityTime).inMinutes;

    if (difference >= _sessionTimeoutMinutes) {
      await logout(context);
      return false;
    }
    return true;
  }

  Future<void> logout(BuildContext context) async {
    _sessionTimer?.cancel();
    _sessionTimer = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_lastActivityTimeKey);
    await prefs.remove(_usernameKey);

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void disposeSession() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
  }
}
