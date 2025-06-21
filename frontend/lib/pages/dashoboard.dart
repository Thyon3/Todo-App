import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Dashoboard extends StatefulWidget {
  Dashoboard({super.key, required this.token});

  String token;

  @override
  State<Dashoboard> createState() => _DashoboardState();
}

class _DashoboardState extends State<Dashoboard> {
  String? email;
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("you are in your dashboard")),
      body: Column(
        children: [
          Text('good to see you over there$email'),
          // ElevatedButton(onPressed: , child: child)
        ],
      ),
    );
  }
}
