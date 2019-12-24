import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'HomePage.dart';

class UploadPhotoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UploadPhotoPageState();
  }
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {

  File sampleImage;
  String _myValue;
  String url;
  final formKey = GlobalKey<FormState>();

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }

  bool validateAndSave() {
    final form = formKey.currentState;

    if(form.validate()) {
      form.save();
      return true;
    }
    else {
      return false;
    }
  }

  void uploadStatusImage() async {
    if(validateAndSave()) {
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post Images");

      var timeKey = DateTime.now();

      final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);

      var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

      url = ImageUrl.toString();

      print("Image Url = " + url);

      goToHomePage();
      saveToDatabase(url);
    }
  }

  void saveToDatabase(url) {
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var data = {
      "image" : url,
      "description" : _myValue,
      "date" : date,
      "time" : time
    };

    ref.child("Posts").push().set(data);
  }

  void goToHomePage() {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) {
        return HomePage();
      })
      );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(143, 148, 251, 1),
        title: Text('UPLOAD IMAGE', style: TextStyle(fontFamily: 'Acme'),),
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      ),
      body: Center(
        child: sampleImage == null ? Text('SELECT AN IMAGE', style: TextStyle(fontFamily: 'Acme'),): enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: Icon(Icons.add_a_photo),
        backgroundColor: Color.fromRGBO(143, 148, 251, 1),
      ),
    );
  }

  Widget enableUpload() {
    return Container(
      child: Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          Image.file(sampleImage, height: 330.00, width: 600.0),
          SizedBox(height: 15.0,),
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.edit, size: 40.0,),
              labelText: 'Description',
            ),
            validator: (value) {
              return value.isEmpty ? 'Image Description is required' : null;
            },

            onSaved: (value) {
              return _myValue = value;
            },
          ),
          SizedBox(height: 15.0,),

          RaisedButton(
            elevation: 10.0,
            child: Text('Add this Post', style: TextStyle(fontFamily : 'Acme')),
            textColor: Colors.white,
            color: Color.fromRGBO(143, 148, 251, 1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            onPressed: uploadStatusImage,
          )
        ],
      ),
    ));
  }
}