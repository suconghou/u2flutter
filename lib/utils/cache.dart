class cacheItem {
  dynamic value;
  int expire;
  cacheItem(this.value, this.expire);
}

class CacheManager {
  var cache = Map<String, cacheItem>();

  set(String key, dynamic value, [int ttl = 3600]) {
    int t = DateTime.now().millisecondsSinceEpoch + ttl * 1000;
    cache[key] = cacheItem(value, t);
  }

  get(String key) {
    int t = DateTime.now().millisecondsSinceEpoch;
    cacheItem item = cache[key];
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
