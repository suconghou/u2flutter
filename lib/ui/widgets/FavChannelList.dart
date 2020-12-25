import 'package:flutter/material.dart';
import 'package:flutter_app/utils/videoInfo.dart';
import '../../utils/dataHelper.dart';
import '../../api/index.dart';

class FavChannelList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var ids = getFavCIds();
    ids = {"UCAWnuGH5fKJKM-DiWrdbgJA"};
    if (ids.length < 1) {
      return Center(
        child: Text("无数据"),
      );
    }
    return ListView(
      children: ids.map((e) => buildItem(e)).toList(),
    );
  }

  Widget buildItem(String id) {
    final Future _refresh = api.channels(id);
    return FutureBuilder(
        future: _refresh,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError) {
              return _body(context, snapshot.data);
            } else {
              return Center(
                child: FlatButton(
                  child: Text("加载失败"),
                  onPressed: () => {},
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
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
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    "创建于" + pubTime,
                    style:
                        TextStyle(fontSize: 13, color: Colors.grey, height: 1),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    count,
                    style:
                        TextStyle(fontSize: 13, color: Colors.red, height: 1),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    subCount,
                    style:
                        TextStyle(fontSize: 13, color: Colors.blue, height: 1),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    videoNum,
                    style:
                        TextStyle(fontSize: 13, color: Colors.green, height: 1),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  desc,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
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
              return new AlertDialog(
                title: Text("取消收藏"),
                content: Text(title),
                actions: [
                  new FlatButton(
                    onPressed: () {
                      delFavCIds(channelId);
                      Navigator.of(context).pop();
                    },
                    child: Text("确认"),
                  ),
                  new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("取消"),
                  ),
                ],
              );
            },
          );
        });
  }
}
