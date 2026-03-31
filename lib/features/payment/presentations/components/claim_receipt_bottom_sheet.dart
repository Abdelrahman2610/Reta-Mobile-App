import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:printing/printing.dart';
import 'package:reta/core/network/dio_client.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/features/components/app_text.dart';
import 'package:reta/features/components/circular_progress_indicator_platform_widget.dart';
import 'package:share_plus/share_plus.dart' show Share, XFile;

void showClaimReceiptSheet(
  BuildContext context, {
  required String title,
  required String pdfUrl,
}) {
  log('PdfUrl: $pdfUrl');
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ClaimReceiptSheet(title: title, pdfUrl: pdfUrl),
  );
}

class _ClaimReceiptSheet extends StatefulWidget {
  final String title;
  final String pdfUrl;

  const _ClaimReceiptSheet({required this.title, required this.pdfUrl});

  @override
  State<_ClaimReceiptSheet> createState() => _ClaimReceiptSheetState();
}

class _ClaimReceiptSheetState extends State<_ClaimReceiptSheet> {
  Uint8List? _pdfBytes;
  Uint8List? _imageBytes;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (_isPdf) {
      _fetchPdf();
    } else {
      _fetchImage();
    }
  }

  Future<void> _fetchPdf() async {
    try {
      final response = await DioClient.instance.dio.get(
        widget.pdfUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      setState(() {
        _pdfBytes = Uint8List.fromList(response.data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchImage() async {
    try {
      final response = await DioClient.instance.dio.get(
        widget.pdfUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      setState(() {
        _imageBytes = Uint8List.fromList(response.data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _print() async {
    if (_pdfBytes == null) return;
    await Printing.layoutPdf(onLayout: (_) => _pdfBytes!);
  }

  Future<void> _share() async {
    if (_isPdf) {
      if (_pdfBytes == null) return;
      await Printing.sharePdf(
        bytes: _pdfBytes!,
        filename: '${widget.title}.pdf',
      );
    } else {
      if (_imageBytes == null) return;
      final xFile = XFile.fromData(
        _imageBytes!,
        name: '${widget.title}.jpg',
        mimeType: 'image/jpeg',
      );
      await Share.shareXFiles([xFile]);
    }
  }

  bool get _isPdf =>
      widget.pdfUrl.toLowerCase().endsWith('.pdf') ||
      widget.pdfUrl.toLowerCase().contains('.pdf');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 36),
                AppText(
                  text: widget.title,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutralDarkDarkest,
                ),

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 18),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Content
          Expanded(
            child: _isLoading
                ? const CircularProgressIndicatorPlatformWidget()
                : _error != null
                ? Center(
                    child: AppText(
                      text: 'حدث خطأ أثناء تحميل الملف',
                      fontSize: 14.sp,
                      color: AppColors.neutralDarkMedium,
                      alignment: AlignmentDirectional.center,
                    ),
                  )
                : _isPdf
                ? PdfPreview(
                    build: (_) => _pdfBytes!,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                    canDebug: false,
                    allowPrinting: false,
                    allowSharing: false,
                    pdfFileName: '${widget.title}.pdf',
                  )
                : _imageBytes != null
                ? InteractiveViewer(
                    child: Center(
                      child: Image.memory(_imageBytes!, fit: BoxFit.contain),
                    ),
                  )
                : AppText(
                    text: 'حدث خطأ أثناء تحميل الصورة',
                    fontSize: 14.sp,
                    color: AppColors.neutralDarkMedium,
                    alignment: AlignmentDirectional.center,
                  ),
          ),
          // Bottom actions
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 8.h),
            decoration: BoxDecoration(color: Color(0xFFEDEDED)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ActionButton(icon: Icons.share_outlined, onTap: _share),
                _ActionButton(icon: Icons.print_outlined, onTap: _print),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52.w,
        height: 52.w,
        decoration: BoxDecoration(
          color: AppColors.neutralLightMedium,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 22.sp, color: AppColors.neutralDarkDarkest),
      ),
    );
  }
}
