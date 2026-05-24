import 'dart:html' as html;
import 'dart:convert';
import 'dart:typed_data';

void triggerCsvDownload(String content, String filename) {
  // BOM en bytes bruts + encodage UTF-8 explicite → accents garantis dans Excel
  const bom = [0xEF, 0xBB, 0xBF];
  final contentBytes = utf8.encode(content);
  final bytes = Uint8List.fromList([...bom, ...contentBytes]);

  final blob = html.Blob([bytes.buffer], 'text/csv;charset=utf-8;');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..style.display = 'none';
  html.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);
}
