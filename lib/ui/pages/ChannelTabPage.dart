import 'package:flutter/material.dart';
import 'package:flutter_app/utils/videoInfo.dart';
import '../widgets/ChannelTabView.dart';

const url =
    'http://www.pptbz.com/pptpic/UploadFiles_6909/201203/2012031220134655.jpg';

class ChannelTabPage extends StatefulWidget {
  dynamic item;
  ChannelTabPage(
    this.item,
  );
  @override
  State createState() => _ChannelTabPageState(item);
}

class _ChannelTabPageState extends State {
  dynamic item;
  final tabTitle = [
    '上传的',
    '收藏的',
    '播放列表',
  ];

  _ChannelTabPageState(this.item);

  @override
  Widget build(BuildContext context) {
    final String channelId = item["id"];
    final String title = getVideoTitle(item);
    final String pubTime = pubAt(item);
    final String desc = getVideoDesc(item);
    final String count = viewCount(item);
    final String subCount = getSubscriberCount(item);
    final String videoNum = getVideoCount(item);

    final String uploadId = getChannelUploadId(item);
    final String favId = getChannelFavoriteId(item);

    Widget uploadList = uploadId.isNotEmpty ? ChannelTabView(ChannelTab.UPLOAD,uploadId): Center(child: Text("无数据"),);
    Widget favList = favId.isNotEmpty ? ChannelTabView(ChannelTab.FAVORITE,favId): Center(child: Text("无数据"),);

    return new DefaultTabController(
        length: tabTitle.length,
        child: Scaffold(
          body: new NestedScrollView(
            headerSliverBuilder: (context, bool) {
              return [
                SliverAppBar(
                  expandedHeight: 200,
                  floating: true,
                  pinned: true,
                  title: Text(title),
                  flexibleSpace: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              contentPadding: EdgeInsets.all(10),
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      children: [
                                        Text(
                                          title,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text("创建于" + pubTime,
                                              style: TextStyle(fontSize: 14)),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              count,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              subCount,
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 14),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(videoNum,
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 14)),
                                          ],
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              desc,
                                              style: TextStyle(fontSize: 14),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  desc,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            );
                          });
                    },
                    child: FlexibleSpaceBar(
                        background: Image.network(
                      url,
                      fit: BoxFit.cover,
                    )),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: SliverTabBarDelegate(
                    new TabBar(
                      tabs: tabTitle.map((f) => Tab(text: f)).toList(),
                      indicatorColor: Colors.red,
                      unselectedLabelColor: Colors.black,
                      labelColor: Colors.red,
                    ),
                    color: Colors.white,
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              children: [
                uploadList,
                favList,
                ChannelTabView(ChannelTab.PLAYLIST,channelId),
              ],
            ),
          ),
        ));
  }
}

class SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar widget;
  final Color color;

  const SliverTabBarDelegate(this.widget, {this.color})
      : assert(widget != null);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: widget,
      color: color,
    );
  }

  @override
  bool shouldRebuild(SliverTabBarDelegate oldDelegate) {
    return false;
  }

  @override
  double get maxExtent => widget.preferredSize.height;

  @override
  double get minExtent => widget.preferredSize.height;
}
