import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/screens/viewImage.dart';
import 'package:wallpaper_app/widgets/widget.dart';

final _firestore = FirebaseFirestore.instance;

class FavouritesPage extends StatefulWidget {
  final User? loggedInUser;
  FavouritesPage({this.loggedInUser});

  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
      ),
      body: StreamBuilder(
        stream: _firestore.collection(widget.loggedInUser!.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.count(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 6.0,
              childAspectRatio: 0.6,
              crossAxisSpacing: 6.0,
              children: snapshot.data!.docs.map((document) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewImage(
                          imgUrl: document['imgUrl'],
                          loggedInUser: widget.loggedInUser,
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: document['imgUrl'],
                    child: GridTile(
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.network(
                            document['imgUrl'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
