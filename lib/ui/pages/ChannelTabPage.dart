// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_app/utils/videoInfo.dart';
import '../widgets/ChannelTabView.dart';

class ChannelTabPage extends StatelessWidget {
  final dynamic item;

  final tabTitle = ['上传的', '收藏的', '播放列表'];
  ChannelTabPage(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final String channelId = item["id"];
    final String title = getVideoTitle(item);
    final String pubTime = pubAt(item);
    final String desc = getVideoDesc(item);
    final String count = viewCount(item);
    final String subCount = getSubscriberCount(item);
    final String videoNum = getVideoCount(item);

    final String uploadId = getChannelUploadId(item);
    final String favId = getChannelFavoriteId(item);

    Widget uploadList = uploadId.isNotEmpty
        ? ChannelTabView(ChannelTab.upload, uploadId)
        : const Center(child: Text("无数据"));
    Widget favList = favId.isNotEmpty
        ? ChannelTabView(ChannelTab.favorite, favId)
        : const Center(child: Text("无数据"));

    final infoBox = Drawer(
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40, bottom: 20),
            child: SizedBox(
              height: 40,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: ListBody(
              children: [
                Text("创建于$pubTime", style: const TextStyle(fontSize: 14)),
                Row(
                  children: [
                    Text(
                      count,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                    Text(
                      subCount,
                      style: const TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                    Text(
                      videoNum,
                      style: const TextStyle(color: Colors.green, fontSize: 14),
                    ),
                  ],
                ),
                Text(desc, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );

    return DefaultTabController(
      length: tabTitle.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: TabBar(tabs: tabTitle.map((f) => Tab(text: f)).toList()),
        ),
        endDrawer: infoBox,
        body: TabBarView(
          children: [
            uploadList,
            favList,
            ChannelTabView(ChannelTab.playlist, channelId),
          ],
        ),
      ),
    );
  }
}
