// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/LoadingStatus.dart';
import '../../model/video.dart';

abstract class LoadingPageState<P extends StatefulWidget> extends State<P>
    with AutomaticKeepAliveClientMixin {
  final List items = [];
  LoadingStatus _status = LoadingStatus.none;
  String _page = "";

  Future<PageData> fetchData(String page);

  @override
  void initState() {
    super.initState();
    loadMore();
  }

  void loadMore() {
    if (_status == LoadingStatus.nomore || _status == LoadingStatus.loading) {
      return;
    }
    setState(() {
      _status = LoadingStatus.loading;
    });
    fetchData(_page)
        .catchError((e) {
          debugPrint(e.toString());
          if (mounted) {
            setState(() {
              _status = LoadingStatus.error;
            });
          }
        })
        .asStream()
        .listen((data) {
          _page = data.pageToken;
          if (data.list.isEmpty) {
            setState(() {
              _status = LoadingStatus.nomore;
            });
          } else {
            if (mounted) {
              setState(() {
                _status = LoadingStatus.none;
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
    if (_status == LoadingStatus.loading && items.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return NotificationListener(
        onNotification: (notification) {
          if (notification.runtimeType == ScrollUpdateNotification) {
            final n = notification as ScrollUpdateNotification;
            if (_status != LoadingStatus.loading &&
                _status != LoadingStatus.error &&
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
  }

  @override
  bool get wantKeepAlive => false;

  Widget buildItem(BuildContext context, int index, dynamic item);
}
