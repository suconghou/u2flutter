import 'package:flutter/material.dart';
import '../../utils/videoInfo.dart';

Widget buildVideoItem(BuildContext context, dynamic item) {
  String cover = videoCover(item);
  String title = getVideoTitle(item);
  String count = viewCount(item);
  String pubTime = pubAt(item);
  String dur = duration(item);
  return Container(
    color: Colors.white,
    padding: EdgeInsets.symmetric( vertical: 5),
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
            ),
          ),
          dur.isEmpty
              ? Container()
              : Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    margin: EdgeInsets.all(2),
                    color: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(dur,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        )),
                  ),
                ),
        ]),
        SizedBox(
          height: 4,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                decoration: TextDecoration.none),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: <Widget>[
              Text(
                pubTime,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  decoration: TextDecoration.none,
                ),
              ),
              Expanded(child: Container()),
              Text(count,
                  style: TextStyle(
                      fontSize: 14,
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
        Navigator.pushNamed(context, '/play', arguments: item);
      },
      child: buildVideoItem(context, item));
}

Widget buildIndexVideoItem(BuildContext context, dynamic item) {
  var video = buildVideoItem(context, item);
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
  VideoGridWidget(this.list, {this.grid = true});

  @override
  Widget build(BuildContext context) {
    var children =
        list.map((item) => buildListVideoItem(context, item)).toList();
    if (!grid) {
      return Column(
        children: children,
      );
    }
    return GridView.count(
      padding: EdgeInsets.all(10),
      crossAxisCount: 2,
      mainAxisSpacing: 0,
      crossAxisSpacing: 10,
      childAspectRatio: 1,
      children: children,
    );
  }
}
