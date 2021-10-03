import 'package:mediaindex_dart/mediaindex.dart';

class Segment {
  final List<int> buffer;
  final Map<String, dynamic> itagItem;
  final String itag;
  final String type;
  late List<List<int>> infoList;
  Segment(this.buffer, this.itagItem)
      : itag = itagItem['itag'],
        type = itagItem['type'] {
    final webm = type.contains('webm');
    final index = itagItem['indexRange'] as Map<String, dynamic>;
    final int indexEndOffset = int.parse(index['end']!);
    final int totalSize = int.parse(itagItem['len']);
    infoList = mediaindex(buffer, indexEndOffset, totalSize).parse(webm);
  }

  String buildXml() {
    final init = itagItem['initRange'] as Map<String, dynamic>;
    final audio = type.contains("audio");
    final List<String> text = [
      "<SegmentList duration=\"${audio?10:5}\">",
      '''<Initialization sourceURL="${init['start']}-${init['end']}.ts"/>'''
    ];
    for (final item in infoList) {
      final txt = '''<SegmentURL media="${item[0]}-${item[1] - 1}.ts"/>''';
      text.add(txt);
    }
    text.add("</SegmentList>");
    return text.join();
  }
}
