import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:wallpaper_app/model/wallpaper_model.dart';
import 'package:wallpaper_app/widgets/widget.dart';
import 'home_screen.dart';

class Search extends StatefulWidget {
  final String searchQuery;
  final User? loggedInUser;
  Search({required this.searchQuery, required this.loggedInUser});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
    searchWallpapers(widget.searchQuery);
    searchController.text = widget.searchQuery;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: brandName(),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Color(0xfff5f8fd),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              margin: EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'search wallpaper',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      searchWallpapers(searchController.text);
                      print('LET IT RAIN OVER ME');
                      setState(() {});
                    },
                    child: Icon(Icons.search),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            wallpaperList(wallpapers, widget.loggedInUser, context),
          ],
        ),
      ),
    );
  }
}
