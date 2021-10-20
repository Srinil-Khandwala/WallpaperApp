import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/model/wallpaper_model.dart';
import 'package:wallpaper_app/screens/category_screen.dart';
import 'package:wallpaper_app/screens/favourites_screen.dart';
import 'package:wallpaper_app/widgets/widget.dart';
import 'package:wallpaper_app/model/catergory_model.dart';
import 'package:wallpaper_app/data/data.dart';
import 'search_screen.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

String apiKey = '563492ad6f91700001000001ed2352bf6f354279b8bd2d5f09400dbf';

class Home extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = [];
  List<WallpaperModel> wallpapers = [];
  TextEditingController searchController = new TextEditingController();

  final _auth = FirebaseAuth.instance;
  User? loggedInUser;

  void getCurrentUser() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        loggedInUser = user;
        print(loggedInUser?.email);
        debugPrint(loggedInUser?.email);
      }
    } catch (e) {
      print(e);
    }
  }

  getTrendingWallpapers() async {
    var url = Uri.parse('https://api.pexels.com/v1/curated?per_page=50');
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
    getTrendingWallpapers();
    getCurrentUser();
    categories = getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: brandName(),
        elevation: 0.0,
      ),
      drawer: AppDrawer(loggedInUser: loggedInUser), //AppDrawer
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Search(
                              searchQuery: searchController.text,
                              loggedInUser: loggedInUser,
                            ),
                          ),
                        );
                      },
                      child: Icon(Icons.search),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 80.0,
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: ListView.builder(
                  itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CategoryTile(
                      categoryName: categories[index].categoryName,
                      imgUrl: categories[index].imgUrl,
                      loggedInUser: loggedInUser,
                    );
                  },
                ),
              ),
              wallpaperList(wallpapers, loggedInUser, context),
            ],
          ),
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final User? loggedInUser;
  AppDrawer({required this.loggedInUser});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 5,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black12,
              ),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Icon(Icons.person_rounded),
                        SizedBox(width: 15.0),
                        Text(loggedInUser?.email ?? 'Error!'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Favourites'),
            leading: Icon(Icons.favorite),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FavouritesPage(loggedInUser: loggedInUser),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String imgUrl, categoryName;
  final User? loggedInUser;
  CategoryTile(
      {required this.categoryName,
      required this.imgUrl,
      required this.loggedInUser});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryWallpapers(
              categoryName: categoryName,
              loggedInUser: loggedInUser,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 8.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imgUrl,
                height: 50.0,
                width: 100.0,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 50.0,
              width: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.black26,
              ),
              alignment: Alignment.center,
              child: Text(
                categoryName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
