import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_page/profile_screen.dart';
import 'package:http/http.dart' as http;

class EditScreen extends StatelessWidget {
  int userid;
  String firstname;
  String lastname;
  String phonenumber;
  String address;
  String imageUrl;
  String authToken;
  EditScreen({ this.firstname,
     this.lastname, this.phonenumber,
     this.address, this.imageUrl,
     this.userid, this.authToken
  });
  List data=[];
  List<TextEditingController> controllers=[];

  @override
  Widget build(BuildContext context) {
    data=[firstname,lastname,phonenumber,address,imageUrl];
    final controller1=TextEditingController();
    final controller2=TextEditingController();
    final controller3=TextEditingController();
    final controller4=TextEditingController();
    controllers=[controller1,controller2,controller3,controller4];
      for(int i=0;i<4;i++){
        controllers[i].text=data[i];
      }

      return Scaffold(
      appBar: AppBar(title: Text("Edit"),),
      body: Container(
          padding: const EdgeInsets.only(left: 40,top: 40),
          child:Column(
            children: [SizedBox(
              width: 150,
              height: 150,
              child: ClipRRect(borderRadius: BorderRadius.circular(100),
                  child: Image.network(data[4],
                    height: 50,
                    width: 50,
                    )
              ),),
              SizedBox(height: 5,),
              SizedBox(
                  width: 200,
                  child:ElevatedButton(onPressed: () async {
                    var image=await ImagePicker().getImage(source: ImageSource.gallery);
                    String url = 'https://lankavehicles.lk/api/profiles/upload/$userid';
                    var headers = {
                      HttpHeaders.authorizationHeader:"Bearer $authToken"
                    };
                    var request = http.MultipartRequest('POST', Uri.parse(url));
                    request.headers.addAll(headers);
                    Uint8List data = await image.readAsBytes();
                    List<int> list = data.cast();
                    request.files.add(http.MultipartFile.fromBytes('image', list,
                        filename: 'myFile.png'));
                    var response = await request.send();

                    },
                    style:ElevatedButton.styleFrom(backgroundColor: Colors.yellow,side: BorderSide.none,
                        shape: const StadiumBorder()),
                    child: const Text("Upload Photo",style: TextStyle(fontWeight: FontWeight.bold),),)),
              const SizedBox(height: 30,),
              const Divider(),
              ListView.builder( itemCount: 4,scrollDirection: Axis.vertical,
                  shrinkWrap: true,itemBuilder: (context,index){
                    return Container(
                      margin: const EdgeInsets.all(10),
                      height: 30,
                      child: TextField(
                          controller: controllers[index],
                          obscureText:false,
                          decoration:  const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                    );}
                    ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [ElevatedButton(onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen(userid: userid,
                    authToken: authToken,)),);
                },
                  style:ElevatedButton.styleFrom(backgroundColor: Colors.yellow,side: BorderSide.none,
                    shape: const StadiumBorder(),),
                  child: const Text("Cancel",style: TextStyle(fontWeight: FontWeight.bold),)
              ),const SizedBox(width: 100,),
                ElevatedButton(onPressed: (){
                  update() async{
                    final response=await http.put(Uri.parse("https://lankavehicles.lk/api/profiles/$userid"),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        HttpHeaders.authorizationHeader:"Bearer $authToken"
                      },
                      body: jsonEncode(<String, String>{
                        "firstName": controller1.text,
                        "lastName":controller2.text,
                        "phoneNumber":controller3.text,
                        "address":controller4.text,
                        "userId":"$userid"
                      }),);
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen(userid: userid,
                          authToken:authToken,),
                        ));}
                  update();
                  },
                    style:ElevatedButton.styleFrom(backgroundColor: Colors.yellow,side: BorderSide.none,
                        shape: const StadiumBorder()),
                    child: const Text("Save",style: TextStyle(fontWeight: FontWeight.bold),)
              ),]

          )
      ])
    ));

  }
}
