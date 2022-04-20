class CacheItem {
  dynamic value;
  int expire;
  CacheItem(this.value, this.expire);
}

class CacheManager {
  final cache = <String, CacheItem>{};

  set(String key, dynamic value, [int ttl = 3600]) {
    int t = DateTime.now().millisecondsSinceEpoch + ttl * 1000;
    cache[key] = CacheItem(value, t);
  }

  get(String key) {
    int t = DateTime.now().millisecondsSinceEpoch;
    CacheItem? item = cache[key];
    if (item != null) {
      if (item.expire > t) {
        return item.value;
      } else {
        expire();
      }
    }
  }

  expire() {
    int t = DateTime.now().millisecondsSinceEpoch;
    cache.removeWhere((key, value) => value.expire < t);
  }
}
