import 'store.dart';

const String _storeKey = "query_history";

Future<bool> addQueryHistory(String q) async {
  Set<String> qSet = Set<String>();
  qSet.add(q);
  qSet.addAll(await getQueryHistory());
  return await Store.setSet(_storeKey, qSet);
}

Future<bool> delQueryHistory(String q) async {
  var data = await getQueryHistory();
  data.remove(q);
  return await Store.setSet(_storeKey, data);
}

Future<bool> clearQueryHistory() async {
  return await Store.remove(_storeKey);
}

Future<Set<String>> getQueryHistory() async {
  var v = await Store.getSet(_storeKey);
  if (v is Set<String>) {
    return v;
  }
  return Set<String>();
}

const String _favVIdsKey = 'fav_vids';
const String _favCIdsKey = 'fav_cids';

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

Future<bool> addFavVIds(String id) async {
  var ids = await getFavVIds();
  ids.add(id);
  return await Store.setSet(_favVIdsKey, ids);
}

Future<bool> addFavCIds(String id) async {
  var ids = await getFavCIds();
  ids.add(id);
  return await Store.setSet(_favCIdsKey, ids);
}

Future<bool> delFavVIds(String id) async {
  var ids = await getFavVIds();
  ids.remove(id);
  return await Store.setSet(_favVIdsKey, ids);
}

Future<bool> delFavCIds(String id) async {
  var ids = await getFavCIds();
  ids.remove(id);
  return await Store.setSet(_favCIdsKey, ids);
}
