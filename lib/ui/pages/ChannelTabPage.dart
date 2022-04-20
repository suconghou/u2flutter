// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_app/utils/videoInfo.dart';
import '../widgets/ChannelTabView.dart';

class ChannelTabPage extends StatelessWidget {
  final dynamic item;

  final tabTitle = [
    '上传的',
    '收藏的',
    '播放列表',
  ];
  ChannelTabPage(this.item, {Key? key}) : super(key: key);

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
        : const Center(
            child: Text("无数据"),
          );
    Widget favList = favId.isNotEmpty
        ? ChannelTabView(ChannelTab.favorite, favId)
        : const Center(
            child: Text("无数据"),
          );

    return DefaultTabController(
      length: tabTitle.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: TabBar(
            tabs: tabTitle.map((f) => Tab(text: f)).toList(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        contentPadding: const EdgeInsets.all(10),
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 1),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("创建于" + pubTime,
                                        style: const TextStyle(fontSize: 14)),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      count,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 14),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      subCount,
                                      style: const TextStyle(
                                          color: Colors.blue, fontSize: 14),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(videoNum,
                                        style: const TextStyle(
                                            color: Colors.green, fontSize: 14)),
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        desc,
                                        style: const TextStyle(fontSize: 14),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              },
            )
          ],
        ),
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
