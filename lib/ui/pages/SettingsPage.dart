import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("系统设置"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
          children: [
            TextField(
                decoration:InputDecoration(
                  icon: Icon(Icons.api),
                  labelText: "内容API服务"
                )
            ),
            TextField(
                decoration:InputDecoration(
                    icon: Icon(Icons.analytics),
                    labelText: "视频解析服务"
                )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 40),
              height: 40,
              child: RaisedButton(
                child: Text("保存"),
                textColor: Colors.white,
                color: Colors.blue[500],
                elevation: 5,
                onPressed: (){
                },
              ),
            )

          ],
      ),
    );
  }
}
