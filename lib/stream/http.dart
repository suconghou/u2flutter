import 'dart:io';
import 'dart:convert';
import 'segment.dart';
import 'filestore.dart';

import '../utils/cache.dart';

const videoitags = [
  "247",
  "136",
  "244",
  "135",
  "243",
  "134",
  "242",
  "133",
  "278",
  "160",
];

const audioitags = ["250", "249", "251", "600", "140", "599"];

String removeTrailing(String pattern, String from) {
  int i = from.length;
  while (from.startsWith(pattern, i - pattern.length)) {
    i -= pattern.length;
  }
  return from.substring(0, i);
}

String trimLeading(String pattern, String from) {
  int i = 0;
  while (from.startsWith(pattern, i)) {
    i += pattern.length;
  }
  return from.substring(i);
}

class CacheService {
  late HttpServer server;
  final HttpClient client = HttpClient();
  final List<String> mirrors;
  static const int retry = 5;
  final RegExp reqPath = RegExp(r"^/[\w\-]{5,16}/\d+$");
  final RegExp reqRange = RegExp(r"^bytes=(\d+)-(\d+)?$");
  final RegExp reqTs = RegExp(r"^/[\w\-]{5,16}/\d+/\d+-\d+.ts$");
  final RegExp reqJson = RegExp(r"^/([\w\-]{5,16})\.(json|mpd)");
  final cache = CacheManager();
  CacheService(
    this.mirrors, {
    String userAgent =
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Safari/605.1.15',
  }) {
    client.connectionTimeout = const Duration(seconds: 5);
    client.userAgent = userAgent;
  }

