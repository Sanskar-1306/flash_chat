import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash_chat/screens/chat_file.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _cloudstore = Firestore.instance;
bool isMe;
String clickedEmail;
String url;
final _auth = FirebaseAuth.instance;
FirebaseUser loggedinUser;

void getUser() async {
  final user = await _auth.currentUser();
  if (user != null) loggedinUser = user;
}

class UserChatScreen extends StatefulWidget {
  static String id = 'userchat';
  @override
  _UserChatScreenState createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  void getUrl() async {
    try{
      final StorageReference storageReference =
      FirebaseStorage.instance.ref().child('$clickedEmail');
      final String Location = await storageReference.getDownloadURL();
      url = Location;
    }
    catch(e){

      url=null;
    }

  }

  TextEditingController textEditingController = TextEditingController();
  String message;

  void getClickedEmail() {
    clickedEmail = Provider.of<ChatData>(context).clickedEmail;
  }

  @override
  void initState() {
    // TODO: implement initState
    getUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getClickedEmail();
    getUrl();
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                        child: Image.network(url),
                      ));
            },
            child: CircleAvatar(
              backgroundImage: (url == null) ? AssetImage('images/user_icon.png') : NetworkImage(url),
              radius: 100,
            ),
          ),
          title: Text(
            '$clickedEmail',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          backgroundColor: Color(0xff075E54),
        ),

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Material(
              elevation: 50,
              color: Colors.lightBlueAccent,
            ),
            buildStreamBuilder(),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                        controller: textEditingController,
                        onChanged: (value) {
                          message = value;

                          //Do something with the user input.
                        },

                        decoration: InputDecoration(hintText: 'Enter your message here',hintStyle: TextStyle(color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff075E54),
                                ),
                                borderRadius: BorderRadius.circular(30)),
                            filled: true,
                            fillColor: Colors.white,
                            hoverColor: Color(0xff075E54),
                            focusColor: Color(0xff075E54),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)))),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                      backgroundColor: Color(0xff075E54),
                      onPressed: () async {
                        await _cloudstore
                            .collection('${loggedinUser.email}_$clickedEmail')
                            .add({
                          'message': message,
                          'user': loggedinUser.email,
                          'time': DateTime.now()
                        });
                        await _cloudstore
                            .collection('${clickedEmail}_${loggedinUser.email}')
                            .add({
                          'message': message,
                          'user': loggedinUser.email,
                          'time': DateTime.now()
                        });
                        textEditingController.clear();
                      },
                      child: Center(
                          child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 35,
                      ))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

StreamBuilder<QuerySnapshot> buildStreamBuilder() {
  return StreamBuilder(
    stream: _cloudstore
        .collection('${loggedinUser.email}_$clickedEmail')
        .snapshots(),
    builder: (context, snapshot) {
      List<MessageBubble> listmsg = [];
      if (snapshot.hasData) {
        final messages = snapshot.data.documents;

        for (var message in messages) {
          var text = message.data['message'];
          var user = message.data['user'];
          final Timestamp messagetime = message.data['time'];
          print(user);
          if (user == loggedinUser.email) {
            isMe = true;
          } else
            isMe = false;
          listmsg.add(MessageBubble(text, user, messagetime));
          listmsg.sort((a, b) => b.getTIme().compareTo(a.getTIme()));
        }
      }
      return Expanded(
        child: ListView(reverse: true, children: listmsg),
      );
    },
  );
}

class MessageBubble extends StatelessWidget {
  var user;
  var text;
  final Timestamp time;
  Timestamp getTIme() {
    return this.time;
  }

  void isme() {
    if (this.user == loggedinUser.email) {
      isMe = true;
    } else
      isMe = false;
  }

  MessageBubble(this.text, this.user, this.time);

  @override
  Widget build(BuildContext context) {
    isme();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$user',
            style: TextStyle(fontSize: 10),
            textAlign: TextAlign.end,
          ),
          Material(
            elevation: 5,
            borderRadius: isMe
                ? (BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)))
                : (BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            color: isMe ? Color(0xffDCF8C6) : Colors.white,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  '$text',
                  style: TextStyle(
                      fontSize: 18,
                      color: isMe ? Colors.black : Colors.black54),
                )),
          ),
          Text(
            '${time.toDate()}',
            style: TextStyle(fontSize: 10),
          )
        ],
      ),
    );
  }
}
