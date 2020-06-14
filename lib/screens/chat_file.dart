import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ChatData extends ChangeNotifier{


String clickedEmail;
List <String> emailId=[];
void changeClickedEmail(String email)
{
  clickedEmail=email;
  notifyListeners();
}


}