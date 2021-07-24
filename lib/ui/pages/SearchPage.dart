import 'package:flutter/material.dart';
import '../../utils/dataHelper.dart';
import 'LoadingPageState.dart';
import '../widgets/VideoGridWidget.dart';
import '../../api/index.dart';
import '../../model/video.dart';

class SearchPageDelegate extends SearchDelegate<Map> {
  SearchPageDelegate()
      : super(
          searchFieldLabel: "输入关键词搜索",
          searchFieldStyle: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, Map());
            } else {
              query = "";
              showSuggestions(context);
            }
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, Map());
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    final q = query;
    if (q.isEmpty) {
      query = "";
      return Container();
    }
    addQueryHistory(q);
    return ResultPage(q);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SuggestionPage(query, (q) {
      query = q;
      showResults(context);
    }, (q) {
      query = q;
    });
  }
}

class SuggestionPage extends StatelessWidget {
  final String query;
  final Function onShowResult;
  final Function onQuery;

  SuggestionPage(this.query, this.onShowResult, this.onQuery);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getQueryHistory(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError) {
              final suggestions = snapshot.data;
              return ListView.builder(
                  itemCount: suggestions.length,
                  itemBuilder: (c, i) {
                    return ListTile(
                      onTap: () {
                        onShowResult(suggestions.elementAt(i));
                      },
                      title: Text(suggestions.elementAt(i)),
                      trailing: Container(
                        width: 24,
                        height: 24,
                        child: IconButton(
                          iconSize: 24,
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            delQueryHistory(suggestions.elementAt(i));
                            onQuery(query);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ),
                    );
                  });
            } else {
              return Center(
                child: TextButton(
                  child: Text("加载失败"),
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
}

class ResultPage extends StatefulWidget {
  final String query;

  ResultPage(this.query);

  @override
  State createState() => ResultPageState();
}

class ResultPageState extends LoadingPageState<ResultPage> {
  @override
  Future<PageData> fetchData(String page) async {
    final res = await api.search(q: widget.query, pageToken: page);
    if (res != null && res["items"] is List) {
      return PageData(res["items"],
          res["nextPageToken"] is String ? res["nextPageToken"] : "");
    }
    return PageData([], "");
  }

  @override
  Widget buildItem(BuildContext context, int index, dynamic item) {
    return buildSignleVideoItem(context, item);
  }

  @override
  bool get wantKeepAlive => true;
}
