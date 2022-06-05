// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_app/ui/utils/toast.dart';
import 'package:flutter_app/utils/videoInfo.dart';
import '../../utils/dataHelper.dart';
import '../../api/index.dart';

class FavChannelList extends StatelessWidget {
  const FavChannelList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getFavCIds(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError) {
              final Set<String> ids = snapshot.data;
              if (ids.isEmpty) {
                return const Center(
                  child: Text("无数据"),
                );
              }
              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                children: ids.map((e) => buildItem(e)).toList(),
              );
            } else {
              return Center(
                child: TextButton(
                  child: const Text("加载失败"),
                  onPressed: () =>
                      {Toast.toast(context, snapshot.error.toString())},
                ),
              );
            }
          } else {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 40),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
        });
  }

  Widget buildItem(String id) {
    final Future refresh = api.channels(id);
    return FutureBuilder(
        future: refresh,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError) {
              return _body(context, snapshot.data);
            } else {
              return Center(
                child: TextButton(
                  child: const Text("加载失败"),
                  onPressed: () => {
                    {Toast.toast(context, snapshot.error.toString())},
                  },
                ),
              );
            }
          } else {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 40),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
        });
  }

  Widget _body(BuildContext context, dynamic res) {
    final item = res["items"][0];
    final String channelId = item["id"];
    final String title = getVideoTitle(item);
    final String pubTime = pubAt(item);
    final String desc = getVideoDesc(item);
    final String count = viewCount(item);
    final String subCount = getSubscriberCount(item);
    final String videoNum = getVideoCount(item);

    final cardItem = Card(
        elevation: 1,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    "创建于$pubTime",
                    style:
                        const TextStyle(fontSize: 13, color: Colors.grey, height: 1),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    count,
                    style:
                        const TextStyle(fontSize: 13, color: Colors.red, height: 1.5),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    subCount,
                    style: const TextStyle(
                        fontSize: 13, color: Colors.blue, height: 1.5),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    videoNum,
                    style: const TextStyle(
                        fontSize: 13, color: Colors.green, height: 1.5),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      desc,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    )),
              ),
            ],
          ),
        ));

    return InkWell(
        child: cardItem,
        onTap: () {
          Navigator.pushNamed(context, '/channel', arguments: channelId);
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("取消收藏"),
                content: Text(title),
                actions: [
                  TextButton(
                    onPressed: () {
                      delFavCIds(channelId);
                      Navigator.of(context).pop();
                    },
                    child: const Text("确认"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("取消"),
                  ),
                ],
              );
            },
          );
        });
  }
}
