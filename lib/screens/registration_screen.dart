

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final _auth=FirebaseAuth.instance;
final _firestore=Firestore.instance;
FirebaseUser user;



void getUserinfo  ()async
{
  await _firestore.collection('user_info').add({
    'email':user.email
  });

}




class RegistrationScreen extends StatefulWidget {
 static String id='signup';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String password;
bool showSpinner=false;
  final _auth=FirebaseAuth.instance;
final GoogleSignIn googleSignIn=GoogleSignIn();
  void  SignInWIthGoogle()async{
    GoogleSignInAccount googleSignInAccount=await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication= await googleSignInAccount.authentication;
    AuthCredential credential=GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken:googleSignInAuthentication.accessToken);
    final AuthResult=await _auth.signInWithCredential(credential);
    user=AuthResult.user;
    FirebaseUser currentUser=await _auth.currentUser();
    assert(!user.isAnonymous);
    assert(user.uid==currentUser.uid);
    print('Login Suggesfull with google');

  }
  void signOut()async
  {await googleSignIn.signOut();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag:'hero',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField( textAlign:TextAlign.center,
  keyboardType: TextInputType.emailAddress,            onChanged: (value) {
                 email=value;
                  //Do something with the user input.
                },style: TextStyle(color: Colors.black),
                decoration: kInputTExtDecoration.copyWith(hintText: 'Enter your  Email ID')
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(obscureText: true,
                textAlign:TextAlign.center,
                  onChanged: (value) {
                  password=value;
                  //Do something with the user input.
                },
                decoration:kInputTExtDecoration.copyWith(hintText: 'Enter your password'),style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 24.0,
              ),
             Roundedbutton(Color(0xff075E54), ()async {
               setState(() {
                 showSpinner=true;
               });
              try{
               final newUser= await _auth.createUserWithEmailAndPassword(email: email, password: password);

               if (newUser!=null) {
                 Navigator.pushNamed(context,UserScreen.id );
                 user= await _auth.currentUser();
                 getUserinfo();
               }

}

catch(e){
                print(e);
                showSpinner=false;
                showDialog(context: context,child: AlertDialog(title: Icon(Icons.block,color: Colors.red,size: 40,),
                  content:Text('Either email or password is badly formatted..the password must be greater than 6 digits',style: TextStyle(color: Colors.black),),
                  actions: <Widget>[FlatButton(onPressed: (){Navigator.pop(context);},
                    child: Text('Retry',style: TextStyle(color: Colors.white),),color: Colors.lightBlue,)],
                  backgroundColor: Colors.white,));
              }




               {setState(() {

               });}

             }

             , Text('Sign Up')),
              Roundedbutton(Colors.amber,
                      (){
                        try{
                          showSpinner=true;
                           SignInWIthGoogle();
                          getUserinfo();
                          Navigator.pushNamed(context, UserScreen.id);
showSpinner=false;
                        }
                        catch(e){
                          showSpinner=false;
                          print("The Error is $e");
                        }
                      },
                  Text('SignUp with Google')),
              
            ],
          ),
        ),
      ),
    );
  }
}
