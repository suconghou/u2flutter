import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dlna_dart/dlna.dart';
import './DlnaDialog.dart';
import '../utils/toast.dart';

Map<String, device> cacheDeviceList = Map();

class DlnaDeviceList extends StatefulWidget {
  final String? videoId;
  DlnaDeviceList({this.videoId});

  @override
  State<StatefulWidget> createState() {
    return DlnaDeviceListState(videoId: videoId);
  }
}

class DlnaDeviceListState extends State {
  bool started = false;
  late search searcher;
  late final manager m;
  Timer timer = Timer(Duration(seconds: 1), () {});
  Map<String, device> deviceList = Map();
  final String? videoId;
  DlnaDeviceListState({this.videoId});

  @override
  initState() {
    super.initState();
    searcher = search();
    init();
  }

  init() async {
    m = await searcher.start();
    started = true;
    timer.cancel();
    final callback = (timer) {
      m.deviceList.forEach((key, value) {
        cacheDeviceList[key] = value;
      });
      setState(() {
        deviceList = cacheDeviceList;
      });
    };
    timer = Timer.periodic(Duration(seconds: 5), callback);
    callback(null);
  }

  @override
  void dispose() {
    timer.cancel();
    searcher.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return deviceList.length == 0
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(onRefresh: _pullToRefresh, child: _body());
  }

  Future _pullToRefresh() async {
    m.deviceList.forEach((key, value) {
      cacheDeviceList[key] = value;
    });
    setState(() {
      deviceList = cacheDeviceList;
    });
  }

  Widget _body() {
    if (deviceList.length < 0) {
      return SizedBox(
        height: 200,
        child: CircularProgressIndicator(),
      );
    }
    final List<Widget> dlist = [];
    deviceList.forEach((uri, device) {
      dlist.add(buildItem(uri, device));
    });

    return ListView(
      children: dlist,
    );
  }

  Widget buildItem(String uri, device device) {
    final title = device.info.friendlyName;
    final subtitle = uri + '\r\n' + device.info.deviceType;
    var icon = Icons.wifi;
    final router = subtitle.toLowerCase().contains("gateway");
    if (router) {
      icon = Icons.router;
    }
    final card = Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 16,
              left: 16,
              bottom: 30,
            ),
            child: CircleAvatar(
              child: Icon(icon),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 100, 100, 135),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 8,
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          subtitle,
                          softWrap: false,
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 100, 100, 135),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]));

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: InkWell(
        child: card,
        onTap: () {
          if (router) {
            final msg = "路由设备不支持投屏";
            Toast.toast(context, msg);
            return;
          }
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  children: [
                    DlnaDialog(
                      device,
                      videoId: videoId,
                    )
                  ],
                );
              });
        },
      ),
    );
  }
}
