import 'package:flutter/material.dart';
import 'package:frontend/pages/dashoboard.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/register_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // now lets keep teh user signed in as long as the token expires
  SharedPreferences pref = await SharedPreferences.getInstance();
  runApp(MyApp(token: pref.getString("token")));
}

class MyApp extends StatelessWidget {
  final String? token; // explicitly nullable
  MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
          (token != null && !JwtDecoder.isExpired(token!))
              ? Dashoboard(token: token!)
              : newLoginPage(),
    );
  }
}
