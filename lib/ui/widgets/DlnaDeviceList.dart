// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dlna_dart/dlna.dart';
import './DlnaDialog.dart';
import '../utils/toast.dart';

Map<String, DLNADevice> cacheDeviceList = {};

class DlnaDeviceList extends StatefulWidget {
  final String? videoId;
  const DlnaDeviceList({Key? key, this.videoId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DlnaDeviceListState();
  }
}

class _DlnaDeviceListState extends State<DlnaDeviceList> {
  late DLNAManager searcher;
  late final DeviceManager m;
  Map<String, DLNADevice> deviceList = {};
  _DlnaDeviceListState();

  @override
  initState() {
    super.initState();
    searcher = DLNAManager();
    init();
  }

  init() async {
    m = await searcher.start();
    m.devices.stream.listen((dlist) {
      dlist.forEach((key, value) {
        cacheDeviceList[key] = value;
      });
      setState(() {
        deviceList = cacheDeviceList;
      });
    });
    await _pullToRefresh();
  }

  @override
  void dispose() {
    searcher.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(onRefresh: _pullToRefresh, child: _body());
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
    if (deviceList.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    final List<Widget> dlist = [];
    deviceList.forEach((uri, devi) {
      dlist.add(buildItem(uri, devi));
    });

    return ListView(
      children: dlist,
    );
  }

  Widget buildItem(String uri, DLNADevice device) {
    final title = device.info.friendlyName;
    final subtitle = '$uri\r\n${device.info.deviceType}';
    final s = subtitle.toLowerCase();
    var icon = Icons.wifi;
    final support = s.contains("mediarenderer") ||
        s.contains("avtransport") ||
        s.contains('mediaserver');
    if (!support) {
      icon = Icons.router;
    }
    final card = Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
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
                  margin: const EdgeInsets.only(left: 16),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 100, 100, 135),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
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
                          style: const TextStyle(
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
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        child: card,
        onTap: () {
          if (!support) {
            const msg = "该设备不支持投屏";
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
                      videoId: widget.videoId,
                    )
                  ],
                );
              });
        },
      ),
    );
  }
}
