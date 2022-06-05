// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../utils/videoInfo.dart';
import 'ImgLoader.dart';

Widget buildVideoItem(BuildContext context, dynamic item) {
  String cover = videoCover(item);
  String cover2 = videoCover2(item);
  String title = getVideoTitle(item);
  String count = viewCount(item);
  String pubTime = pubAt(item);
  String dur = duration(item);
  String cid = getChannelId(item);
  String ctitle = getChannelTitle(item);
  if (title.isEmpty || cover.isEmpty) {
    return Container();
  }
  final cc = (cid.isNotEmpty && ctitle.isNotEmpty)
      ? InkWell(
          child: Container(
            padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
            child: SizedBox(
              height: 18,
              child: Text(
                ctitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.blue, fontSize: 12, height: 1),
              ),
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/channel', arguments: cid);
          },
        )
      : const SizedBox(
          height: 5,
        );
  final titleWidget = Text(
    title,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(
        height: 1.1,
        fontSize: 12,
        color: Colors.black,
        decoration: TextDecoration.none),
  );
  final titleBox = SizedBox(
    height: 26,
    child: titleWidget,
  );

  return Container(
    color: Colors.white,
    padding: const EdgeInsets.all(0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(children: [
          Center(child: imgShow(cover, cover2)),
          dur.isEmpty
              ? Container()
              : Positioned(
                  bottom: 3,
                  right: 3,
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    color: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(dur,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        )),
                  ),
                ),
        ]),
        Container(margin: const EdgeInsets.fromLTRB(5, 5, 5, 0), child: titleBox),
        cc,
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
          child: Row(
            children: <Widget>[
              Text(
                pubTime,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1,
                  color: Colors.black87,
                  decoration: TextDecoration.none,
                ),
              ),
              Expanded(child: Container()),
              Text(count,
                  style: const TextStyle(
                      fontSize: 12,
                      height: 1,
                      color: Colors.grey,
                      decoration: TextDecoration.none))
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildListVideoItem(BuildContext context, dynamic item) {
  return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/play',
          arguments: item,
        );
      },
      child: buildVideoItem(context, item));
}

Widget buildSignleVideoItem(BuildContext context, dynamic item) {
  String cover = videoCover(item);
  String cover2 = videoCover2(item);
  String title = getVideoTitle(item);
  String pubTime = pubAt(item);
  String cid = getChannelId(item);
  String ctitle = getChannelTitle(item);
  String count = viewCount(item);

  if (title.isEmpty || cover.isEmpty) {
    return Container();
  }
  final titleBox = Text(
    title,
    maxLines: 4,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(
        height: 1.1,
        fontSize: 12,
        color: Colors.black,
        decoration: TextDecoration.none),
  );

  final right = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
          height: 54, padding: const EdgeInsets.only(right: 4), child: titleBox),
      Container(
          padding: const EdgeInsets.only(
            top: 4,
          ),
          height: 22,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/channel', arguments: cid);
            },
            child: Text(
              ctitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.blue, fontSize: 12, height: 1),
            ),
          )),
      Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(right: 5),
        child: Row(
          children: <Widget>[
            Text(
              pubTime,
              style: const TextStyle(
                fontSize: 12,
                height: 1,
                color: Colors.black87,
                decoration: TextDecoration.none,
              ),
            ),
            count.isEmpty ? Container() : Expanded(child: Container()),
            count.isEmpty
                ? Container()
                : Text(count,
                    style: const TextStyle(
                        fontSize: 12,
                        height: 1,
                        color: Colors.grey,
                        decoration: TextDecoration.none))
          ],
        ),
      ),
    ],
  );
  final cardItem = Container(
    color: Colors.white,
    margin: const EdgeInsets.symmetric(vertical: 4),
    padding: const EdgeInsets.all(0),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: imgShow(cover, cover2),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.only(top: 6),
            height: 100,
            child: right,
          ),
        ),
      ],
    ),
  );
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/play", arguments: item);
          },
          child: cardItem));
}

class VideoGridWidget extends StatelessWidget {
  final List list;
  final ScrollController? controller;
  const VideoGridWidget(this.list, {Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children =
        list.map((item) => buildListVideoItem(context, item)).toList();
    return GridView.count(
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      crossAxisCount: 2,
      mainAxisSpacing: 0,
      crossAxisSpacing: 10,
      childAspectRatio: 0.98,
      controller: controller,
      children: children,
    );
  }
}
