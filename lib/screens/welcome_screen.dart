import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
final _auth=FirebaseAuth.instance;

FirebaseUser loggedinUser;
bool spinner=false;

class WelcomeScreen extends StatefulWidget {
  static String id='welcome';


  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  void getUser()async
  {final user=await _auth.currentUser();

   setState(() {
     loggedinUser=user;
   });


  }

  @override
  void initState() {
getUser() ;
controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    super.initState();
    animation = ColorTween(begin: Colors.grey,end: Colors.white).animate(controller);

    controller.forward();

    controller.addListener(

            () {
          setState(() {

          });


        });



  }


  @override
  Widget build(BuildContext context) {
    getUser();
    return Scaffold(
      backgroundColor:animation.value,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag:'hero',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 60,
                    ),
                  ),
                  TypewriterAnimatedTextKit(
                    text:['Flash Chat'],
                    textStyle: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              Roundedbutton(Color(0xff075E54),(){
                String a;
                spinner=true;
                a= (loggedinUser!=null)?'user':'login';
                Navigator.pushNamed(context, a);
                spinner=false;
                  },

                  Text('Log in')),
              Roundedbutton(Color(0xff075E54),(){Navigator.pushNamed(context, 'signup');},Text('Register')),
            ],
          ),
        ),
      ),
    );
  }


}



