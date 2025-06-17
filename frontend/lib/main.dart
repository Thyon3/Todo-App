import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginPage());
  }
}
