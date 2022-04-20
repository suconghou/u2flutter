import 'package:flutter/material.dart';
import 'pages/MainPage.dart';
import 'pages/FavoritesPage.dart';
import 'pages/PlayPage.dart';
import 'pages/PlayerPage.dart';
import 'pages/SettingsPage.dart';
import 'pages/AboutPage.dart';
import 'pages/SharePage.dart';
import 'pages/ChannelPage.dart';
import 'pages/CListVideos.dart';

final Map<String, WidgetBuilder> routes = {
  "/": (c) => const MainPage(),
  '/favorites': (c) => const FavoritesPage(),
  '/share': (c) => const SharePage(),
  '/channel': (c) => ChannelPage(),
  '/listvideos': (c) => const CListVideos(),
  '/play': (c) => PlayPage(),
  '/player': (c) => const PlayerPage(),
  '/about': (c) => const AboutPage(),
  '/settings': (c) => const SettingsPage(),
};
