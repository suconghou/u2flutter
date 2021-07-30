import 'package:flutter/material.dart';
import '../widgets/DlnaDeviceList.dart';

class SharePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("投屏助手"),
      ),
      body: Container(
        child: DlnaDiviceList(),
        margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
      ),
    );
  }
}
