import 'dart:typed_data';

class PdfSecurityScanner {
  static String? scan(Uint8List bytes) {
    final content = String.fromCharCodes(bytes);

    if (_containsAny(content, ['/JS ', '/JS(', '/JavaScript'])) {
      return 'يحتوي الملف على كود JavaScript مضمّن';
    }

    if (_containsAny(content, ['/OpenAction', '/AA '])) {
      return 'يحتوي الملف على إجراءات تلقائية غير مسموح بها';
    }

    if (content.contains('/Launch')) {
      return 'يحتوي الملف على أوامر تشغيل خارجية';
    }

    if (content.contains('/URI')) {
      return 'يحتوي الملف على روابط خارجية مضمّنة';
    }

    if (_containsAny(content, ['/EmbeddedFile', '/Filespec'])) {
      return 'يحتوي الملف على مرفقات مضمّنة';
    }

    if (content.contains('/ImportData')) {
      return 'يحتوي الملف على طلبات استيراد بيانات';
    }

    if (_containsAny(content, ['/RichMedia', '/Flash'])) {
      return 'يحتوي الملف على وسائط تفاعلية غير مدعومة';
    }

    return null;
  }

  static bool _containsAny(String text, List<String> patterns) =>
      patterns.any(text.contains);
}
