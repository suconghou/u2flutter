import 'package:flutter/material.dart';



class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Page Title"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Favorite Page"),

          ],
        ),
      ),

    );
  }

}