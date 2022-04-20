// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_app/api/index.dart';
import 'package:flutter_app/ui/utils/toast.dart';
import '../../utils/store.dart';

const _videoUrlKey = 'videourl';
const _baseUrlKey = 'baseurl';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController videoUrl = TextEditingController();
    TextEditingController baseUrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("系统设置"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        children: [
          const Text("配置为空,则使用系统默认值"),
          TextField(
              controller: baseUrl,
              decoration: const InputDecoration(
                icon: Icon(Icons.api),
                labelText: "内容API服务",
              )),
          TextField(
              controller: videoUrl,
              decoration: const InputDecoration(
                icon: Icon(Icons.analytics),
                labelText: "视频解析服务",
              )),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 40),
            height: 40,
            child: ElevatedButton(
              child: const Text("保存"),
              onPressed: () async {
                if (baseUrl.value.text.isEmpty) {
                  await Store.remove(_baseUrlKey);
                } else {
                  await Store.setString(_baseUrlKey, baseUrl.value.text);
                }
                if (videoUrl.value.text.isEmpty) {
                  await Store.remove(_videoUrlKey);
                } else {
                  await Store.setString(_videoUrlKey, videoUrl.value.text);
                }
                Toast.toast(context, "保存成功");
                await api.initBaseUrl();
              },
            ),
          )
        ],
      ),
    );
  }
}
