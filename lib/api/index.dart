import 'dart:convert';
import 'dart:io';
import '../utils/cache.dart';
import '../utils/store.dart';

final _default = 'https://r.suconghou.cn/video/api/v3/';

final _defaulstream = 'http://share.suconghou.cn/video/';

bool _init = false;

late Uri _base;
String streambase = _defaulstream;

class _DataApi {
  final client = HttpClient();
  final cache = CacheManager();

  _DataApi(
      [int timeout = 15,
      userAgent =
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Safari/605.1.15']) {
    client.connectionTimeout = Duration(seconds: timeout);
    client.userAgent = userAgent;
  }

  Future<Uri> initBaseUrl() async {
    final String? _baseUrl = await Store.getString("baseUrl");
    if (_baseUrl != null && _baseUrl.isNotEmpty) {
      _base = Uri.parse(_baseUrl);
    } else {
      _base = Uri.parse(_default);
    }
    final String? _streambase = await Store.getString("videourl");
    if (_streambase != null && _streambase.isNotEmpty) {
      streambase = _streambase;
    } else {
      streambase = _defaulstream;
    }
    return _base;
  }

  Future<dynamic> mostPopularVideos(
      {String regionCode = 'HK',
      int videoCategoryId = 1,
      int maxResults = 30}) async {
    final params = {
      'chart': 'mostPopular',
      'maxResults': maxResults.toString(),
      'regionCode': regionCode,
      'videoCategoryId': videoCategoryId.toString(),
    };
    return await get('videos', params);
  }

  Future<dynamic> videoInfo(String id) async {
    final params = {
      'id': id,
    };
    return await get('videos', params);
  }

  Future<dynamic> search(
      {String q = "",
      String pageToken = "",
      String channelId = "",
      String regionCode = "",
      String type = 'video',
      int maxResults = 20}) async {
    var order = '';
    if (q.isNotEmpty) {
      order = 'viewCount';
    }
    final params = {
      'q': q,
      'type': type,
      'order': order,
      'channelId': channelId,
      'regionCode': regionCode,
      'pageToken': pageToken,
      'maxResults': maxResults.toString(),
    };
    return await get('search', params);
  }

  Future<dynamic> relatedVideo(
      {String relatedToVideoId = "",
      String pageToken = "",
      String type = 'video',
      int maxResults = 30}) async {
    final params = {
      'type': type,
      'relatedToVideoId': relatedToVideoId,
      'pageToken': pageToken,
      'maxResults': maxResults.toString()
    };
    return await get('search', params);
  }

  Future<dynamic> channels(String id) async {
    final params = {
      'id': id,
    };
    return await get('channels', params);
  }

  Future<dynamic> playlists(String id) async {
    final params = {
      'id': id,
    };
    return await get('playlists', params);
  }

  Future<dynamic> playlistsInChannel(
      {String channelId = "",
      String pageToken = "",
      int maxResults = 20}) async {
    final params = {
      'channelId': channelId,
      'maxResults': maxResults.toString(),
      'pageToken': pageToken,
    };
    return await get('playlists', params);
  }

  Future<dynamic> playlistItems(
      {String playlistId = "",
      String pageToken = "",
      int maxResults = 30}) async {
    final params = {
      'playlistId': playlistId,
      'maxResults': maxResults.toString(),
      'pageToken': pageToken,
    };
    return await get('playlistItems', params);
  }

  Future<Uri> buildUrl(String uri, Map<String, dynamic> params) async {
    if (!_init) {
      _base = await initBaseUrl();
      print(_base);
      _init = true;
    }
    params.removeWhere((key, value) => value == null || value.isEmpty);
    return Uri(
        scheme: _base.scheme,
        host: _base.host,
        port: _base.port,
        path: _base.path + uri,
        queryParameters: params);
  }

  Future<dynamic> get(String uri, Map<String, Object> params) async {
    final target = await buildUrl(uri, params);
    final key = target.toString();
    final v = cache.get(key);
    if (v != null) {
      return v;
    }
    const timeout = Duration(seconds: 15);
    final req = await client.getUrl(target);
    final res = await req.close().timeout(timeout);
    if (res.statusCode != HttpStatus.ok) {
      throw Exception("request $uri error , status ${res.statusCode}");
    }
    final body = await res.transform(utf8.decoder).join().timeout(timeout);
    final data = jsonDecode(body);
    cache.set(key, data);
    return data;
  }
}

final api = _DataApi();
