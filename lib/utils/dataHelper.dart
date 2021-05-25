import 'store.dart';

final String _storeKey = "query_history";

addQueryHistory(String q) async {
  Set<String> qSet = Set<String>();
  qSet.add(q);
  qSet.addAll(await getQueryHistory());
  return await Store.setSet(_storeKey, qSet);
}

delQueryHistory(String q) async {
  var data = await getQueryHistory();
  data.remove(q);
  return await Store.setSet(_storeKey, data);
}

clearQueryHistory() async {
  return await Store.remove(_storeKey);
}

Future<Set<String>> getQueryHistory() async {
  var v = await Store.getSet(_storeKey);
  if (v is Set<String>) {
    return v;
  }
  return Set<String>();
}

final String _favVIdsKey = 'fav_vids';
final String _favCIdsKey = 'fav_cids';

Future<Set<String>> getFavVIds() async {
  var v = await Store.getSet(_favVIdsKey);
  if (v is Set<String>) {
    return v;
  }
  return Set<String>();
}

Future<Set<String>> getFavCIds() async {
  var v = await Store.getSet(_favCIdsKey);
  if (v is Set<String>) {
    return v;
  }
  return Set<String>();
}

addFavVIds(String id) async {
  var ids = await getFavVIds();
  ids.add(id);
  return await Store.setSet(_favVIdsKey, ids);
}

addFavCIds(String id) async {
  var ids = await getFavCIds();
  ids.add(id);
  return await Store.setSet(_favCIdsKey, ids);
}

delFavVIds(String id) async {
  var ids = await getFavVIds();
  ids.remove(id);
  return await Store.setSet(_favVIdsKey, ids);
}

delFavCIds(String id) async {
  var ids = await getFavCIds();
  ids.remove(id);
  return await Store.setSet(_favCIdsKey, ids);
}
