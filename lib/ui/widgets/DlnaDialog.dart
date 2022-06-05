// ignore_for_file: file_names

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
  const DlnaDialog(this.dev, {Key? key, this.videoId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DlnaDialogState();
  }
}

class _DlnaDialogState extends State<DlnaDialog> {
  positionParser? position;
  TextEditingController videoUrl = TextEditingController();
  Timer timer = Timer(const Duration(seconds: 1), () {});

  @override
  void initState() {
    super.initState();
    callback(_) async {
      final text = await widget.dev.position();
      final p = positionParser(text);
      setState(() {
        position = p;
      });
    }

    timer = Timer.periodic(const Duration(seconds: 5), callback);
    callback(null);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dialog = ListView(
      children: [
        Container(
          alignment: Alignment.topCenter,
          child: Text(
            widget.dev.info.friendlyName,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.topCenter,
          child: Text(
            widget.dev.info.URLBase,
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
        ),
        SizedBox(
          height: 160,
          child: buildCurrUri(),
        ),
        buildActions(),
      ],
    );

    return SizedBox(
      height: 430,
      width: MediaQuery.of(context).size.width - 100,
      child: dialog,
    );
  }

  Widget buildCurrUri() {
    if (position == null || position!.TrackURI.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: const Text("暂无视频信息"),
      );
    }
    final List<Widget> slist = [];
    slist.add(const Align(
      alignment: Alignment.topLeft,
      child: Text(
        "当前播放:",
        style: TextStyle(color: Colors.green),
      ),
    ));
    var currUrl = position!.TrackURI;
    if (currUrl.length > 100) {
      currUrl = '${currUrl.substring(0, 100)}...';
    }
    slist.add(Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Align(
            alignment: Alignment.topLeft,
            child: InkWell(
              child: Text(
                currUrl,
                style: const TextStyle(fontSize: 12, color: Colors.orange),
                textAlign: TextAlign.left,
              ),
              onTap: () {
                ClipboardData data = ClipboardData(text: position!.TrackURI);
                Clipboard.setData(data);
                Toast.toast(context, "已复制");
              },
            ))));
    if (position!.AbsTime.isNotEmpty) {
      slist.add(Align(
        alignment: Alignment.topLeft,
        child: Text("${position!.AbsTime} / ${position!.TrackDuration}"),
      ));
    }
    return Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: Card(
          elevation: 1,
          color: Colors.white70,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: slist,
            ),
          ),
        ));
  }

  Widget buildActions() {
    const style = TextStyle(fontSize: 12);
    final ok = ElevatedButton(
      child: const Text("确认"),
      onPressed: () async {
        final v = videoUrl.value.text;
        if (v.isEmpty) {
          Toast.toast(context, "请输入http地址");
          return;
        }
        try {
          await widget.dev.setUrl(v);
          await widget.dev.play();
        } catch (e) {
          Toast.toast(context, "$e");
        }
        Navigator.pop(context);
        Timer(const Duration(seconds: 2), () async {
          final text = await widget.dev.position();
          position = positionParser(text);
        });
      },
    );
    final content = widget.videoId != null && widget.videoId!.isNotEmpty
        ? DlnaStreamItems(widget.dev, widget.videoId!)
        : Column(
            children: [
              TextField(
                  controller: videoUrl,
                  decoration: const InputDecoration(
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
      child: const Text("投屏"),
      onPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) => SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.fromLTRB(
                        10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
                    child: content),
              )),
    );
    final play = SizedBox(
        width: 60,
        height: 30,
        child: ElevatedButton(
          onPressed: () async {
            try {
              await widget.dev.play();
            } catch (e) {
              Toast.toast(context, "$e");
            }
          },
          child: const Text(
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
                await widget.dev.pause();
              } catch (e) {
                Toast.toast(context, "$e");
              }
            },
            child: const Text(
              "暂停",
              style: style,
            )));
    final stop = SizedBox(
        width: 60,
        height: 30,
        child: ElevatedButton(
            onPressed: () async {
              try {
                await widget.dev.stop();
              } catch (e) {
                Toast.toast(context, "$e");
              }
            },
            child: const Text("停止", style: style)));
    final prev10 = SizedBox(
        width: 90,
        height: 30,
        child: ElevatedButton(
            onPressed: () async {
              try {
                final curr = await widget.dev.position();
                final p = positionParser(curr);
                setState(() {
                  position = p;
                });
                widget.dev.seekByCurrent(curr, -10);
              } catch (e) {
                Toast.toast(context, "$e");
              }
            },
            child: const Text("快退10秒", style: style)));
    final next10 = SizedBox(
        width: 90,
        height: 30,
        child: ElevatedButton(
            onPressed: () async {
              try {
                final curr = await widget.dev.position();
                final p = positionParser(curr);
                setState(() {
                  position = p;
                });
                widget.dev.seekByCurrent(curr, 10);
              } catch (e) {
                Toast.toast(context, "$e");
              }
            },
            child: const Text("快进10秒", style: style)));

    final prev30 = SizedBox(
        width: 90,
        height: 30,
        child: ElevatedButton(
            onPressed: () async {
              try {
                final curr = await widget.dev.position();
                final p = positionParser(curr);
                setState(() {
                  position = p;
                });
                await widget.dev.seekByCurrent(curr, -30);
              } catch (e) {
                Toast.toast(context, "$e");
              }
            },
            child: const Text("快退30秒", style: style)));
    final next30 = SizedBox(
        width: 90,
        height: 30,
        child: ElevatedButton(
            onPressed: () async {
              try {
                final curr = await widget.dev.position();
                final p = positionParser(curr);
                setState(() {
                  position = p;
                });
                await widget.dev.seekByCurrent(curr, 30);
              } catch (e) {
                Toast.toast(context, "$e");
              }
            },
            child: const Text("快进30秒", style: style)));

    return Column(
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
    );
  }
}
