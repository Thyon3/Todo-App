import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/components/my_button.dart';
import 'package:frontend/components/my_text_field.dart';
import 'package:frontend/config/config.dart';
import 'package:frontend/pages/dashoboard.dart';
import 'package:frontend/pages/register_page.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class newLoginPage extends StatefulWidget {
  newLoginPage({super.key});

  @override
  State<newLoginPage> createState() => _newLoginPageState();
}

class _newLoginPageState extends State<newLoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  late SharedPreferences pref;

  void initState() {
    super.initState();
    sharedIntialize();
  }

  void sharedIntialize() async {
    pref = await SharedPreferences.getInstance();
  }

  Future<void> signIn(BuildContext context) async {
    try {
      var jsonBody = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      var jsonText = json.encode(jsonBody);

      var uri = Uri.parse(login);
      var response = await http.post(
        uri,
        body: jsonText,
        headers: {"Content-Type": "application/json"},
      );

      var data = json.decode(response.body);

      if (data['status']) {
        var token = data['token'];
        if (token == null || token.isEmpty) {
          throw Exception('No token received');
        }
        await pref.setString('token', token);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Dashoboard(token: token)),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: data['message']));
        return;
      }
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error : ${error.toString()}')));
    }
  }

  Widget build(context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_history, size: 100),
            SizedBox(height: 25),
            Text(
              'Welcome To your todo app',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            SizedBox(height: 25),
            MyTextField(
              textEditingController: emailController,
              hintText: 'Email',
              obscureText: false,
            ),
            SizedBox(height: 10),
            MyTextField(
              textEditingController: passwordController,
              hintText: 'Passwrod',
              obscureText: true,
            ),
            SizedBox(height: 25),
            MyButton(
              onTap: () {
                signIn(context);
              },
              text: 'sign in ',
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a Member?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
