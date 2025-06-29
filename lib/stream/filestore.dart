import 'dart:io';

import 'package:path_provider/path_provider.dart';

final fileNameReg = RegExp(r"(\d+)-(\d+).ts");

class FileCache {
  String uri;
  Directory appDocDir;
  late File file;
  FileCache(this.uri, this.appDocDir) {
    file = File("${appDocDir.path}/cache$uri");
  }
  Future<bool> get ok async {
    if (await file.exists()) {
      final l = await file.length();
      final matches = fileNameReg.firstMatch(uri);
      final start = int.parse(matches?.group(1) ?? "");
      final end = int.parse(matches?.group(2) ?? "");
      if (end - start + 1 == l) {
        return true;
      }
    }
    return false;
  }

  Stream<List<int>> openRead() {
    return file.openRead();
  }

  Future<void> writeAsBytes(List<List<int>> bytes) async {
    await file.parent.create(recursive: true);
    for (final item in bytes) {
      await file.writeAsBytes(item);
    }
  }
}

class FileCacheManager {
  static late Directory appDocDir;

  static Future<void> init() async {
    appDocDir = await getApplicationDocumentsDirectory();
  }

  static FileCache cache(String uri) {
    return FileCache(uri, appDocDir);
  }
}
