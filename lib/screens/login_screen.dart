



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
final _auth=FirebaseAuth.instance;
final googleSignIn=GoogleSignIn();
final Firestore _firestore=Firestore.instance;
FirebaseUser user;
class LoginScreen extends StatefulWidget {
  static String id='login';


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  void getUserinfo  ()async
  {
    await _firestore.collection('user_info').add({
      'email':user.email
    });

  }

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


  String email;
  String password;
  bool showSpinner=false;
  FirebaseUser loggedinUser;
  final _auth =FirebaseAuth.instance;


@override
  void initState() {
    // TODO: implement initState
    super.initState();

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall:showSpinner ,
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
              TextField(

                  style:TextStyle (color: Colors.black),
                keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {

                  email=value;

                  },
                decoration: kInputTExtDecoration
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(style:TextStyle (color: Colors.black),
                obscureText: true,
                  onChanged: (value) {
                  password=value;

                },
                decoration: kInputTExtDecoration.copyWith(hintText: 'Enter your password')
              ),
              SizedBox(
                height: 24.0,
              ),
              Roundedbutton(Colors.blueAccent, ()async{
              setState(() {
                showSpinner=true;
              });

                try {
                  final User = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  if (User != null)
                    Navigator.pushNamed(context, UserScreen.id);
                }
                catch(e){bool show=true;

                showDialog(context: context,
    child:AlertDialog(title:Icon(Icons.block,color: Colors.red,size:100),
      backgroundColor:Colors.white,content: Text('Email or password is incorrect',style: TextStyle(color:Colors.blueAccent,fontWeight: FontWeight.w600)),actions: <Widget>[FlatButton(
        color: Colors.blueAccent,child: Text('Retry',textAlign: TextAlign.center,),onPressed: (){Navigator.pop(context);}
      )],));
                  print(e);}
              setState(() {
                showSpinner=false;
              });



                }





              , Text('log in')),
              Roundedbutton(Colors.amber, ()async{
                try{
                   SignInWIthGoogle();
                  Navigator.pushNamed(context, UserScreen.id);

                }
                catch(e){
                  print("The Error is $e");
                }

              },
                  Text("SIGN IN WITH GOOGLE"))


            ],
          ),
        ),
      ),
    );
  }
}
