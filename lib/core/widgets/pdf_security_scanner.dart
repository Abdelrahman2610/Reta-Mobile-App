import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class PdfSecurityScanner {
  static String? scan(Uint8List bytes) {
    final rawThreat = _scanContent(bytes, compressed: false);
    if (rawThreat != null) return rawThreat;

    final streamThreat = _scanDecompressedStreams(bytes);
    if (streamThreat != null) return streamThreat;

    return null;
  }

  static String? _scanContent(Uint8List bytes, {required bool compressed}) {
    final content = latin1.decode(bytes, allowInvalid: true);

    final normalized = _normalize(content);

    for (final rule in _rules) {
      if (rule.matches(normalized)) {
        return compressed ? '${rule.message} (داخل تدفق مضغوط)' : rule.message;
      }
    }
    return null;
  }

  static String? _scanDecompressedStreams(Uint8List bytes) {
    final raw = latin1.decode(bytes, allowInvalid: true);
    int searchFrom = 0;

    while (true) {
      final streamStart = _findStreamStart(raw, searchFrom);
      if (streamStart == -1) break;

      final streamEnd = raw.indexOf('endstream', streamStart);
      if (streamEnd == -1) break;

      final streamBytes = bytes.sublist(streamStart, streamEnd);

      final dictRegion = raw.substring(
        (streamStart - 300).clamp(0, raw.length),
        streamStart,
      );

      if (dictRegion.contains('FlateDecode') ||
          dictRegion.contains('Fl\x20') ||
          dictRegion.contains('/F ')) {
        try {
          final decompressed = Uint8List.fromList(zlib.decode(streamBytes));
          final threat = _scanContent(decompressed, compressed: true);
          if (threat != null) return threat;
        } catch (_) {}
      }

      searchFrom = streamEnd + 9;
    }

    return null;
  }

  static int _findStreamStart(String content, int from) {
    int idx = content.indexOf('stream\r\n', from);
    int idx2 = content.indexOf('stream\n', from);

    if (idx == -1 && idx2 == -1) return -1;
    if (idx == -1) return idx2 + 7;
    if (idx2 == -1) return idx + 8;
    return idx < idx2 ? idx + 8 : idx2 + 7;
  }

  static String _normalize(String raw) {
    final hexResolved = raw.replaceAllMapped(
      RegExp(r'#([0-9A-Fa-f]{2})'),
      (m) => String.fromCharCode(int.parse(m.group(1)!, radix: 16)),
    );

    return hexResolved.replaceAll(RegExp(r'(?<=/\w*)\s+(?=\w)'), '');
  }

  static final List<_ThreatRule> _rules = [
    _PatternRule(
      patterns: ['/JS ', '/JS(', '/JS\n', '/JS\r', '/JavaScript'],
      message: 'يحتوي الملف على كود JavaScript مضمّن',
    ),

    _PatternRule(
      patterns: [
        '<script',
        'javascript:',
        'vbscript:',
        'onload=',
        'onerror=',
        'eval(',
        'document.cookie',
        'XMLHttpRequest',
        'fetch(',
        'window.location',
        'atob(',
        'fromCharCode',
      ],
      message: 'يحتوي الملف على نمط XSS أو JavaScript',
    ),

    _PatternRule(
      patterns: ['/OpenAction', '/AA '],
      message: 'يحتوي الملف على إجراءات تلقائية غير مسموح بها',
    ),

    _PatternRule(
      patterns: ['/Launch'],
      message: 'يحتوي الملف على أوامر تشغيل خارجية',
    ),

    _RegexRule(
      pattern: RegExp(r'/URI\s*\(?\s*javascript:', caseSensitive: false),
      message: 'يحتوي الملف على رابط JavaScript مضمّن في تعليق أو حقل',
    ),
    _RegexRule(
      pattern: RegExp(r'/URI\s*\(?\s*vbscript:', caseSensitive: false),
      message: 'يحتوي الملف على رابط VBScript مضمّن',
    ),

    _PatternRule(
      patterns: ['/EmbeddedFile', '/Filespec'],
      message: 'يحتوي الملف على مرفقات مضمّنة',
    ),
    _PatternRule(
      patterns: ['/ImportData'],
      message: 'يحتوي الملف على طلبات استيراد بيانات',
    ),
    _PatternRule(
      patterns: ['/SubmitForm'],
      message: 'يحتوي الملف على إجراء إرسال نموذج',
    ),

    _PatternRule(
      patterns: ['/RichMedia', '/Flash', '/Movie', '/Sound'],
      message: 'يحتوي الملف على وسائط تفاعلية غير مدعومة',
    ),

    _PatternRule(
      patterns: ['/ASCIIHexDecode', '/ASCII85Decode'],
      message: 'يحتوي الملف على ترميز غير اعتيادي قد يُستخدم لإخفاء محتوى ضار',
    ),
  ];
}

abstract class _ThreatRule {
  String get message;
  bool matches(String normalizedContent);
}

class _PatternRule extends _ThreatRule {
  final List<String> patterns;
  @override
  final String message;

  _PatternRule({required this.patterns, required this.message});

  @override
  bool matches(String content) => patterns.any(content.contains);
}

class _RegexRule extends _ThreatRule {
  final RegExp pattern;
  @override
  final String message;

  _RegexRule({required this.pattern, required this.message});

  @override
  bool matches(String content) => pattern.hasMatch(content);
}
