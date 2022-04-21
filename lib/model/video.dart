class PageData {
  List list;
  String pageToken;
  bool error;
  PageData(this.list, this.pageToken, [this.error = false]);
}
