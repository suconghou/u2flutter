import 'package:flutter/material.dart';
import '../../utils/videoInfo.dart';

Widget buildVideoItem(
  BuildContext context,
  dynamic item, {
  signle = false,
}) {
  String cover = videoCover(item);
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
      ? Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          child: SizedBox(
            height: 13,
            child: InkWell(
              child: Text(
                ctitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.blue, fontSize: 12, height: 1),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/channel', arguments: cid);
              },
            ),
          ),
        )
      : SizedBox(
          height: 5,
        );
  var titleWidget = Text(
    title,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
        height: 1.1,
        fontSize: 12,
        color: Colors.black,
        decoration: TextDecoration.none),
  );
  var titleBox = signle
      ? titleWidget
      : SizedBox(
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
          Center(
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

Widget buildListVideoItem(BuildContext context, dynamic item,
    {signle = false}) {
  return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/play',
          arguments: item,
        );
      },
      child: buildVideoItem(context, item, signle: signle));
}

Widget buildSignleVideoItem(BuildContext context, dynamic item) {
  var video = buildVideoItem(context, item, signle: true);
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/play", arguments: item);
          },
          child: video));
}

class VideoGridWidget extends StatelessWidget {
  final List list;
  bool grid;
  ScrollController controller;
  VideoGridWidget(this.list, {this.grid = true, this.controller});

  @override
  Widget build(BuildContext context) {
    if (!grid) {
      var children = list
          .map((item) => buildListVideoItem(
                context,
                item,
                signle: true,
              ))
          .toList();
      return Column(
        children: children,
      );
    }
    var children =
        list.map((item) => buildListVideoItem(context, item)).toList();
    return GridView.count(
      shrinkWrap:true,
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
