import 'package:flutter/material.dart';
import 'PhotoUpload.dart'; 
import 'Posts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Authentication.dart';


class HomePage extends StatefulWidget {

  HomePage({
    this.auth,
    this.onSignedOut,
});

  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  List<Posts> postsList = [];


  @override
  void initState() {
    super.initState();

    DatabaseReference postsRef = FirebaseDatabase.instance.reference().child("Posts");

    postsRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      postsList.clear();

      for(var individualKey in KEYS) {
        Posts posts = Posts(
          DATA[individualKey]['image'],
          DATA[individualKey]['description'],
          DATA[individualKey]['date'],
          DATA[individualKey]['time'],
          ); 

          postsList.add(posts);
      }

      setState(() {
        print('Length : $postsList.length');

      });
    });
  }

  void _logoutUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    }
    catch(e)
    {
      print(e.toString());
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _logoutUser,
            );
          },
        ),
        title: Text('MY FEED', style: TextStyle(fontFamily: 'Acme'),),
        elevation: 30.0,
        backgroundColor: Color.fromRGBO(143, 148, 251, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      ),
      body: Center(
        child: postsList.length == 0 ? Text("NO NOTES UPLOADED", style: TextStyle(fontSize: 15.0, fontFamily: 'Acme')) : ListView.builder(
          itemCount: postsList.length,
          itemBuilder: (_, index) {
            return PostsUI(postsList[index].image, postsList[index].description, postsList[index].date, postsList[index].time);
          },
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color.fromRGBO(143, 148, 251, 1),
        elevation: 4.0,
        icon: Icon(Icons.add_a_photo),
        label: Text('Add notes'),
        onPressed: () {
           Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) {
                      return UploadPhotoPage();
                    })
      );
        }
      ),

      bottomNavigationBar: BottomAppBar(
        elevation: 100.0,
        color: Color.fromRGBO(143, 148, 251, 1),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
               IconButton(
                icon: Icon(Icons.lock_open),
                iconSize:  0,
                color: Colors.white,
                onPressed: _logoutUser,
              ),
            ],
          ),
        ))
    );
  }

  Widget PostsUI(String image, String description, String date, String time) {
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget> [
            Text(
              date,
              style: Theme.of(context).textTheme.subtitle,
              textAlign: TextAlign.center,
            ),
            Text(
              time,
              style: Theme.of(context).textTheme.subtitle,
              textAlign: TextAlign.center,
            )
          ],
        ),
        SizedBox(height: 10.0,),
        Image.network(image, fit: BoxFit.cover),
        SizedBox(height: 10.0,),
        Text(
              description,
              style: Theme.of(context).textTheme.subtitle,
              textAlign: TextAlign.center,
            ),
          ]),
    ));
  }
}