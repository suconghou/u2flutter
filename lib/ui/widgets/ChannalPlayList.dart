import 'package:flutter/material.dart';
import '../../utils/videoInfo.dart';

class ChannelPlayList extends StatelessWidget {
  final List list;
  final ScrollController controller;
  ChannelPlayList(this.list, {required this.controller});
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(10),
      children: list.map((e) => buildItem(context, e)).toList(),
      controller: controller,
    );
  }

  Widget buildItem(BuildContext context, item) {
    String cover = videoCover(item);
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
      style: TextStyle(
          height: 1.1,
          fontSize: 14,
          color: Colors.black,
          decoration: TextDecoration.none),
    );
    final descBox = Text(
      desc,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          height: 1.18,
          fontSize: 11,
          color: Colors.grey,
          decoration: TextDecoration.none),
    );

    var right = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(height: 30, child: titleBox),
        Container(margin: EdgeInsets.only(top: 3), height: 43, child: descBox),
        Container(
          alignment: Alignment.center,
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
              child: FadeInImage.assetNetwork(
                image: cover,
                width: 1080,
                placeholder: "images/loading.gif",
                placeholderScale: 3,
                fit: BoxFit.cover,
                placeholderErrorBuilder: (c, obj, err) {
                  print(obj);
                  print(err);
                  return Image.asset(
                    "images/error.jpg",
                    fit: BoxFit.cover,
                    width: 1080,
                  );
                },
                imageErrorBuilder: (c, obj, err) {
                  print(obj);
                  print(err);
                  return Image.asset(
                    "images/error.jpg",
                    fit: BoxFit.cover,
                    width: 1080,
                  );
                },
              ),
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
