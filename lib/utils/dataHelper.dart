import 'store.dart';

final String _storeKey = "query_history";

addQueryHistory(String q) {
  Set qSet = Set<String>();
  qSet.add(q);
  qSet.addAll(getQueryHistory());
  Store.set(_storeKey, qSet);
}

delQueryHistory(String q) {
  var data = getQueryHistory();
  data.remove(q);
  Store.set(_storeKey, data);
}

clearQueryHistory() {
  Store.remove(_storeKey);
}

Set<String> getQueryHistory() {
  var v = Store.get(_storeKey);
  if (v is Set) {
    return v;
  }
  return Set<String>();
}

final String _favVIdsKey = 'fav_vids';
final String _favCIdsKey = 'fav_cids';

Set<String> getFavVIds() {
  var v = Store.get(_favVIdsKey);
  if (v is Set) {
    return v;
  }
  return Set<String>();
}

Set<String> getFavCIds() {
  var v = Store.get(_favCIdsKey);
  if (v is Set) {
    return v;
  }
  return Set<String>();
}

delFavVIds(String id) {
  var ids = getFavVIds();
  ids.remove(id);
  Store.set(_favVIdsKey, ids);
}

delFavCIds(String id) {
  var ids = getFavCIds();
  ids.remove(id);
  Store.set(_favCIdsKey, ids);
}
