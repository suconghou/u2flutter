import 'package:flutter/material.dart';
import 'pages/MainPage.dart';
import 'pages/FavoritesPage.dart';
import 'pages/PlayPage.dart';

final Map<String, WidgetBuilder> ROUTES = {
  "/": (c) => MainPage(),
  '/favorites':(c)=>FavoritesPage(),
  '/play':(c)=>PlayPage(),

};