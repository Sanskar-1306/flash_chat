import 'dart:io';
import 'dart:math';
import 'package:flash_chat/screens/welcome_screen.dart';

import 'profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/user_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_file.dart';
class UserScreen extends StatefulWidget {
static String id='user';


  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _auth=FirebaseAuth.instance;
var _future;
List<String>urlList=[];
Future getData()async{

QuerySnapshot sp= await _firestore.collection("user_info").getDocuments();
return sp.documents;

}
void getUrl(String email)async{
print(email);


print(url);
}

final _firestore=Firestore.instance;



@override
  void initState() {
    // TODO: implement initState
    super.initState();

_future=getData();

}


  @override
  Widget build(BuildContext context) {

   



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,

        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: ()async {

                await _auth.signOut();
                Navigator.pushNamed(context, WelcomeScreen.id);

                //Implement logout functionality
              }),
          IconButton(icon: Icon(Icons.account_circle), onPressed:(){Navigator.pushNamed(context, ProfileScreen.id);})
        ],
        title: Text('⚡️Chat'),

        backgroundColor: Color(0xff075E54),
      ),


      body: WillPopScope(
onWillPop: (){
  Navigator.pushNamed(context,UserScreen.id);
},

        child: FutureBuilder(
          future:_future ,
          builder:(context,snapshot)
          {

return ListView.builder(
    itemCount: snapshot.data.length,
    itemBuilder: (BuildContext context,int index)

{
return Users_bubble(snapshot.data[index].data['email'],);

}

);


          } 
        
        
        )
      ),
    );
  }
}
class Users_bubble extends StatelessWidget {
  var locationImage;
  String userEmail;
  Users_bubble(this.userEmail);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.only(top: 1),
        child: GestureDetector(
          onTap: (){

            Navigator.pushNamed(context, UserChatScreen.id);
            Provider.of<ChatData>(context,listen: false).changeClickedEmail(this.userEmail);

          },
          child: Material(
color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 30),
              child: Row(

                children: <Widget>[

                CircleAvatar(backgroundImage:AssetImage('images/user_icon.png'),),
               SizedBox(width: 20,),
                Text(this.userEmail,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
