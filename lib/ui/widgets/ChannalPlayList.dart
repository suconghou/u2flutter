// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../utils/videoInfo.dart';
import 'ImgLoader.dart';

class ChannelPlayList extends StatelessWidget {
  final List list;
  final ScrollController controller;
  const ChannelPlayList(this.list, {Key? key, required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      children: list.map((e) => buildItem(context, e)).toList(),
      controller: controller,
    );
  }

  Widget buildItem(BuildContext context, item) {
    String cover = videoCover(item);
    String cover2 = videoCover2(item);
    String title = getVideoTitle(item);
    String count = viewCount(item);
    String pubTime = pubAt(item);
    String desc = getVideoDesc(item);
    // String cid = getChannelId(item);
    if (title.isEmpty || cover.isEmpty) {
      return Container();
    }
    final titleBox = Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
          height: 1.1,
          fontSize: 14,
          color: Colors.black,
          decoration: TextDecoration.none),
    );
    final descBox = Text(
      desc,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
          height: 1.18,
          fontSize: 11,
          color: Colors.grey,
          decoration: TextDecoration.none),
    );

    final right = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 30, child: titleBox),
        Container(margin: const EdgeInsets.only(top: 3), height: 43, child: descBox),
        Container(
          alignment: Alignment.center,
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
              padding: const EdgeInsets.only(left: 2, top: 8),
              child: right,
              height: 100,
            ),
          ),
        ],
      ),
    );
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/listvideos',
          arguments: item,
        );
      },
      child: cardItem,
    );
  }
}
