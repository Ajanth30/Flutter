import 'dart:convert';
import 'dart:js_util';
import 'package:http/http.dart' as http;
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:login_page/edit_screen.dart';
import 'package:login_page/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
       home:CustomWidget() //
    );
  }
}

class CustomWidget extends StatelessWidget{
  final mailController= TextEditingController();
  final passwordController =TextEditingController();

  postData(String email,String password,BuildContext context) async{
    var response= await http.post(Uri.parse("https://lankavehicles.lk/api/login"),
        body: {
          "email":email,
          "password":password
        });
    if (!context.mounted) return;
    Navigator.of(context).pop();
    var responseData = json.decode(response.body);
    int userid=responseData["results"]["auth"]["id"];
    String authToken=responseData["results"]["token"];
    print(userid);
    if(response.statusCode==200){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen(userid: userid,
          authToken:authToken,)),
      );
    }
    else{
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
              content:Text("Invalid Credintials")
          );
        },
      );
    }


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(title: Text("Login Page"),) ,
        body: Padding(
          padding: EdgeInsets.all(20),
          child:Material(child:Column(
                children:  [TextField(
                  controller: mailController,
                  obscureText: false,
                  decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
            ),
          ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          const SizedBox(height: 20),
            Container(
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.blue,
                ),
                onPressed: () {
                  postData(mailController.text, passwordController.text,context);
                  },
                child: Text('LogIn'),
              ),
            )],
        ) ,
      ),
    ));
    // TODO: implement build
    throw UnimplementedError();
  }

  
}


