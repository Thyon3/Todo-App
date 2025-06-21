import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:frontend/config/config.dart';
import 'package:frontend/pages/dashoboard.dart';
import 'package:frontend/pages/homescreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void initState() {
    super.initState();
  }
  // get the instance of the shared preference

  Duration _loadingTime = const Duration(milliseconds: 100);
  Future<String?> _saveToken(String token) async {
    try {
      WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding
      final pref = await SharedPreferences.getInstance();
      await pref.setString('token', token);
      return null;
    } catch (e) {
      debugPrint('SharedPreferences error: $e');
      return 'Failed to save login session';
    }
  }

  Future<String?> _authUser(SignupData signUp) async {
    try {
      // ---------- 1.  SIGN UP ----------
      final signupResp = await http.post(
        Uri.parse(register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': signUp.name, 'password': signUp.password}),
      );

      final signupJson = jsonDecode(signupResp.body);

      if (signupJson['status'] != true) {
        return signupJson['message'] ?? 'Signup failed';
      }

      // auto login the user
      final loginResp = await http.post(
        Uri.parse(login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': signUp.name, // same creds we just registered
          'password': signUp.password,
        }),
      );

      final loginJson = jsonDecode(loginResp.body);

      if (loginJson['status'] != true) {
        return loginJson['message'] ?? 'Login failed right after signup';
      }

      final token = loginJson['token'];
      if (token == null) return 'No token received';

      final saveError = await _saveToken(token);
      if (saveError != null) return saveError;

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Dashoboard(token: token)),
        );
      }

      return null;
    } on SocketException {
      return 'Network error – check your connection';
    } catch (e) {
      return 'Unexpected error: $e';
    }
  }

  /// Manual login (e.g. user comes back later and hits "Log in").
  Future<String?> _loginUser(LoginData loginData) async {
    try {
      final resp = await http.post(
        Uri.parse(login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': loginData.name,
          'password': loginData.password,
        }),
      );

      final data = jsonDecode(resp.body);

      if (data['status'] != true) {
        return data['message'] ?? 'Invalid email or password';
      }

      final token = data['token'];
      if (token == null) return 'No token received';

      final saveError = await _saveToken(token);
      if (saveError != null) return saveError;

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Dashoboard(token: token)),
        );
      }

      return null; // success
    } on SocketException {
      return 'Network error – check your connection';
    } catch (e) {
      return 'Unexpected error: $e';
    }
  }

  Future<String?> _recoverPassword(String signUp) async {
    // first create json object for the email and password

    return Future.delayed(_loadingTime).then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        onLogin: _loginUser,
        onSignup: _authUser,
        onRecoverPassword: _recoverPassword,
      ),
    );
  }
}
