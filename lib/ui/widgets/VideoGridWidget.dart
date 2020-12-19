import 'package:flutter/material.dart';

class VideoGridWidget extends StatelessWidget {
  final List list;
  VideoGridWidget(this.list);

  Widget buildVideoItem(String cover, String title) {
    return GestureDetector(
      onTap: (){
        print("tap video");
      },
      child: Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(cover, fit: BoxFit.cover),
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
    ));
  }

  @override
  Widget build(BuildContext context) {
    var children = list.map((cover) => buildVideoItem(cover, "HANA菊梓喬 - 不能放手 (劇集 “使徒行者3” 片尾曲) Official MV")).toList();
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
