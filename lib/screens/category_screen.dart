import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/model/wallpaper_model.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/widgets/widget.dart';
import 'home_screen.dart';

class CategoryWallpapers extends StatefulWidget {
  final String categoryName;
  final User? loggedInUser;
  CategoryWallpapers({required this.categoryName, required this.loggedInUser});

  @override
  _CategoryWallpapersState createState() => _CategoryWallpapersState();
}

class _CategoryWallpapersState extends State<CategoryWallpapers> {
  List<WallpaperModel> wallpapers = [];
  TextEditingController searchController = new TextEditingController();

  searchWallpapers(String query) async {
    var url =
        Uri.parse('https://api.pexels.com/v1/search?query=$query&per_page=50');
    var response = await http.get(url, headers: {'Authorization': apiKey});

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData['photos'].forEach((element) {
      WallpaperModel wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    setState(() {});
  }

  @override
  void initState() {
    searchWallpapers(widget.categoryName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              wallpaperList(wallpapers, widget.loggedInUser, context),
            ],
          ),
        ),
      ),
    );
  }
}
