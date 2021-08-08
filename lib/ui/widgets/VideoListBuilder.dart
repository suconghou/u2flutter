import 'package:flutter/material.dart';
import 'VideoGridWidget.dart';

class VideoListBuilder extends StatefulWidget {
  final Function refresh;
  VideoListBuilder(this.refresh);

  @override
  State<StatefulWidget> createState() {
    return VideoListBuilderState(refresh);
  }
}

class VideoListBuilderState extends State {
  Function refresh;
  Future<dynamic> _refresh;

  VideoListBuilderState(this.refresh) : _refresh = refresh();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _refresh,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError) {
              return _body(snapshot.data);
            } else {
              return Center(
                child: TextButton(
                  child: Text("加载失败，点击重试"),
                  onPressed: () {
                    setState(() {
                      _refresh = refresh();
                    });
                  },
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

  Widget _body(dynamic data) {
    final list = data["items"];
    if (list is List) {
      return VideoGridWidget(
        list,
        grid: false,
      );
    }
    return Center(child: Text(data.toString()));
  }
}
