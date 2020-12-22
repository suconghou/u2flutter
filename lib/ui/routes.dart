import 'package:flutter/material.dart';
import 'pages/MainPage.dart';
import 'pages/FavoritesPage.dart';
import 'pages/PlayPage.dart';
import 'pages/SettingsPage.dart';
import 'pages/AboutPage.dart';
import 'pages/DownloadPage.dart';
import 'pages/ChannelPage.dart';

final Map<String, WidgetBuilder> routes = {
  "/": (c) => MainPage(),
  '/favorites': (c) => FavoritesPage(),
  '/download': (c) => DownloadPage(),
  '/channel':(c)=>ChannelPage(),
  '/play': (c) => PlayPage(),
  '/about': (c) => AboutPage(),
  '/settings': (c) => SettingsPage(),
};
