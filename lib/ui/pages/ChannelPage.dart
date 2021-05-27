import 'package:flutter/material.dart';
import '../../api/index.dart';
import 'ChannelTabPage.dart';

class ChannelPage extends StatelessWidget {
  late Future _refresh;

  @override
  Widget build(BuildContext context) {
    String cid = ModalRoute.of(context)?.settings.arguments as String;
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
                child: TextButton(
                  child: Text("加载失败"),
                  onPressed: () => {},
                ),
              );
            }
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text("Loading"),
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  Widget _body(BuildContext context, dynamic res) {
    dynamic item = res["items"][0];
    return ChannelTabPage(item);
  }
}
