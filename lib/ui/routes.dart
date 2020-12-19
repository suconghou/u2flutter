import 'package:flutter/material.dart';
import 'pages/MainPage.dart';
import 'pages/FavoritesPage.dart';
import 'pages/PlayPage.dart';
import 'pages/SettingsPage.dart';
import 'pages/AboutPage.dart';

final Map<String, WidgetBuilder> ROUTES = {
  "/": (c) => MainPage(),
  '/favorites':(c)=>FavoritesPage(),
  '/play':(c)=>PlayPage(),
  '/about':(c)=>AboutPage(),
  '/settings':(c)=>SettingsPage(),

};