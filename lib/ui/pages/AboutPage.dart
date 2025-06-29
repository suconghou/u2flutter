// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("关于应用")),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        children: [
          buildText(
            "本项目为\r\nU2WEB(https://github.com/suconghou/u2web)\r\n的Flutter版",
          ),
          buildText("开源地址:\r\nhttps://github.com/suconghou/u2flutter"),
          buildText("本项目仅作为学习使用,切勿用作其他用途\r\n如果你觉得有用,请Star"),
        ],
      ),
    );
  }

  Widget buildText(String text) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
