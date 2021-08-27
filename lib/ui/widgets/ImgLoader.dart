import 'package:flutter/material.dart';

const _placeholder = "images/loading.gif";

FadeInImage imgShow(String cover, String cover2) {
  final errimg = Image.asset(
    "images/error.jpg",
    fit: BoxFit.cover,
    width: 1080,
  );

  final imgCover = FadeInImage.assetNetwork(
    image: cover,
    width: 1080,
    placeholder: _placeholder,
    placeholderScale: 3,
    fit: BoxFit.cover,
    placeholderErrorBuilder: (c, obj, err) {
      print(obj);
      print(err);
      return errimg;
    },
    imageErrorBuilder: (c, obj, err) {
      print(obj);
      print(err);
      return FadeInImage.assetNetwork(
          placeholder: _placeholder,
          image: cover2,
          width: 1080,
          placeholderScale: 3,
          fit: BoxFit.cover,
          imageErrorBuilder: (c, obj, err) {
            return errimg;
          });
    },
  );
  return imgCover;
}
