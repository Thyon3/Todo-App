import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/config/config.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:http/http.dart' as http;

class Dashoboard extends StatefulWidget {
  Dashoboard({super.key, required this.token});
  String token;
  @override
  State<Dashoboard> createState() => _DashoboardState();
}

class _DashoboardState extends State<Dashoboard> {
  TextEditingController titleCotroller = TextEditingController();
  TextEditingController descriptionCotroller = TextEditingController();

  String? email;
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['_id'];
  }

  // make the api call

  Future<void> addTodoList() async {
    //

    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    var uri = Uri.parse(addTodoUri);
    // create the request body using the user inputs and the userId
    var reqBody = {
      "userId": jwtDecodedToken['_id'],
      "title": titleCotroller.text,
      "description": descriptionCotroller.text,
    };

    var reqSend = json.encode(reqBody);

    try {
      var response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: reqSend,
      );
      var data = json.decode(response.body);

      if (data['status']) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('succesfully added')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error:${data['message']}')));
      }
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error:${error.toString()}')));
    }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addToDo(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _addToDo(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title:',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
              ),
              SizedBox(height: 8),
              TextField(
                controller: titleCotroller,
                decoration: InputDecoration(
                  hintText: 'i have to ...',

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.black26,
                      style: BorderStyle.solid,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
              Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
              ),
              SizedBox(height: 8),

              Container(
                height: 200,
                width: 500,

                child: TextField(
                  controller: descriptionCotroller,
                  textAlignVertical: TextAlignVertical.top,
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  decoration: InputDecoration(
                    hintText: 'yeah that is cause of something i did ...',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.black26,
                        style: BorderStyle.solid,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('cancel'),
            ),
            TextButton(
              onPressed: () {
                addTodoList();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
