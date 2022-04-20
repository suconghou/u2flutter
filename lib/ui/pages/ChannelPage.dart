// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_app/ui/utils/toast.dart';
import '../../api/index.dart';
import 'ChannelTabPage.dart';

// ignore: use_key_in_widget_constructors
class ChannelPage extends StatelessWidget {
  late final Future _refresh;

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
              return Scaffold(
                appBar: AppBar(
                  title: const Text("Loading"),
                ),
                body: Center(
                  child: TextButton(
                    child: const Text("加载失败"),
                    onPressed: () =>
                        {Toast.toast(context, snapshot.error.toString())},
                  ),
                ),
              );
            }
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Loading"),
              ),
              body: const Center(
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
