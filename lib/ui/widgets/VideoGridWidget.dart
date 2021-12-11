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
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            child: SizedBox(
              height: 13,
              child: Text(
                ctitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.blue, fontSize: 12, height: 1),
              ),
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/channel', arguments: cid);
          },
        )
      : SizedBox(
          height: 5,
        );
  final titleWidget = Text(
    title,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
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
    padding: EdgeInsets.all(0),
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
                    margin: EdgeInsets.all(2),
                    color: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(dur,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        )),
                  ),
                ),
        ]),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: titleBox),
        cc,
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            children: <Widget>[
              Text(
                pubTime,
                style: TextStyle(
                  fontSize: 12,
                  height: 1,
                  color: Colors.black87,
                  decoration: TextDecoration.none,
                ),
              ),
              Expanded(child: Container()),
              Text(count,
                  style: TextStyle(
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
    style: TextStyle(
        height: 1.1,
        fontSize: 12,
        color: Colors.black,
        decoration: TextDecoration.none),
  );

  final right = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(height: 56, child: titleBox),
      Container(
          height: 16,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/channel', arguments: cid);
            },
            child: Text(
              ctitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.blue, fontSize: 12, height: 1),
            ),
          )),
      Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(right: 5),
        child: Row(
          children: <Widget>[
            Text(
              pubTime,
              style: TextStyle(
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
                    style: TextStyle(
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
    margin: EdgeInsets.symmetric(vertical: 4),
    padding: EdgeInsets.all(0),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: imgShow(cover, cover2),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.only(left: 2, top: 8),
            child: right,
            height: 100,
          ),
        ),
      ],
    ),
  );
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/play", arguments: item);
          },
          child: cardItem));
}

class VideoGridWidget extends StatelessWidget {
  final List list;
  final ScrollController? controller;
  VideoGridWidget(this.list, {this.controller});

  @override
  Widget build(BuildContext context) {
    final children =
        list.map((item) => buildListVideoItem(context, item)).toList();
    return GridView.count(
      shrinkWrap: true,
      padding: EdgeInsets.all(10),
      crossAxisCount: 2,
      mainAxisSpacing: 0,
      crossAxisSpacing: 10,
      childAspectRatio: 0.98,
      children: children,
      controller: controller,
    );
  }
}
