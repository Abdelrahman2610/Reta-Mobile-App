import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/core/network/dio_client.dart';
import 'package:reta/features/auth/data/repositories/profile_verification_repository.dart';
import 'package:reta/features/auth/presentation/cubit/user_profile_cubit.dart';
import 'package:reta/features/auth/presentation/cubit/user_profile_state.dart';
import 'package:reta/features/auth/presentation/pages/edit_profile_otp_page.dart';
import 'package:reta/features/auth/presentation/pages/email_verification_page.dart';
import 'package:reta/features/auth/presentation/pages/phone_verification_page.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/user_models.dart';

class UserProfilePage extends StatelessWidget {
  // final UserModel user;

  const UserProfilePage({
    super.key,
    // required this.user
  });

  @override
  Widget build(BuildContext context) {
    // return BlocProvider(
    //   create: (_) => UserProfileCubit()..loadFromUser(user),
    //   child: const _UserProfileView(),
    // );
    return const _UserProfileView();
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _UserProfileView extends StatefulWidget {
  const _UserProfileView();

  @override
  State<_UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<_UserProfileView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<UserProfileCubit>().loadFromUser(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutralLightLight,
        appBar: const _ProfileAppBar(),
        body: BlocConsumer<UserProfileCubit, UserProfileState>(
          listenWhen: (_, current) => true,
          listener: (context, state) {
            if (state is UserProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    textDirection: TextDirection.rtl,
                  ),
                  backgroundColor: AppColors.errorDark,
                ),
              );
            }

            // ── Password changed ─────────────────────────────────────────────
            if (state is UserProfilePasswordChanged) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    textDirection: TextDirection.rtl,
                  ),
                  backgroundColor: AppColors.successMedium,
                ),
              );
            }

            if (state is UserProfileUpdateSuccess) {
              // ── Email verification sent ──────────────────────────────────────
              if (state.emailVerificationSent &&
                  state.editedField == ProfileEditField.email) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        const Icon(
                          Icons.mail_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'تم إرسال رابط التحقق إلى بريدك الإلكتروني',
                            textDirection: TextDirection.rtl,
                            style: AppTextStyles.bodyM.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: AppColors.highlightDarkest,
                    duration: const Duration(seconds: 4),
                  ),
                );
              }

              // ── OTP sent for phone change ────────────────────────────────────
              if (state.otpData != null &&
                  state.otpData!.ok &&
                  state.editedField == ProfileEditField.phone) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<UserProfileCubit>(),
                      child: EditProfileOtpPage(otpData: state.otpData!),
                    ),
                  ),
                );
                return;
              }

              if (state.editedField != null && !state.emailVerificationSent) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message.isNotEmpty
                          ? state.message
                          : 'تم التحديث بنجاح',
                      textDirection: TextDirection.rtl,
                    ),
                    backgroundColor: AppColors.successMedium,
                  ),
                );
              }
            }
          },
          buildWhen: (_, current) =>
              current is UserProfileLoaded ||
              current is UserProfileUpdating ||
              current is UserProfileInitial ||
              current is UserProfileError ||
              current is UserProfileUpdateSuccess ||
              current is UserProfilePasswordChanged ||
              current is UserProfilePhoneConfirmed,
          builder: (context, state) {
            if (state is UserProfileLoaded) {
              return _ProfileBody(userModel: state.userModel);
            }
            // For error/success/confirmed states, show the last known
            // loaded body if available, otherwise show spinner briefly
            // (loadFromUser will emit UserProfileLoaded shortly after).
            if (state is UserProfileError ||
                state is UserProfileUpdateSuccess ||
                state is UserProfilePasswordChanged ||
                state is UserProfilePhoneConfirmed) {
              // These are transient — loadFromUser() is always called
              // after them now, so a brief spinner is acceptable.
              return const Center(child: CircularProgressIndicator());
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ProfileAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.neutralLightDarkest,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: AppColors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: AppColors.mainBlueSecondary,
          size: 20.sp,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'بيانات المستخدم',
        style: AppTextStyles.actionXL.copyWith(
          color: AppColors.mainBlueSecondary,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

// ─────────────────────────────────────────────────────────────────────────────

class _ProfileBody extends StatefulWidget {
  final UserModel userModel;

  const _ProfileBody({required this.userModel});

  @override
  State<_ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<_ProfileBody> {
  String? _editingField;
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (final c in _controllers.values) c.dispose();
    super.dispose();
  }

  TextEditingController _controllerFor(String field, String initialValue) {
    return _controllers.putIfAbsent(
      field,
      () => TextEditingController(text: initialValue),
    );
  }

  void _startEditing(String field) => setState(() => _editingField = field);
  void _cancelEditing() => setState(() => _editingField = null);

  void _saveField(BuildContext context, String field) {
    final value = _controllers[field]?.text.trim() ?? '';
    if (value.isEmpty) return;
    setState(() => _editingField = null);

    final cubit = context.read<UserProfileCubit>();
    switch (field) {
      case 'email':
        cubit.editProfile(email: value);
      case 'phone':
        cubit.editProfile(phone: value);
      case 'nationalId':
        cubit.editProfile(nationalId: value);
      case 'passport':
        cubit.editProfile(passportNumber: value);
    }
  }

  // ── Navigation helpers ────────────────────────────────────────────────────

  Future<void> _openPhoneVerification(
    BuildContext context,
    String phone,
  ) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => PhoneVerificationPage(phone: phone)),
    );
    if (result == true && context.mounted) {
      context.read<UserProfileCubit>().loadFromUser(null);
    }
  }

  Future<void> _openEmailVerification(
    BuildContext context,
    String email,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => EmailVerificationPage(email: email)),
    );
    if (context.mounted) {
      context.read<UserProfileCubit>().loadFromUser(null);
    }
  }

  Future<void> _triggerIdentityVerification(BuildContext context) async {
    final repo = ProfileVerificationRepository();
    final result = await repo.validateIdentity();
    if (!context.mounted) return;

    final msg = switch (result) {
      ApiSuccess(:final data) => data,
      ApiError(:final message) => message,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, textDirection: TextDirection.rtl),
        backgroundColor: result is ApiSuccess
            ? AppColors.successMedium
            : AppColors.errorDark,
      ),
    );

    if (result is ApiSuccess) {
      context.read<UserProfileCubit>().loadFromUser(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.userModel;

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            _ReadOnlyField(
              label: 'الاسم الكامل',
              value:
                  [
                        u.firstname,
                        u.secondName,
                        u.thirdName,
                        u.fourthName,
                        u.lastname,
                      ]
                      .where((part) => part != null && part.trim().isNotEmpty)
                      .join(' '),
            ),
            const _Divider(),

            // ── Email ────────────────────────────────────────────────────
            _EditableField(
              label: 'البريد الإلكتروني',
              value: u.email ?? '',
              fieldKey: 'email',
              keyboardType: TextInputType.emailAddress,
              isEditing: _editingField == 'email',
              isVerified: u.emailVerified ?? false,
              showVerifyButton: !(u.emailVerified ?? false),
              controller: _controllerFor('email', u.email ?? ''),
              onEditTap: () => _startEditing('email'),
              onSave: () => _saveField(context, 'email'),
              onCancel: _cancelEditing,
              onVerifyTap: () => _openEmailVerification(context, u.email ?? ''),
            ),
            const _Divider(),

            // ── Phone ────────────────────────────────────────────────────
            _EditableField(
              label: 'رقم الهاتف المحمول',
              value: u.phone ?? '',
              fieldKey: 'phone',
              keyboardType: TextInputType.phone,
              isEditing: _editingField == 'phone',
              isVerified: u.phoneVerified ?? false,
              showVerifyButton: !(u.phoneVerified ?? false),
              controller: _controllerFor('phone', u.phone ?? ''),
              onEditTap: () => _startEditing('phone'),
              onSave: () => _saveField(context, 'phone'),
              onCancel: _cancelEditing,
              onVerifyTap: () => _openPhoneVerification(context, u.phone ?? ''),
            ),
            const _Divider(),

            _ReadOnlyField(label: 'الجنسية', value: u.nationality ?? ''),
            const _Divider(),

            // ── National ID / Passport ────────────────────────────────────
            if (u.isEgyptian) ...[
              _EditableField(
                label: 'الرقم القومي',
                value: u.nationalId ?? '',
                fieldKey: 'nationalId',
                keyboardType: TextInputType.number,
                isEditing: _editingField == 'nationalId',
                isVerified: u.nationalIdVerified ?? false,
                showVerifyButton: !(u.nationalIdVerified ?? false),
                hideEditWhenVerified: true,
                controller: _controllerFor('nationalId', u.nationalId ?? ''),
                onEditTap: () => _startEditing('nationalId'),
                onSave: () => _saveField(context, 'nationalId'),
                onCancel: _cancelEditing,
                onVerifyTap: () => _triggerIdentityVerification(context),
              ),
            ] else ...[
              _EditableField(
                label: 'رقم جواز السفر',
                value: u.passportNumber ?? '',
                fieldKey: 'passport',
                keyboardType: TextInputType.text,
                isEditing: _editingField == 'passport',
                isVerified: u.nationalIdVerified ?? false,
                showVerifyButton: !(u.nationalIdVerified ?? false),
                hideEditWhenVerified: true,
                controller: _controllerFor('passport', u.passportNumber ?? ''),
                onEditTap: () => _startEditing('passport'),
                onSave: () => _saveField(context, 'passport'),
                onCancel: _cancelEditing,
                onVerifyTap: () => _triggerIdentityVerification(context),
              ),
            ],
            const _Divider(),

            // ── Attachment ────────────────────────────────────────────────
            _AttachmentField(
              label: 'مرفق الرقم القومي/جواز السفر',
              isEgyptian: u.isEgyptian,
            ),
            const _Divider(),

            _ReadOnlyField(label: 'تاريخ الميلاد', value: u.dateOfBirth ?? ''),
            const _Divider(),
            _ReadOnlyField(label: 'محل الميلاد', value: u.placeOfBirth ?? ''),
            const _Divider(),
            _ReadOnlyField(label: 'النوع', value: u.gender ?? ''),
            const _Divider(),

            _ReadOnlyField(
              label: 'كلمة المرور',
              value: '',
              trailing: _EditLink(onTap: () => _showPasswordDialog(context)),
            ),
            SizedBox(height: 6.h),
            const _Divider(),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  void _showPasswordDialog(BuildContext context) {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('تغيير كلمة المرور', style: AppTextStyles.h5),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'كلمة المرور الحالية',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'كلمة المرور الجديدة',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'تأكيد كلمة المرور الجديدة',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                final current = currentCtrl.text.trim();
                final newPass = newCtrl.text.trim();
                final confirm = confirmCtrl.text.trim();

                if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
                  return;
                }

                if (newPass != confirm) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'كلمة المرور الجديدة غير متطابقة',
                        textDirection: TextDirection.rtl,
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Navigator.of(ctx).pop();

                context.read<UserProfileCubit>().editPassword(
                  currentPassword: current,
                  newPassword: newPass,
                  confirmPassword: confirm,
                );
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Editable field ───────────────────────────────────────────────────────────

class _EditableField extends StatelessWidget {
  final String label;
  final String value;
  final String fieldKey;
  final TextInputType keyboardType;
  final bool isEditing;
  final bool isVerified;
  final bool showVerifyButton;
  final TextEditingController controller;
  final VoidCallback onEditTap;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final VoidCallback? onVerifyTap;
  final bool hideEditWhenVerified;

  const _EditableField({
    required this.label,
    required this.value,
    required this.fieldKey,
    required this.keyboardType,
    required this.isEditing,
    required this.isVerified,
    required this.showVerifyButton,
    required this.controller,
    required this.onEditTap,
    required this.onSave,
    required this.onCancel,
    required this.onVerifyTap,
    this.hideEditWhenVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                textDirection: TextDirection.rtl,
                style: AppTextStyles.h6.copyWith(
                  color: AppColors.neutralDarkDarkest,
                ),
              ),
              if (!isEditing)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isVerified) ...[
                      Text(
                        'تم التحقق',
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.actionM.copyWith(
                          color: AppColors.successMedium,
                        ),
                      ),
                      SizedBox(width: 8.w),
                    ],
                    if (!(isVerified && hideEditWhenVerified))
                      _EditLink(onTap: onEditTap),
                  ],
                ),
            ],
          ),
          SizedBox(height: 6.h),

          if (isEditing) ...[
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              textDirection: TextDirection.ltr,
              autofocus: true,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: AppColors.highlightDarkest,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 34.h,
                  child: ElevatedButton(
                    onPressed: onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.highlightDarkest,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                    ),
                    child: Text(
                      'حفظ',
                      style: AppTextStyles.actionM.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                SizedBox(
                  height: 34.h,
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.neutralDarkLight,
                      side: BorderSide(color: AppColors.neutralLightDark),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                    ),
                    child: Text(
                      'إلغاء',
                      style: AppTextStyles.actionM.copyWith(
                        color: AppColors.neutralDarkLight,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            if (value.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  value,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.bodyXL.copyWith(
                    color: AppColors.neutralDarkLight,
                  ),
                ),
              ),
            if (showVerifyButton && onVerifyTap != null) ...[
              SizedBox(height: 8.h),
              Align(
                alignment: Alignment.centerLeft,
                child: _VerifyButton(onTap: onVerifyTap!),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

// ─── Read-only field ──────────────────────────────────────────────────────────

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;

  const _ReadOnlyField({
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                textDirection: TextDirection.rtl,
                style: AppTextStyles.h6.copyWith(
                  color: AppColors.neutralDarkDarkest,
                ),
              ),
              trailing ?? const SizedBox.shrink(),
            ],
          ),
          if (value.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: AppTextStyles.bodyXL.copyWith(
                  color: AppColors.neutralDarkLight,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Small reusable widgets ───────────────────────────────────────────────────

class _EditLink extends StatelessWidget {
  final VoidCallback? onTap;

  const _EditLink({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        'تعديل',
        textDirection: TextDirection.rtl,
        style: AppTextStyles.bodyM.copyWith(color: AppColors.highlightDarkest),
      ),
    );
  }
}

class _VerifyButton extends StatelessWidget {
  final VoidCallback onTap;

  const _VerifyButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32.h,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.errorDark,
          side: BorderSide(color: AppColors.errorDark, width: 1.2.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          minimumSize: Size(60.w, 32.h),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          'تأكيد',
          style: AppTextStyles.actionM.copyWith(color: AppColors.errorDark),
        ),
      ),
    );
  }
}

// ─── Attachment field ────────────────────────────────────────────────────────
class _AttachmentField extends StatefulWidget {
  final String label;
  final bool isEgyptian;

  const _AttachmentField({required this.label, required this.isEgyptian});

  @override
  State<_AttachmentField> createState() => _AttachmentFieldState();
}

class _AttachmentFieldState extends State<_AttachmentField> {
  bool _uploading = false;

  Future<void> _pickAndUpload() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result == null || result.files.single.path == null) return;

    final file = File(result.files.single.path!);

    setState(() => _uploading = true);

    try {
      if (!mounted) return;
      await context.read<UserProfileCubit>().editProfileWithFile(
        file: file,
        isEgyptian: widget.isEgyptian,
      );
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubitState = context.watch<UserProfileCubit>().state;
    final files = cubitState is UserProfileLoaded
        ? (widget.isEgyptian
              ? (cubitState.userModel.nationalIdFiles ?? [])
              : (cubitState.userModel.passportFiles ?? []))
        : <Map<String, dynamic>>[];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                textDirection: TextDirection.rtl,
                style: AppTextStyles.h6.copyWith(
                  color: AppColors.neutralDarkDarkest,
                ),
              ),
              _uploading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.highlightDarkest,
                      ),
                    )
                  : _EditLink(onTap: _pickAndUpload),
            ],
          ),
          SizedBox(height: 8.h),

          if (files.isEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'لا توجد مرفقات',
                textDirection: TextDirection.rtl,
                style: AppTextStyles.bodyXL.copyWith(
                  color: AppColors.neutralDarkLight,
                ),
              ),
            )
          else
            Column(
              children: files.asMap().entries.map((entry) {
                final index = entry.key;
                final file = entry.value;
                final rawPath = file['url']?.toString() ?? '';
                final cleanPath = rawPath.replaceFirst('public/', '');
                final url = '${ApiConstants.baseUrl}/files/$cleanPath';
                return _AttachmentRow(
                  key: ValueKey(url),
                  url: url,
                  fileName:
                      file['original_file_name']?.toString() ??
                      'الملف ${index + 1}',
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

// ─── Attachment row ───────────────────────────────────────────────────────────

class _AttachmentRow extends StatefulWidget {
  final String url;
  final String fileName;

  const _AttachmentRow({super.key, required this.url, required this.fileName});

  @override
  State<_AttachmentRow> createState() => _AttachmentRowState();
}

class _AttachmentRowState extends State<_AttachmentRow> {
  Uint8List? _bytes;
  bool _loading = false;

  Future<void> _fetchAndOpen(BuildContext context) async {
    if (_bytes != null) {
      _openFullScreen(context);
      return;
    }
    setState(() => _loading = true);
    try {
      final dio = DioClient.instance.dio;
      final response = await dio.get<List<int>>(
        widget.url,
        options: Options(responseType: ResponseType.bytes),
      );
      if (mounted) {
        _bytes = Uint8List.fromList(response.data!);
        setState(() => _loading = false);
        _openFullScreen(context);
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تعذر تحميل الملف (${e.response?.statusCode})',
              textDirection: TextDirection.rtl,
            ),
            backgroundColor: AppColors.errorDark,
          ),
        );
      }
    }
  }

  void _openFullScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.memory(_bytes!, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.neutralLightLight,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.neutralLightDarkest),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Icon(
            Icons.image_outlined,
            color: AppColors.highlightDarkest,
            size: 18,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              widget.fileName,
              textDirection: TextDirection.rtl,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyM.copyWith(
                color: AppColors.neutralDarkLight,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          _loading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.highlightDarkest,
                  ),
                )
              : GestureDetector(
                  onTap: () => _fetchAndOpen(context),
                  child: Text(
                    'عرض',
                    style: AppTextStyles.bodyM.copyWith(
                      color: AppColors.highlightDarkest,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

// ─── Divider ──────────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.neutralLightDarkest,
      indent: 16.w,
      endIndent: 16.w,
    );
  }
}
