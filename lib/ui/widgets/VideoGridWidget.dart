import 'package:flutter/material.dart';
import '../../utils/cover.dart';

Widget buildVideoItem(BuildContext context, dynamic item) {
  String cover = videoCover(item);
  String title = item["snippet"]["title"];
  return Container(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Image.network(cover, fit: BoxFit.cover, width: 1080, loadingBuilder:
            (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        }),
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
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                      text: "一周前"),
                  TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                      text: "78s")
                ]),
              ),
              Expanded(child: Container()),
              Text("54万观看",
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
        Navigator.pushNamed(context, '/play', arguments: "1234ID");
      },
      child: buildVideoItem(context, item));
}

Widget buildIndexVideoItem(BuildContext context, dynamic item) {
  var video = buildVideoItem(context, item);
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/play", arguments: "detail");
          },
          child: video));
}

class VideoGridWidget extends StatelessWidget {
  final List list;
  VideoGridWidget(this.list);

  @override
  Widget build(BuildContext context) {
    var children =
        list.map((item) => buildListVideoItem(context, item)).toList();
    return GridView.extent(
      padding: EdgeInsets.all(10),
      maxCrossAxisExtent: 240,
      mainAxisSpacing: 0,
      crossAxisSpacing: 10,
      childAspectRatio: 1,
      children: children,
    );
  }
}
