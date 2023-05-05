import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_page/edit_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';

class ProfileScreen extends StatelessWidget {
  int userid;
  String authToken;

  List fields=["First Name","Last Name","Phone Number",
    "Address"];
  List userdata =[];

  ProfileScreen({ this.userid,this.authToken});

  Future<String> getRequest() async {
    String url = "https://lankavehicles.lk/api/users/$userid";
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);
    userdata.add(responseData["results"]["profileInfo"]["firstName"]);
    userdata.add(responseData["results"]["profileInfo"]["lastName"]);
    userdata.add(responseData["results"]["profileInfo"]["phoneNumber"]);
    userdata.add(responseData["results"]["profileInfo"]["address"]);
    if(responseData["results"]["profileInfo"]["imagePath"]==null){
      userdata.add("images/default-image.jpg");
    }else{
      userdata.add(responseData["results"]["profileInfo"]["imagePath"]);
    }
    return "Success";
  }

   @override
  Widget build(BuildContext context) {
       return  Scaffold(
         appBar:AppBar(
             title: const Text("Profile",textAlign: TextAlign.end,style: TextStyle(fontWeight: FontWeight.bold),) ),
         body: SingleChildScrollView(
           child: Container(
             child: FutureBuilder(
               future:getRequest(),
               builder:(BuildContext context, AsyncSnapshot<String> snapshot){
                 if(snapshot.data==null){
                   return Container(
                     child: const Center(
                       child: CircularProgressIndicator(),
                     ),
                   );
                 }else{
                   return Container(
                       padding: const EdgeInsets.only(left: 40,top: 40),
                       child:Column(
                         children: [SizedBox(
                           width: 150,
                           height: 150,
                           child: ClipRRect(borderRadius: BorderRadius.circular(100),
                               child: Image.network(userdata[4],
                                 height: 100,
                                 width: 100,)
                           ),
                         ),
                           const SizedBox(height: 30,),
                           const Divider(),
                           ListView.builder( itemCount: 4,scrollDirection: Axis.vertical,
                               shrinkWrap: true,itemBuilder: (context,index){
                             return Container(
                               height: 70,
                               child: Text(fields[index]+" : " +userdata[index]),
                             );
                           }),
                           SizedBox(height: 20,),
                           SizedBox(
                               width: 200,
                               child:ElevatedButton(onPressed: (){
                                 Navigator.push(
                                   context,
                                   MaterialPageRoute(builder: (context) => EditScreen(
                                     firstname: userdata[0],lastname: userdata[1],
                                     phonenumber: userdata[2],address: userdata[3],imageUrl: userdata[4],userid: userid,
                                     authToken: authToken,)),
                                 );
                               },
                                 style:ElevatedButton.styleFrom(backgroundColor: Colors.yellow,side: BorderSide.none,
                                     shape: const StadiumBorder()),
                                 child: const Text("Edit Profile",style: TextStyle(fontWeight: FontWeight.bold),),)),
                         ],));
                 }
               },
             ),


           ),
         ),
       );
      }}