  Future<int> start() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    await FileCacheManager.init();
    return server.port;
  }

  Future<void> listen() async {
    await for (HttpRequest req in server) {
      process(req);
    }
  }

  Future<void> process(HttpRequest req) async {
    try {
      req.response.deadline = const Duration(minutes: 5);
      final rr = req.headers.value("range");
      if (reqTs.hasMatch(req.uri.path)) {
        handle(req, req.uri.path);
      } else if (reqPath.hasMatch(req.uri.path) &&
          rr != null &&
          reqRange.hasMatch(rr)) {
        await handlePart(req, rr);
      } else if (reqJson.hasMatch(req.uri.path)) {
        await handleJson(req);
      } else {
        req.response.statusCode = HttpStatus.notFound;
        req.response.write("404 not found");
        req.response.close();
      }
    } catch (e) {
      req.response.statusCode = HttpStatus.internalServerError;
      req.response.write("$e");
      req.response.close();
      // ignore: avoid_print
      print("${req.uri.path} : $e");
    }
  }

  Future<void> handle(HttpRequest req, String reqPath) async {
    final s = await fetch(reqPath);
    req.response.headers.contentType = ContentType.binary;
    await req.response.addStream(s);
    await req.response.close();
  }

  Future<void> handlePart(HttpRequest req, String rr) async {
    final matches = reqRange.firstMatch(rr);
    final start = matches?.group(1);
    var end = matches?.group(2);
    if (start == null || end == null) {
      throw Exception("invalid start end $start $end");
    }
    if (end.isEmpty) {
      end = (int.parse(start) + 1024 * 1024).toString();
    }
    final ts = "/$start-$end.ts";
    req.response.statusCode = HttpStatus.partialContent;
    await handle(req, req.uri.path + ts);
  }

  Future<void> handleJson(HttpRequest req) async {
    final matches = reqJson.firstMatch(req.uri.path)!;
    final id = matches.group(1)!;
    final info = await videoinfo(id);
    if (matches.group(2) == 'json') {
      final str = jsonEncode(info);
      req.response.headers.contentType = ContentType.json;
      req.response.write(str);
      await req.response.close();
      return;
    }
    await outputMpd(req, info);
  }

  String getDuration(Map<String, dynamic> info) {
    final t = int.parse(info["duration"]);
    final text = ["PT"];
    final hour = t / 3600;
    final min = (t % 3600) / 60;
    final sec = (t % 60);
    if (hour >= 1) {
      text.add("${hour.floor()}H");
    }
    if (min >= 1) {
      text.add("${min.floor()}M");
    }
    text.add("${sec}S");
    return text.join();
  }

  Future<void> outputMpd(HttpRequest req, Map<String, dynamic> info) async {
    try {
      final text = await getMpdXml(info);
      req.response.headers.add("Content-Type", "application/dash+xml");
      req.response.write(text);
      await req.response.close();
    } catch (e) {
      req.response.statusCode = HttpStatus.internalServerError;
      req.response.write(e);
      req.response.close();
    }
  }

  Future<String> getMpdXml(Map<String, dynamic> info) async {
    final videoId = info['id'];
    final duration = getDuration(info);
    final durationInt = int.parse(info["duration"]);
    final streams = info['streams'] as Map<String, dynamic>;
    final text = [
      "<MPD xmlns=\"urn:mpeg:dash:schema:mpd:2011\" profiles=\"urn:mpeg:dash:profile:isoff-on-demand:2011\" minBufferTime=\"PT2S\" mediaPresentationDuration=\"$duration\" type=\"static\"><Period>",
    ];
    final List<String> videos = [];
    final List<String> audios = [];
    final v = findStream(streams, videoitags);
    final a = findStream(streams, audioitags);
    for (final value in [v, a]) {
      if (value == null) {
        continue;
      }
      final itag = value['itag'];
      final index = value['indexRange'] as Map<String, dynamic>;
      final type = (value["type"] as String).split(";");
      final mime = type[0];
      final codecs = type[1];
      final baseurl = "http://127.0.0.1:${server.port}/$videoId/$itag/";
      final indexUri = "/$videoId/$itag/${index['start']}-${index['end']}.ts";
      final bandwidth = 8 * int.parse(value["len"]) ~/ durationInt;
      final seg = await getSegment(indexUri, videoId, durationInt, value);
      final segmentList = seg.buildXml();
      final item =
          "<Representation id=\"$itag\" bandwidth=\"$bandwidth\" $codecs mimeType=\"$mime\"><BaseURL>$baseurl</BaseURL>$segmentList</Representation>";
      if (mime.contains("video")) {
        videos.add(item);
      } else {
        audios.add(item);
      }
    }
    text.add("<AdaptationSet segmentAlignment=\"true\">");
    text.add(videos.join());
    text.add("</AdaptationSet>");
    text.add("<AdaptationSet segmentAlignment=\"true\">");
    text.add(audios.join());
    text.add("</AdaptationSet>");
    text.add("</Period></MPD>");
    return text.join();
  }

  dynamic findStream(Map<String, dynamic> streams, List<String> prefers) {
    for (final itag in prefers) {
      final item = streams[itag];
      if (item == null) {
        continue;
      }
      final init = item["initRange"] as Map<String, dynamic>;
      final index = item['indexRange'] as Map<String, dynamic>;
      final l = item['len'];
      if (l == null || l == "" || init.length != 2 || index.length != 2) {
        continue;
      }
      return item;
    }
  }

  String getMirror(String uri, List<String> mirrorlists) {
    final c = uri.hashCode % mirrorlists.length;
    return mirrorlists[c];
  }

  Uri buildUrl(String uri, String mirror) {
    final base = Uri.parse(mirror);
    return Uri(
      scheme: base.scheme,
      host: base.host,
      port: base.port,
      path: '${removeTrailing("/", base.path)}/${trimLeading("/", uri)}',
    );
  }

  // 首先尝试文件缓存,否则计算镜像请求http
  Future<Stream<List<int>>> fetch(String uri) async {
    final file = FileCacheManager.cache(uri);
    if (await file.ok) {
      final res = file.openRead();
      return res;
    }
    var mirrorList = [...mirrors];
    var i = 0;
    while (true) {
      final mirror = getMirror(uri, mirrorList);
      try {
        final curr = buildUrl(uri, mirror);
        final res = await get(curr);
        final s = await res.toList();
        await file.writeAsBytes(s);
        return Stream.fromIterable(s);
      } catch (e) {
        // ignore: avoid_print
        print("http fetch ts error $mirror $uri $i $retry $e");
        if (++i > retry) {
          // ignore: avoid_print
          print("retryed $i , still error $e");
          rethrow;
        }
        mirrorList.removeWhere((element) => element == mirror);
        if (mirrorList.isEmpty) {
          mirrorList = [...mirrors];
        }
      }
    }
  }

  // 根据uri负载均衡,我们要根据hash算法计算均衡逻辑
  Future<Stream<List<int>>> get(Uri uri) async {
    const timeout = Duration(seconds: 6);
    final req = await client.getUrl(uri);
    final res = await req.close().timeout(timeout);
    if (res.statusCode != HttpStatus.ok) {
      throw Exception("request $uri error , status ${res.statusCode}");
    }
    final data = res.timeout(timeout);
    return data;
  }

  Uri buildInfoUrl(String id, String mirror) {
    final base = Uri.parse(mirror);
    return Uri(
      scheme: base.scheme,
      host: base.host,
      port: base.port,
      path: "${removeTrailing("/", base.path)}/$id.json",
    );
  }

  Future<Map<String, dynamic>> videoinfo(String id) async {
    final v = cache.get(id);
    if (v != null) {
      return v;
    }
    final mirrorList = [...mirrors];
    if (mirrorList.length < retry) {
      mirrorList.addAll(mirrors);
    }
    var i = 0;
    var s = <String, dynamic>{};
    for (String item in mirrorList) {
      try {
        i++;
        final Uri curr = buildInfoUrl(id, item);
        s = await getvinfo(curr);
        cache.set(id, s);
        return s;
      } catch (e) {
        // ignore: avoid_print
        print("error when load videoinfo $id using $item : $e");
        if (i >= mirrorList.length) {
          rethrow;
        }
      }
    }
    return s;
  }

  Future<Map<String, dynamic>> getvinfo(Uri uri) async {
    final res = await get(uri);
    final body = await res.transform(utf8.decoder).join();
    final data = jsonDecode(body);
    return data;
  }

  Future<Segment> getSegment(
    String indexRange,
    String videoId,
    int durationInt,
    Map<String, dynamic> itagItem,
  ) async {
    final key = "$videoId:${itagItem['itag']}";
    final v = cache.get(key);
    if (v is Segment) {
      return v;
    }
    final res = await fetch(indexRange);
    final buffer = await res.reduce((a, b) => a + b);
    final ss = Segment(buffer, durationInt, itagItem);
    cache.set(key, ss);
    return ss;
  }
}
