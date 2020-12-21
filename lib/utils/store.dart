import 'dart:convert';
import 'dart:io';

final _store = _Store();

class _Store {
  final file = File('store.json');
  var _state = Map<String, dynamic>();

  init() async {
    var str = await file.readAsString();
    if (str.isEmpty) {
      str = "{}";
    }
    var data = jsonDecode(str);
    _state = data;
  }

  get(String key) {
    return _state[key];
  }

  set(String key, dynamic value) {
    _state[key] = value;
  }

  remove(String key) {
    _state.remove(key);
  }

  save() {
    var str = jsonEncode(_state);
    file.writeAsString(str);
  }
}

class Store {
  static set(String key, dynamic value) {
    _store.set(key, value);
  }

  static get(
    String key,
  ) {
    _store.get(key);
  }

  static remove(
    String key,
  ) {
    _store.remove(key);
  }
}
