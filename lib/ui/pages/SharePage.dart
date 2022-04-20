// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../widgets/DlnaDeviceList.dart';

class SharePage extends StatelessWidget {
  const SharePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("投屏助手"),
      ),
      body: Container(
        child: const DlnaDeviceList(),
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      ),
    );
  }
}
