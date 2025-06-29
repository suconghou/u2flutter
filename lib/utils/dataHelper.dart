// ignore_for_file: file_names

import 'store.dart';

const String _storeKey = "query_history";

Future<bool> addQueryHistory(String q) async {
  Set<String> qSet = <String>{};
  qSet.add(q);
  qSet.addAll(await getQueryHistory());
  return await Store.setSet(_storeKey, qSet);
}

Future<bool> delQueryHistory(String q) async {
  final data = await getQueryHistory();
  data.remove(q);
  return await Store.setSet(_storeKey, data);
}

Future<bool> clearQueryHistory() async {
  return await Store.remove(_storeKey);
}

Future<Set<String>> getQueryHistory() async {
  final v = await Store.getSet(_storeKey);
  return v;
}

const String _favVIdsKey = 'fav_vids';
const String _favCIdsKey = 'fav_cids';

Future<Set<String>> getFavVIds() async {
  final v = await Store.getSet(_favVIdsKey);
  return v;
}

Future<Set<String>> getFavCIds() async {
  final v = await Store.getSet(_favCIdsKey);
  return v;
}

Future<bool> addFavVIds(String id) async {
  final ids = await getFavVIds();
  ids.add(id);
  return await Store.setSet(_favVIdsKey, ids);
}

Future<bool> addFavCIds(String id) async {
  final ids = await getFavCIds();
  ids.add(id);
  return await Store.setSet(_favCIdsKey, ids);
}

Future<bool> delFavVIds(String id) async {
  final ids = await getFavVIds();
  ids.remove(id);
  return await Store.setSet(_favVIdsKey, ids);
}

Future<bool> delFavCIds(String id) async {
  final ids = await getFavCIds();
  ids.remove(id);
  return await Store.setSet(_favCIdsKey, ids);
}
