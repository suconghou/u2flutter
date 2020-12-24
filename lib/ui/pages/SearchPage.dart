import 'package:flutter/material.dart';
import '../../utils/store.dart';
import 'LoadingPageState.dart';
import '../widgets/VideoGridWidget.dart';
import '../../api/index.dart';

class SearchPageDelegate extends SearchDelegate<Map> {
  SearchPageDelegate()
      : super(
            searchFieldLabel: "输入关键词搜索",
            searchFieldStyle: TextStyle(
              fontSize: 14,
            ));

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
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
        icon: IconButton(
            icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        )),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    var q = query;
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
    final suggestions = getQueryHistory();
    print(suggestions);
    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (c, i) {
          return ListTile(
            onTap: () {
              onShowResult(suggestions.elementAt(i));
            },
            title: Text(suggestions.elementAt(i)),
            trailing: Container(
              width: 20,
              height: 20,
              child: IconButton(
                iconSize: 20,
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
  Future<List> fetchData(int page) async {
    var res = await api.search(q: widget.query);
    if (res["items"] is List) {
      return res["items"];
    }
    return [];
  }

  @override
  Widget buildItem(BuildContext context, int index, dynamic item) {
    return buildIndexVideoItem(context, item);
  }

  Widget tagText(String s) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
      child: Chip(
//      labelPadding: EdgeInsets.all(2),
//      padding: EdgeInsets.all(5),
        label: Text(s),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

final String storeKey = "query_history";

addQueryHistory(String q) {
  Set qSet = Set<String>();
  qSet.add(q);
  qSet.addAll(getQueryHistory());
  Store.set(storeKey, qSet);
}

delQueryHistory(String q) {
  var data = getQueryHistory();
  data.remove(q);
  Store.set(storeKey, data);
}

clearQueryHistory() {
  Store.remove(storeKey);
}

Set<String> getQueryHistory() {
  var v = Store.get(storeKey);
  if (v is Set) {
    return v;
  }
  return Set<String>();
}
