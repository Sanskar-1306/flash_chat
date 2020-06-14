
import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
final _auth=FirebaseAuth.instance;
final _storage=Firestore.instance;
FirebaseUser loggedinuser;
bool isTure=false;
String downloadUrl;
String email;
class ProfileScreen extends StatefulWidget {
 static String id='profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _image;
  Future getImage(ImageSource source)async{
   File image= await ImagePicker.pickImage(source:source);
   File croppedImage= await ImageCropper.cropImage(sourcePath: image.path,
   aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
     compressQuality: 100,

     compressFormat: ImageCompressFormat.jpg,
     cropStyle: CropStyle.circle
   );

 setState(() {
   _image=croppedImage;
 });


}



  Future getUser() async{
    isTure=true;
    final user =await _auth.currentUser();
    if (user!=null)
      loggedinuser=user;
setState(() {
  email=loggedinuser.email;
});

    print(loggedinuser.email);
  }
  Future downloadImage()async{

    final StorageReference storagereference=FirebaseStorage.instance.ref().child('\'${loggedinuser.email}\'');
    String location= await storagereference.getDownloadURL().toString();
      print(location);
      setState(() {
        downloadUrl=location;
      });

}
  Future uploadFile()async{
    final StorageReference storagereference=FirebaseStorage.instance.ref().child('${loggedinuser.email}');
    final StorageUploadTask storageUploadTask=  storagereference.putFile(_image);
    await storageUploadTask.onComplete;
    print('fileUploaded');

  }
  @override
  void initState() {
    // TODO: implement initState
    getUser();


  }

  @override
  Widget build(BuildContext context) {
    downloadImage();
    return Scaffold(
      appBar: AppBar(backgroundColor:Color(0xff075E54),),
backgroundColor: Colors.white,
      body: ListView(scrollDirection: Axis.vertical,
        children: <Widget>[
          Text('Profile',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w900,color: Colors.black),textAlign: TextAlign.center,),
          SizedBox(height: 15,),
                    CircleAvatar(
                      radius: 50,

                      child: (_image==null)?(downloadUrl==null)?Image.asset('images/user_icon.png'):Image.network(downloadUrl):Image.file(_image),),


          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

            IconButton(icon: Icon(Icons.add_a_photo),color: Color(0xff075E54), onPressed:() {getImage(ImageSource.camera);}),
            IconButton(icon: Icon(Icons.add_photo_alternate),color: Color(0xff075E54), onPressed: (){getImage(ImageSource.gallery);})
          ],),
          SizedBox(height: 10,),
          Text('Email: $email',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 20),textAlign: TextAlign.center,)
,
          Roundedbutton(Color(0xff075E54),(){uploadFile();}, Text('Save'))


        ],

      ),
    );
  }
}
