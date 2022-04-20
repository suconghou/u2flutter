// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_app/ui/utils/toast.dart';
import '../../utils/dataHelper.dart';
import '../../api/index.dart';
import '../widgets/VideoGridWidget.dart';

class FavVideoList extends StatelessWidget {
  const FavVideoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getFavVIds(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError) {
              final Set<String> ids = snapshot.data;
              if (ids.isEmpty) {
                return const Center(
                  child: Text("无数据"),
                );
              }
              return ListView(
                padding: const EdgeInsets.only(top: 10),
                children: ids.map((e) => buildItem(e)).toList(),
              );
            } else {
              return Center(
                child: TextButton(
                  child: const Text("加载失败"),
                  onPressed: () => {
                    {Toast.toast(context, snapshot.error.toString())},
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

  Widget buildItem(String id) {
    final Future _refresh = api.videoInfo(id);
    return FutureBuilder(
        future: _refresh,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError) {
              return _body(context, snapshot.data);
            } else {
              return Center(
                child: TextButton(
                  child: const Text("加载失败"),
                  onPressed: () => {
                    {Toast.toast(context, snapshot.error.toString())},
                  },
                ),
              );
            }
          } else {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 40),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
        });
  }

  Widget _body(BuildContext context, dynamic res) {
    final item = res["items"][0];
    return buildSignleVideoItem(context, item);
  }
}
