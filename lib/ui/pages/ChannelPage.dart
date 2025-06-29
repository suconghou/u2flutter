// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/utils/toast.dart';
import '../../api/index.dart';
import 'ChannelTabPage.dart';

// ignore: use_key_in_widget_constructors
class ChannelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String cid = ModalRoute.of(context)?.settings.arguments as String;
    return main(context, cid);
  }

  Widget main(BuildContext context, String channelId) {
    Future refresh = api.channels(channelId);
    return FutureBuilder(
      future: refresh,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasError) {
            return _body(context, snapshot.data);
          } else {
            return Scaffold(
              appBar: AppBar(title: const Text("Loading")),
              body: Center(
                child: TextButton(
                  child: const Text("加载失败"),
                  onPressed: () => {toast(snapshot.error.toString())},
                ),
              ),
            );
          }
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text("Loading")),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _body(BuildContext context, dynamic res) {
    dynamic item = res["items"][0];
    return ChannelTabPage(item);
  }
}
