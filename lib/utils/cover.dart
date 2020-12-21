String videoCover(dynamic item) {
  String id = "";
  var v = item["id"];
  if (v is String) {
    id = v;
  } else {
    id = v["videoId"];
  }
  return "https://stream.pull.workers.dev/video/" + id + ".jpg?v8";
}
