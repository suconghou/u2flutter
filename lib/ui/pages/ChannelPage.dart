import 'package:flutter/material.dart';
import 'package:flutter_app/utils/videoInfo.dart';
import '../../api/index.dart';

class ChannelPage extends StatelessWidget {
  Future _refresh;

  @override
  Widget build(BuildContext context) {
    String cid = ModalRoute.of(context).settings.arguments;
    _refresh = api.channels(cid);
    return main();
  }

  Widget main() {
    return FutureBuilder(
        future: _refresh,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError) {
              return _body(snapshot.data);
            } else {
              return Center(
                child: FlatButton(
                  child: Text("加载失败，点击重试"),
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

  Widget _body(dynamic res) {
    dynamic item = res["items"][0];
    final String pubTime = pubAt(item);
    final String title = getVideoTitle(item);
    final String desc = getVideoDesc(item);
    final String count = viewCount(item);
    final String subCount = getSubscriberCount(item);
    final String videoNum = getVideoCount(item);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Text(title,
              style: TextStyle(
                fontSize: 24,
              )),
          SizedBox(height: 2,),
          Text("创建于:" + pubTime,style: TextStyle(
            fontSize: 16
          ),),
          SizedBox(height: 2,),
          Row(
            children: [
              Text(count,style: TextStyle(
                color: Colors.red
              ),),
              SizedBox(
                width: 2,
              ),
              Text(subCount,style: TextStyle(
                color: Colors.blue
              ),),
              SizedBox(
                width: 2,
              ),
              Text(videoNum,style:TextStyle(
                color: Colors.green
              )),
            ],
          ),
          SizedBox(height: 5,),
          Text(desc),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
