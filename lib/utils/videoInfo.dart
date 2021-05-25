String videoCover(Object item) {
  final String id = getVideoId(item);
  if (id == "") {
    return "https://assets.suconghou.cn/defaultImg.png";
  }
  return "https://ts.suconghou.cn/video/" + id + ".jpg";
}

String getVideoTitle(dynamic item) {
  var v = item["snippet"];
  if (v is Map) {
    return v["title"];
  }
  return "";
}

String getVideoDesc(dynamic item) {
  var v = item["snippet"];
  if (v is Map) {
    return v["description"];
  }
  return "";
}

// 兼容playlist 中的ID, 检测 youtube#playlist
String getVideoId(dynamic item) {
  String id = "";
  if (item["kind"] == "youtube#playlist") {
    return getPlayListVid(item);
  }
  var c = item["contentDetails"];
  if (c is Map) {
    if (c["videoId"] is String) {
      return c["videoId"];
    }
  }
  var v = item["id"];
  if (v is String) {
    id = v;
  } else {
    id = v["videoId"];
  }
  return id;
}

String getPlayListVid(dynamic item) {
  var s = item['snippet'];
  if (s is Map) {
    var t = s['thumbnails'];
    if (t is Map) {
      var w = t['medium'];
      if (t['default'] is Map) {
        w = t['default'];
      } else if (t['standard'] is Map) {
        w = t['standard'];
      } else if (t['high'] is Map) {
        w = t['high'];
      }
      var u = w['url'];
      var r = RegExp(r"/([\w\-]{6,12})/");
      var match = r.firstMatch(u);
      return match?.group(1) ?? "";
    }
  }
  return '';
}

String getChannelId(dynamic item) {
  String id = "";
  var v = item["snippet"];
  if (v is Map) {
    id = v["channelId"];
  }
  return id;
}

String getChannelTitle(dynamic item) {
  String title = "";
  var v = item["snippet"];
  if (v is Map) {
    title = v["channelTitle"];
  }
  return title;
}

String viewCount(dynamic item) {
  var n = 0;
  var v = item["statistics"];
  if (v is Map) {
    n = int.parse(v["viewCount"]);
  }
  if (n < 1) {
    return "";
  }
  if (n > 10000) {
    return "${(n / 1000).round()}万观看";
  }
  return "$n观看";
}

String pubAt(dynamic item) {
  var v = item["snippet"];
  var n = 0;
  if (v is Map) {
    var t = DateTime.parse(v["publishedAt"]);
    n = t.millisecondsSinceEpoch;
  }
  var d = (DateTime.now().millisecondsSinceEpoch - n) / 1000;
  const f = [
    [31536000, '年'],
    [2592000, '个月'],
    [604800, '星期'],
    [86400, '天'],
    [3600, '小时'],
    [60, '分钟'],
    [1, '秒']
  ];
  for (var i = 0; i < f.length; i++) {
    var t = f[i][0] as num;
    var e = f[i][1];
    var c = (d / t).floor();
    if (c != 0 && c > 0) {
      return "$c$e前";
    }
  }
  return "刚刚";
}

String duration(dynamic item) {
  var v = item["contentDetails"];
  if (v is Map) {
    var t = v["duration"].toString();
    if (t == "P0D") {
      return "直播";
    }
    var r = RegExp(r"([1-9]+)M$");
    var f = r.firstMatch(t);
    if (f != null) {
      var f1 = f.group(1)!;
      if (f1.length == 1) {
        return "0$f1:00";
      }
      return "$f1:00";
    }
    r = RegExp(r"\d+");
    var arr = [];
    for (var item in r.allMatches(t)) {
      var x = item.group(0)!;
      if (x.length == 1) {
        arr.add("0$x");
      } else {
        arr.add(x);
      }
    }
    return arr.join(":");
  }
  return "";
}

String getSubscriberCount(dynamic item) {
  var v = item["statistics"];
  var n = 0;
  if (v is Map) {
    var c = v["subscriberCount"];
    if (c is String) {
      n = int.parse(c);
    }
  }
  if (n < 1) {
    return "";
  }
  if (n > 10000) {
    return "${(n / 1000).round()}万订阅者";
  }
  return "$n订阅者";
}

String getVideoCount(dynamic item) {
  var v = item["statistics"];
  var n = 0;
  if (v is Map) {
    var c = v["videoCount"];
    if (c is String) {
      n = int.parse(c);
    }
  }
  return "$n个视频";
}

String getChannelUploadId(dynamic item) {
  var v = item["contentDetails"];
  if (v is Map) {
    var c = v["relatedPlaylists"];
    if (c is Map) {
      return c["uploads"];
    }
  }
  return "";
}

String getChannelFavoriteId(dynamic item) {
  var v = item["contentDetails"];
  if (v is Map) {
    var c = v["favorites"];
    if (c is Map) {
      return c["uploads"];
    }
  }
  return "";
}
