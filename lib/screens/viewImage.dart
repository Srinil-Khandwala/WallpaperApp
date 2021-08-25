import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

final _firestore = FirebaseFirestore.instance;

class ViewImage extends StatefulWidget {
  final String imgUrl;
  final User? loggedInUser;
  ViewImage({required this.imgUrl, required this.loggedInUser});

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  bool clicked = false;
  bool favourite = false;
  List<Map<String, dynamic>> docList = [];

  void _loadFirebaseFavourites() async {
    print(' LOADING USER : ${widget.loggedInUser?.uid}');
    //retrieve data from firebase and add to docList
    await _firestore
        .collection(widget.loggedInUser!.uid)
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                docList.add(doc.data());
              })
            });

    _firestore.collection(widget.loggedInUser!.uid);
    if (docList.length > 0) {
      for (var map in docList) {
        if (map.containsKey('imgUrl')) {
          if (map['imgUrl'] == widget.imgUrl) {
            favourite = true;
            clicked = true;
            setState(() {});
          }
        }
      }
    }
    print('List Length : ${docList.length}');
  }

  void _addToFavourites() async {
    _firestore.collection(widget.loggedInUser!.uid);
    if (favourite == false) {
      //adding to Firebase
      _firestore
          .collection(widget.loggedInUser!.uid)
          .add({'imgUrl': widget.imgUrl});
      //adding to docList
      Map<String, dynamic> newFav = {'imgUrl': widget.imgUrl};
      docList.add(newFav);
      favourite = true;
      setState(() {});
    }
    print(docList);
    print('List Length : ${docList.length}');
  }

  void _removeFromFavourites() {
    // Delete all docs from firebase
    _firestore
        .collection(widget.loggedInUser!.uid)
        .where("imgUrl", isEqualTo: widget.imgUrl)
        .get()
        .then((value) => value.docs.forEach((document) {
              _firestore
                  .collection(widget.loggedInUser!.uid)
                  .doc(document.id)
                  .delete()
                  .then((_) {
                print("success!");
              });
            }));
    favourite = false;
    clicked = false;
    setState(() {});
  }

  @override
  void initState() {
    _loadFirebaseFavourites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              widget.imgUrl,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      // color: Colors.black,
                      border: Border.all(
                          color: favourite ? Colors.white : Colors.white60),
                      borderRadius: BorderRadius.circular(100.0),
                      gradient: LinearGradient(
                        colors: <Color>[Color(0x36FFFFFF), Color(0x0FFFFFFF)],
                      ),
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: favourite ? Colors.white : Colors.grey,
                      size: 25.0,
                    ),
                  ),
                  onTap: () {
                    clicked = !clicked;

                    if (clicked == true) {
                      _addToFavourites();
                    } else {
                      _removeFromFavourites();
                    }
                    setState(() {});
                  },
                ),
                SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () {
                    _save();
                    _openWallpaperSavedDialogBox();
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 14,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          color: Color(0xff1c1b1b).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 14,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white60),
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0x36FFFFFF),
                              Color(0x0FFFFFFF)
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Set Wallpaper',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              'Image will be saved in gallery',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'cancel',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 40.0)
              ],
            ),
          ),
        ],
      ),
    );
  }

  _save() async {
    log('In save fn!');
    await _askPermission();
    var response = await Dio()
        .get(widget.imgUrl, options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    log(result.toString());
    // Navigator.pop(context);
  }

  _askPermission() async {
    if (Platform.isIOS) {
      await Permission.photos.request();
    } else {
      await Permission.storage.request();
    }
  }

  void _openWallpaperSavedDialogBox() {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text('Wallpaper Saved!'),
                content: Text('Open gallery to have a look..'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }
}
