import 'package:flash_chat/screens/chat_file.dart';
import 'package:flash_chat/screens/user_chat_screen.dart';
import 'package:flash_chat/screens/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/profile_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
final _auth=FirebaseAuth.instance;
 FirebaseUser user;



 void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<ChatData>(
  create: (context)=>ChatData(),

      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          textTheme: TextTheme(
            body1: TextStyle(color: Colors.black54),
          ),
        ),

          initialRoute:WelcomeScreen.id,
      routes:{
          WelcomeScreen.id:(context){return WelcomeScreen();},
          LoginScreen.id:(context){return LoginScreen();},
        RegistrationScreen.id:(context){return RegistrationScreen();},
        ChatScreen.id:(context){return ChatScreen();},
        ProfileScreen.id:(context){return ProfileScreen();},
      UserScreen.id:(context){return UserScreen();},
      UserChatScreen.id:(context){return UserChatScreen();
      }
        }
      ),
    );
  }
}
