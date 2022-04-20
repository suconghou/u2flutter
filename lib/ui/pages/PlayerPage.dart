// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/ui/utils/toast.dart';
import '../widgets/VideoStreamPlayer.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerPageState();
  }
}

class _PlayerPageState extends State {
  String url = "";
  double ratio = 1.7777;
  TextEditingController urlController = TextEditingController();
  final List<String> urls = [];
  @override
  Widget build(BuildContext context) {
    final full = MediaQuery.of(context).orientation == Orientation.landscape;
    final player = _buildPlayer(url);
    final page = Scaffold(
      appBar: AppBar(
        title: const Text("播放器"),
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: ratio,
            child: player,
          ),
          Container(
            margin: const EdgeInsets.all(5),
            child: Row(
              children: [
                const Text(
                  "比例:",
                  style: TextStyle(fontSize: 14),
                ),
                ButtonBar(
                  children: [
                    TextButton(
                      child: const Text("4:3"),
                      onPressed: () {
                        setState(() {
                          ratio = 4 / 3;
                        });
                      },
                    ),
                    TextButton(
                      child: const Text("16:9"),
                      onPressed: () {
                        setState(() {
                          ratio = 16 / 9;
                        });
                      },
                    ),
                    TextButton(
                      child: const Text("16:10"),
                      onPressed: () {
                        setState(() {
                          ratio = 16 / 10;
                        });
                      },
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                TextField(
                    controller: urlController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.web),
                      labelText: "URL",
                    )),
                ElevatedButton(
                    child: const Text("加载"),
                    onPressed: () {
                      setState(() {
                        final u = urlController.value.text.trim();
                        if (u.isEmpty) {
                          Toast.toast(context, "请输入正确的URL");
                          return;
                        }
                        if (url == u) {
                          setState(() {
                            url = "";
                          });
                        }
                        urls.remove(u);
                        urls.add(u);
                        urlController.value = TextEditingValue.empty;
                        Timer(const Duration(milliseconds: 80), () {
                          setState(() {
                            url = u;
                          });
                        });
                      });
                    })
              ],
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.all(5),
            height: 500,
            child: ListView(
              children: urls
                  .map((e) => InkWell(
                        child: Container(
                          padding: const EdgeInsets.only(top: 6, bottom: 6, right: 3),
                          child: Text(
                            e,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        onTap: () {
                          urlController.value = TextEditingValue(text: e);
                          ClipboardData data = ClipboardData(text: e);
                          Clipboard.setData(data);
                          Toast.toast(context, "已复制");
                        },
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );

    return full
        ? Scaffold(
            body: Stack(fit: StackFit.expand, children: <Widget>[
            player,
          ]))
        : page;
  }

  Widget _buildPlayer(String url) {
    if (url.isEmpty) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            "无播放资源",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    return VideoStreamPlayer(url, "");
  }
}
