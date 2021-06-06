import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/LoadingStatus.dart';
import '../../model/video.dart';

abstract class LoadingPageState<P extends StatefulWidget> extends State<P>
    with AutomaticKeepAliveClientMixin {
  final List items = [];
  LoadingStatus _status = LoadingStatus.NONE;
  String _page = "";

  Future<PageData> fetchData(String page);

  @override
  void initState() {
    super.initState();
    loadMore();
  }

  void loadMore() {
    if (_status == LoadingStatus.NO_MORE || _status == LoadingStatus.LOADING) {
      return;
    }
    print("load more page: $_page");
    setState(() {
      _status = LoadingStatus.LOADING;
    });
    fetchData(_page)
        .catchError((e) {
          debugPrint(e.toString());
          if (mounted) {
            setState(() {
              _status = LoadingStatus.ERROR;
            });
          }
        })
        .asStream()
        .listen((data) {
          _page = data.pageToken;
          print("load data: ${data.list.length}");
          if (data.list.isEmpty) {
            setState(() {
              _status = LoadingStatus.NO_MORE;
            });
          } else {
            if (mounted) {
              setState(() {
                _status = LoadingStatus.NONE;
                items.addAll(data.list);
                onLoadComplete();
              });
            }
          }
        });
  }

  void onLoadComplete() {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_status == LoadingStatus.LOADING && items.isEmpty)
      return Center(
        child: CircularProgressIndicator(),
      );
    else
      return NotificationListener(
        onNotification: (notification) {
          if (notification.runtimeType == ScrollUpdateNotification) {
            var n = notification as ScrollUpdateNotification;
            if (_status != LoadingStatus.LOADING &&
                _status != LoadingStatus.ERROR &&
                n.metrics.extentAfter < 150) {
              loadMore();
            }
          }
          return true;
        },
        child: ListView.builder(
          itemCount: items.length + 1,
          itemBuilder: (c, i) {
            if (i == items.length) {
              return getWidgetByLoadingStatus(_status, loadMore);
            } else {
              return buildItem(context, i, items[i]);
            }
          },
        ),
      );
  }

  @override
  bool get wantKeepAlive => false;

  Widget buildItem(BuildContext context, int index, dynamic item);
}
