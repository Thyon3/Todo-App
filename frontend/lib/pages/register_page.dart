import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/components/my_button.dart';
import 'package:frontend/components/my_text_field.dart';
import 'package:frontend/config/config.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/pages/login_page.dart';

import 'package:http/http.dart' as http;

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // calling the register api

  Future<void> signUp(BuildContext context) async {
    // send a post request
    try {
      var jsonBody = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      var jsonToSend = json.encode(jsonBody);

      final uri = Uri.parse(register);
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonToSend,
      );

      final data = json.decode(response.body);
      if (!data['status']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Sign Up failed ${data['message']}"),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('registered succefully navigate to the login page '),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => newLoginPage()),
      );
      return null;
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${error.toString()}')));
    }
  }

  Widget build(context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_open_outlined, size: 100),
            SizedBox(height: 25),
            Text(
              'Welcome to ThyDelivery',
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
            SizedBox(height: 10),
            MyTextField(
              textEditingController: confirmPasswordController,
              hintText: 'Confirm Password',
              obscureText: true,
            ),
            SizedBox(height: 25),
            MyButton(
              onTap: () {
                signUp(context);
              },
              text: 'Sign Up',
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Have an Account?',
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
                      MaterialPageRoute(builder: (context) => newLoginPage()),
                    );
                  },
                  child: Text(
                    'Sign In',
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
