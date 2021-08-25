import 'package:flutter/material.dart';
import 'package:wallpaper_app/model/wallpaper_model.dart';
import 'package:wallpaper_app/screens/viewImage.dart';

Widget brandName() {
  return RichText(
    text: TextSpan(
      children: const <TextSpan>[
        TextSpan(
          text: 'Wallpaper',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: 17.0),
        ),
        TextSpan(
          text: 'App',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blueAccent,
              fontSize: 17.0),
        ),
      ],
    ),
  );
}

Widget wallpaperList(List<WallpaperModel> wallpapers, loggedInUser, context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 6.0,
      childAspectRatio: 0.6,
      crossAxisSpacing: 6.0,
      children: wallpapers.map((wallpaper) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewImage(
                  imgUrl: wallpaper.src.portrait,
                  loggedInUser: loggedInUser,
                ),
              ),
            );
          },
          child: Hero(
            tag: wallpaper.src.portrait,
            child: GridTile(
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.network(
                    wallpaper.src.portrait,
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
}
