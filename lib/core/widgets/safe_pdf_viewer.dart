import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class SafePdfViewer extends StatefulWidget {
  final Uint8List bytes;
  final String fileName;

  const SafePdfViewer({required this.bytes, required this.fileName});

  @override
  State<SafePdfViewer> createState() => SafePdfViewerState();
}

class SafePdfViewerState extends State<SafePdfViewer> {
  String? _tempPath;

  @override
  void initState() {
    super.initState();
    _writeTempFile();
  }

  Future<void> _writeTempFile() async {
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/preview_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(widget.bytes);
    if (mounted) setState(() => _tempPath = file.path);
  }

  @override
  void dispose() {
    if (_tempPath != null) {
      File(_tempPath!).deleteSync();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.fileName,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _tempPath == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: _tempPath!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
            ),
    );
  }
}
