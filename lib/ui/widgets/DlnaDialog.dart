import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dlna_dart/dlna.dart';
import 'package:dlna_dart/xmlParser.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/ui/utils/toast.dart';
import './DlnaStreamItems.dart';

class DlnaDialog extends StatefulWidget {
  final device dev;
  final String? videoId;
  DlnaDialog(this.dev, {this.videoId});

  @override
  State<StatefulWidget> createState() {
    return DlnaDialogState(dev, videoId: videoId);
  }
}

class DlnaDialogState extends State {
  final device dev;
  positionParser? position;
  TextEditingController videoUrl = TextEditingController();
  Timer timer = Timer(Duration(seconds: 1), () {});
  final String? videoId;
  DlnaDialogState(this.dev, {this.videoId}) {
    final callback = (_) async {
      final text = await dev.position();
      final p = positionParser(text);
      setState(() {
        position = p;
      });
    };
    timer = Timer.periodic(Duration(seconds: 5), callback);
    callback(null);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dialog = Container(
        child: ListView(
      children: [
        Container(
          alignment: Alignment.topCenter,
          child: Text(
            dev.info.friendlyName,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: Text(
            dev.info.URLBase,
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
        ),
        SizedBox(
          height: 160,
          child: buildCurrUri(),
        ),
        buildActions(),
      ],
    ));

    return SizedBox(
      child: dialog,
      height: 430,
      width: MediaQuery.of(context).size.width - 100,
    );
  }

  Widget buildCurrUri() {
    if (position == null || position!.TrackURI.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: Text("暂无视频信息"),
      );
    }
    final List<Widget> slist = [];
    slist.add(Align(
      alignment: Alignment.topLeft,
      child: Text(
        "当前播放:",
        style: TextStyle(color: Colors.green),
      ),
    ));
    var currUrl = position!.TrackURI;
    if (currUrl.length > 100) {
      currUrl = currUrl.substring(0, 100) + '...';
    }
    slist.add(Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Align(
            alignment: Alignment.topLeft,
            child: InkWell(
              child: Text(
                currUrl,
                style: TextStyle(fontSize: 12, color: Colors.orange),
                textAlign: TextAlign.left,
              ),
              onTap: () {
                ClipboardData data = ClipboardData(text: position!.TrackURI);
                Clipboard.setData(data);
                Toast.toast(context, "已复制");
              },
            ))));
    if (position!.AbsTime.isNotEmpty) {
      slist.add(Container(
        child: Align(
          child: Text(position!.AbsTime + " / " + position!.TrackDuration),
          alignment: Alignment.topLeft,
        ),
      ));
    }
    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(10),
        child: Card(
          elevation: 1,
          color: Colors.white70,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: slist,
            ),
          ),
        ));
  }

  Widget buildActions() {
    final style = TextStyle(fontSize: 12);
    final ok = ElevatedButton(
      child: Text("确认"),
      onPressed: () async {
        final v = videoUrl.value.text;
        if (v.isEmpty) {
          Toast.toast(context, "请输入http地址");
          return;
        }
        try {
          await dev.setUrl(v);
          await dev.play();
        } catch (e) {
          Toast.toast(context, "$e");
        }
        Navigator.pop(context);
        Timer(Duration(seconds: 2), () async {
          final text = await dev.position();
          position = positionParser(text);
        });
      },
    );
    final content = videoId != null && videoId!.isNotEmpty
        ? DlnaStreamItems(dev, videoId!)
        : Column(
            children: [
              TextField(
                  controller: videoUrl,
                  decoration: InputDecoration(
                    icon: Icon(Icons.link),
                    labelText: "http地址",
                  )),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [ok],
              ),
            ],
          );
    final push = ElevatedButton(
      child: Text("投屏"),
      onPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) => SingleChildScrollView(
                child: Container(
                    child: content,
                    padding: EdgeInsets.fromLTRB(
                        10, 10, 10, MediaQuery.of(context).viewInsets.bottom)),
              )),
    );
    final play = SizedBox(
        width: 60,
        height: 30,
        child: ElevatedButton(
          onPressed: () async {
            try {
              await dev.play();
            } catch (e) {
              Toast.toast(context, "$e");
            }
          },
          child: Text(
            "播放",
            style: style,
          ),
        ));
    final pause = SizedBox(
        width: 60,
        height: 30,
        child: ElevatedButton(
            onPressed: () async {
              try {
                await dev.pause();
              } catch (e) {
                Toast.toast(context, "$e");
              }
            },
            child: Text(
              "暂停",
              style: style,
            )));
    final stop = SizedBox(
        width: 60,
        height: 30,
        child: ElevatedButton(
            onPressed: () async {
              try {
                await dev.stop();
              } catch (e) {
                Toast.toast(context, "$e");
              }
            },
            child: Text("停止", style: style)));
    final prev10 = SizedBox(
        width: 90,
        height: 30,
        child: ElevatedButton(
            onPressed: () async {
              try {
                final curr = await dev.position();
                final p = positionParser(curr);
                setState(() {
                  position = p;
                });
                dev.seekByCurrent(curr, -10);
              } catch (e) {
                Toast.toast(context, "$e");
              }
            },
            child: Text("快退10秒", style: style)));
    final next10 = SizedBox(
        width: 90,
        height: 30,
        child: ElevatedButton(
            onPressed: () async {
              try {
                final curr = await dev.position();
                final p = positionParser(curr);
                setState(() {
                  position = p;
                });
                dev.seekByCurrent(curr, 10);
              } catch (e) {
                Toast.toast(context, "$e");
              }
            },
            child: Text("快进10秒", style: style)));

    final prev30 = SizedBox(
        width: 90,
        height: 30,
        child: ElevatedButton(
            onPressed: () async {
              try {
                final curr = await dev.position();
                final p = positionParser(curr);
                setState(() {
                  position = p;
                });
                await dev.seekByCurrent(curr, -30);
              } catch (e) {
                Toast.toast(context, "$e");
              }
            },
            child: Text("快退30秒", style: style)));
    final next30 = SizedBox(
        width: 90,
        height: 30,
        child: ElevatedButton(
            onPressed: () async {
              try {
                final curr = await dev.position();
                final p = positionParser(curr);
                setState(() {
                  position = p;
                });
                await dev.seekByCurrent(curr, 30);
              } catch (e) {
                Toast.toast(context, "$e");
              }
            },
            child: Text("快进30秒", style: style)));

    return Container(
      child: Column(
        children: [
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              push,
            ],
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              play,
              pause,
              stop,
            ],
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [next10, prev10],
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [next30, prev30],
          ),
        ],
      ),
    );
  }
}
