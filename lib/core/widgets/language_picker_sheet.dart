import 'package:flutter/material.dart';

Future<String?> showLanguagePickerSheet(
  BuildContext context, {
  required String currentLanguage,
}) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _LanguagePickerSheet(currentLanguage: currentLanguage),
  );
}

class _LanguagePickerSheet extends StatefulWidget {
  final String currentLanguage;

  const _LanguagePickerSheet({required this.currentLanguage});

  @override
  State<_LanguagePickerSheet> createState() => _LanguagePickerSheetState();
}

class _LanguagePickerSheetState extends State<_LanguagePickerSheet> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'تغيير اللغة',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 20),
          _LanguageOption(
            label: 'عربي',
            langCode: 'ar',
            selected: _selected == 'ar',
            onTap: () => setState(() => _selected = 'ar'),
          ),
          const SizedBox(height: 8),
          _LanguageOption(
            label: 'English',
            langCode: 'en',
            selected: _selected == 'en',
            onTap: () => setState(() => _selected = 'en'),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A3A5C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(_selected),
              child: const Text(
                'تأكيد',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final String langCode;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.langCode,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF1A3A5C).withOpacity(0.07)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF1A3A5C) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: langCode,
              groupValue: selected ? langCode : '',
              onChanged: (_) => onTap(),
              activeColor: const Color(0xFF1A3A5C),
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected
                    ? const Color(0xFF1A3A5C)
                    : const Color(0xFF616161),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
