// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_app/ui/utils/toast.dart';
import 'VideoGridWidget.dart';

class VideoListBuilder extends StatefulWidget {
  final Function refresh;
  const VideoListBuilder(this.refresh, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VideoListBuilderState();
  }
}

class _VideoListBuilderState extends State<VideoListBuilder> {
  late Future<dynamic> _refresh;

  @override
  Widget build(BuildContext context) {
    _refresh = widget.refresh();
    return FutureBuilder(
        future: _refresh,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError) {
              return _body(snapshot.data);
            } else {
              Toast.toast(context, snapshot.error.toString());
              return Center(
                child: TextButton(
                  child: const Text("加载失败，点击重试"),
                  onPressed: () {
                    setState(() {
                      _refresh = widget.refresh();
                    });
                  },
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _body(dynamic data) {
    final list = data["items"];
    if (list is List) {
      final children = list
          .map((item) => buildSignleVideoItem(
                context,
                item,
              ))
          .toList();
      return Column(
        children: children,
      );
    }
    return Center(child: Text(data.toString()));
  }
}
