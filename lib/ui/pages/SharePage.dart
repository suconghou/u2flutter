// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../widgets/DlnaDeviceList.dart';

class SharePage extends StatelessWidget {
  const SharePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("投屏助手")),
      body: Container(
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: const DlnaDeviceList(),
      ),
    );
  }
}
