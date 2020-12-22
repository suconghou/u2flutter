import 'dart:convert';
import 'dart:io';
import '../utils/cache.dart';

Uri base = Uri.parse('http://s.feds.club/video/api/v3/');

class _DataApi {
  var client = HttpClient();
  var cache = CacheManager();

  _DataApi(
      [int timeout = 15,
      userAgent =
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Safari/605.1.15']) {
    client.connectionTimeout = Duration(seconds: timeout);
    client.userAgent = userAgent;
  }

  mostPopularVideos(
      {String regionCode = 'HK',
      int videoCategoryId = 1,
      int maxResults = 30}) async {
    var params = {
      'chart': 'mostPopular',
      'maxResults': maxResults.toString(),
      'regionCode': regionCode,
      'videoCategoryId': videoCategoryId.toString(),
    };
    return await get('videos', params);
  }

  videoInfo(String id) async {
    var params = {
      'id': id,
    };
    return await get('videos', params);
  }

  search(
      {String q,
      String pageToken,
      String channelId,
      String regionCode,
      String type = 'video',
      int maxResults = 20}) async {
    var order = '';
    if (q != null && q.isNotEmpty) {
      order = 'viewCount';
    }
    var params = {
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

  relatedVideo(
      {String relatedToVideoId,
      String pageToken,
      String type = 'video',
      int maxResults = 30}) async {
    var params = {
      'type': type,
      'relatedToVideoId': relatedToVideoId,
      'pageToken': pageToken,
      'maxResults': maxResults.toString()
    };
    return await get('search', params);
  }

  channels(String id) async {
    var params = {
      'id': id,
    };
    return await get('channels', params);
  }

  playlists(String id) async {
    var params = {
      'id': id,
    };
    return await get('playlists', params);
  }

  playlistsInChannel(
      {String channelId, String pageToken, int maxResults = 20}) async {
    var params = {
      'channelId': channelId,
      'maxResults': maxResults.toString(),
      'pageToken': pageToken,
    };
    return await get('playlists', params);
  }

  playlistItems(
      {String playlistId, String pageToken, int maxResults = 30}) async {
    var params = {
      'playlistId': playlistId,
      'maxResults': maxResults.toString(),
      'pageToken': pageToken,
    };
    return await get('playlistItems', params);
  }

  Uri buildUrl(String uri, Map<String, String> params) {
    params.removeWhere((key, value) => value == null || value.isEmpty);
    return Uri(
        scheme: base.scheme,
        host: base.host,
        port: base.port,
        path: base.path + uri,
        queryParameters: params);
  }

  get(String uri, Map<String, Object> params) async {
    var target = buildUrl(uri, params);
    var key = target.toString();
    var v = cache.get(key);
    if (v != null) {
      return v;
    }
    const timeout = Duration(seconds: 15);
    var req = await client.getUrl(target);
    var res = await req.close().timeout(timeout);
    if (res.statusCode != HttpStatus.ok) {
      throw Exception("request $uri error , status ${res.statusCode}");
    }
    var body = await res.transform(utf8.decoder).join().timeout(timeout);
    var data = jsonDecode(body);
    cache.set(key, data);
    print(data);
    return data;
  }
}

final api = _DataApi();
