import 'package:flutter/material.dart';
import 'package:flutter_app/utils/videoInfo.dart';
import '../../api/index.dart';
import 'ChannelTabPage.dart';

class ChannelPage extends StatelessWidget {
  Future _refresh;

  @override
  Widget build(BuildContext context) {
    String cid = ModalRoute.of(context).settings.arguments;
    _refresh = api.channels(cid);
    return main(context, cid);
  }

  Widget main(BuildContext context, String channelId) {
    return FutureBuilder(
        future: _refresh,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError) {
              return _body(context, snapshot.data);
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

  Widget _body(BuildContext context, dynamic res) {
    dynamic item = res["items"][0];
    return ChannelTabPage(item);
  }
}
