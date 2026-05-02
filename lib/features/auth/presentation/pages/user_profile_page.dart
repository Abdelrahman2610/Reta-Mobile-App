import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/core/network/api_constants.dart';
import 'package:reta/core/network/api_result.dart';
import 'package:reta/core/network/dio_client.dart';
import 'package:reta/core/widgets/pdf_security_scanner.dart';
import 'package:reta/core/widgets/safe_pdf_viewer.dart';
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

            if (state is UserProfileAttachmentUploadSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    textDirection: TextDirection.rtl,
                  ),
                  backgroundColor: AppColors.successMedium,
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'حسناً',
                    textColor: AppColors.white,
                    onPressed: () =>
                        ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                  ),
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
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'حسناً',
                    textColor: AppColors.white,
                    onPressed: () =>
                        ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                  ),
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
                    action: SnackBarAction(
                      label: 'حسناً',
                      textColor: AppColors.white,
                      onPressed: () =>
                          ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                    ),
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
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'حسناً',
                      textColor: AppColors.white,
                      onPressed: () =>
                          ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                    ),
                  ),
                );
              }
            }
          },
          buildWhen: (_, current) =>
              current is UserProfileLoaded ||
              current is UserProfileUpdating ||
              current is UserProfileAttachmentUploading ||
              current is UserProfileAttachmentUploadSuccess ||
              current is UserProfileInitial ||
              current is UserProfileError ||
              current is UserProfileUpdateSuccess ||
              current is UserProfilePasswordChanged ||
              current is UserProfilePhoneConfirmed,
          builder: (context, state) {
            if (state is UserProfileLoaded) {
              return _ProfileBody(userModel: state.userModel);
            }
            if (state is UserProfileError ||
                state is UserProfileUpdateSuccess ||
                state is UserProfilePasswordChanged ||
                state is UserProfilePhoneConfirmed) {
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
  final _currentPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  @override
  void dispose() {
    for (final c in _controllers.values) c.dispose();
    _currentPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
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
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'حسناً',
          textColor: AppColors.white,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );

    if (result is ApiSuccess) {
      context.read<UserProfileCubit>().loadFromUser(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.userModel;
    final isVerified = u.nationalIdVerified ?? false;

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            _NameField(
              firstName: u.firstname ?? '',
              restOfName: [
                u.secondName,
                u.thirdName,
                u.fourthName,
                u.lastname,
              ].where((p) => p != null && p.trim().isNotEmpty).join(' '),
              isVerified: isVerified,
              onSave: (firstName, restOfName) {
                context.read<UserProfileCubit>().editProfile(
                  firstName: firstName,
                  lastName: restOfName,
                );
              },
            ),
            const _Divider(),

            // if (isVerified) ...[
            //   _EditableField(
            //     label: 'البريد الإلكتروني',
            //     value: u.email ?? '',
            //     fieldKey: 'email',
            //     keyboardType: TextInputType.emailAddress,
            //     isEditing: _editingField == 'email',
            //     isVerified: u.emailVerified ?? false,
            //     showVerifyButton: !(u.emailVerified ?? false),
            //     controller: _controllerFor('email', u.email ?? ''),
            //     onEditTap: () => _startEditing('email'),
            //     onSave: () => _saveField(context, 'email'),
            //     onCancel: _cancelEditing,
            //     onVerifyTap: () =>
            //         _openEmailVerification(context, u.email ?? ''),
            //   ),
            //   const _Divider(),

            //   _EditableField(
            //     label: 'رقم الهاتف المحمول',
            //     value: u.phone ?? '',
            //     fieldKey: 'phone',
            //     keyboardType: TextInputType.phone,
            //     inputFormatters: [
            //       FilteringTextInputFormatter.digitsOnly,
            //       LengthLimitingTextInputFormatter(11),
            //     ],
            //     isEditing: _editingField == 'phone',
            //     isVerified: u.phoneVerified ?? false,
            //     showVerifyButton: !(u.phoneVerified ?? false),
            //     controller: _controllerFor('phone', u.phone ?? ''),
            //     onEditTap: () => _startEditing('phone'),
            //     onSave: () => _saveField(context, 'phone'),
            //     onCancel: _cancelEditing,
            //     onVerifyTap: () =>
            //         _openPhoneVerification(context, u.phone ?? ''),
            //   ),
            //   const _Divider(),
            // ] else ...[
            //   _ReadOnlyField(label: 'البريد الإلكتروني', value: u.email ?? ''),
            //   const _Divider(),
            //   _ReadOnlyField(label: 'رقم الهاتف المحمول', value: u.phone ?? ''),
            //   const _Divider(),
            // ],
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

            _EditableField(
              label: 'رقم الهاتف المحمول',
              value: u.phone ?? '',
              fieldKey: 'phone',
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
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

            // NID / Passport
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

            _AttachmentField(
              label: 'مرفق الرقم القومي/جواز السفر',
              isEgyptian: u.isEgyptian,
              profileId: int.tryParse(u.id ?? ''),
            ),
            const _Divider(),

            _ReadOnlyField(label: 'تاريخ الميلاد', value: u.dateOfBirth ?? ''),
            const _Divider(),
            _ReadOnlyField(label: 'محل الميلاد', value: u.placeOfBirth ?? ''),
            const _Divider(),
            _ReadOnlyField(label: 'النوع', value: u.gender ?? ''),
            const _Divider(),

            const _PasswordField(),
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
                    SnackBar(
                      content: const Text(
                        'كلمة المرور الجديدة غير متطابقة',
                        textDirection: TextDirection.rtl,
                      ),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'حسناً',
                        textColor: Colors.white,
                        onPressed: () =>
                            ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                      ),
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
  final List<TextInputFormatter>? inputFormatters;

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
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    isEditing
                        ? _EditLink(
                            label: 'يلغي',
                            onTap: onCancel,
                            color: AppColors.highlightDarkest,
                          )
                        : _EditLink(onTap: onEditTap),
                ],
              ),
            ],
          ),

          if (value.isNotEmpty && !isEditing) ...[
            SizedBox(height: 6.h),
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
          ],

          if (!isEditing && showVerifyButton && onVerifyTap != null) ...[
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 57.w,
                height: 40.h,
                child: OutlinedButton(
                  onPressed: onVerifyTap,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.errorDark,
                    side: BorderSide(color: AppColors.errorDark, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    minimumSize: Size(57.w, 40.h),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'تأكيد',
                    style: AppTextStyles.actionM.copyWith(
                      color: AppColors.errorDark,
                    ),
                  ),
                ),
              ),
            ),
          ],

          // ── Accordion ──────────────────────
          AnimatedSize(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: ClipRect(
              child: !isEditing
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6.h),

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

                        SizedBox(height: 10.h),

                        // ── Text field ────────────────────────────────
                        TextField(
                          controller: controller,
                          keyboardType: keyboardType,
                          inputFormatters: inputFormatters,
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

                        SizedBox(height: 12.h),

                        // ── Save + Verify buttons row ─────────────────
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            SizedBox(
                              width: 57.w,
                              height: 40.h,
                              child: ElevatedButton(
                                onPressed: onSave,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.mainBlueIndigoDye,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  side: BorderSide(
                                    color: AppColors.mainBlueIndigoDye,
                                    width: 1.5,
                                  ),
                                  minimumSize: Size(57.w, 40.h),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'حفظ',
                                  style: AppTextStyles.actionM.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                            if (showVerifyButton && onVerifyTap != null) ...[
                              SizedBox(width: 8.w),
                              SizedBox(
                                width: 57.w,
                                height: 40.h,
                                child: OutlinedButton(
                                  onPressed: onVerifyTap,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.errorDark,
                                    side: BorderSide(
                                      color: AppColors.errorDark,
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 12.h,
                                    ),
                                    minimumSize: Size(57.w, 40.h),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'تأكيد',
                                    style: AppTextStyles.actionM.copyWith(
                                      color: AppColors.errorDark,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 4.h),
                      ],
                    ),
            ),
          ),
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

class _EditLink extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;
  final Color? color;

  const _EditLink({this.onTap, this.label = 'تعديل', this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        textDirection: TextDirection.rtl,
        style: AppTextStyles.bodyM.copyWith(
          color: color ?? AppColors.highlightDarkest,
        ),
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
  final int? profileId;

  const _AttachmentField({
    required this.label,
    required this.isEgyptian,
    this.profileId,
  });

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

    final sizeInMB = await file.length() / (1024 * 1024);
    if (sizeInMB > 5) {
      if (mounted) _showError('حجم الملف يجب أن يكون أقل من 5 ميجابايت');
      return;
    }

    final extension = file.path.split('.').last.toLowerCase();
    if (extension == 'pdf') {
      final bytes = await file.readAsBytes();
      final threat = PdfSecurityScanner.scan(bytes);
      if (threat != null) {
        if (mounted) _showError('تم رفض الملف: $threat');
        return;
      }
    }

    setState(() => _uploading = true);
    try {
      if (!mounted) return;
      await context.read<UserProfileCubit>().uploadAttachment(
        file: file,
        isEgyptian: widget.isEgyptian,
      );
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textDirection: TextDirection.rtl),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
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

                // final fileId = file['id'] as int?;

                return _AttachmentRow(
                  key: ValueKey(widget.profileId ?? index),
                  fileId: widget.profileId,
                  isEgyptian: widget.isEgyptian,
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
  final int? fileId;
  final bool isEgyptian;
  final String fileName;

  const _AttachmentRow({
    super.key,
    required this.fileId,
    required this.isEgyptian,
    required this.fileName,
  });

  @override
  State<_AttachmentRow> createState() => _AttachmentRowState();
}

class _AttachmentRowState extends State<_AttachmentRow> {
  Uint8List? _bytes;
  bool _loading = false;

  String get _previewUrl {
    final id = widget.fileId;
    if (id == null) return '';
    return widget.isEgyptian
        ? ApiConstants.showUserNationalIdFile(id)
        : ApiConstants.showUserPassportFile(id);
  }

  Future<void> _fetchAndOpen(BuildContext context) async {
    if (_bytes != null) {
      _openSafe(context, _bytes!);
      return;
    }

    if (_previewUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تعذر تحديد رابط الملف',
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final dio = DioClient.instance.dio;
      final response = await dio.get<List<int>>(
        _previewUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      if (mounted) {
        _bytes = Uint8List.fromList(response.data!);
        setState(() => _loading = false);
        _openSafe(context, _bytes!);
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

  void _openSafe(BuildContext context, Uint8List bytes) {
    if (_isPdf(bytes)) {
      _openPdfSafely(context, bytes);
    } else {
      _openImageFullScreen(context, bytes);
    }
  }

  bool _isPdf(Uint8List bytes) {
    if (bytes.length < 4) return false;
    return bytes[0] == 0x25 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x44 &&
        bytes[3] == 0x46;
  }

  void _openPdfSafely(BuildContext context, Uint8List bytes) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SafePdfViewer(bytes: bytes, fileName: widget.fileName),
      ),
    );
  }

  void _openImageFullScreen(BuildContext context, Uint8List bytes) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black),
          body: Center(
            child: InteractiveViewer(
              child: Image.memory(bytes, fit: BoxFit.contain),
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

// ─── Password Field ─────────────────────────────
class _PasswordField extends StatefulWidget {
  const _PasswordField({super.key});

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _isEditing = false;

  final _currentPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  @override
  void dispose() {
    _currentPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _savePassword() {
    final current = _currentPassCtrl.text.trim();
    final newPass = _newPassCtrl.text.trim();
    final confirm = _confirmPassCtrl.text.trim();

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى ملء جميع الحقول',
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: Colors.red,
        ),
      );
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

    context.read<UserProfileCubit>().editPassword(
      currentPassword: current,
      newPassword: newPass,
      confirmPassword: confirm,
    );

    _currentPassCtrl.clear();
    _newPassCtrl.clear();
    _confirmPassCtrl.clear();
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'كلمة المرور',
                style: AppTextStyles.h6.copyWith(
                  color: AppColors.neutralDarkDarkest,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _isEditing = !_isEditing),
                child: Text(
                  _isEditing ? 'إلغاء' : 'تعديل',
                  style: AppTextStyles.bodyM.copyWith(
                    color: AppColors.highlightDarkest,
                  ),
                ),
              ),
            ],
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: ClipRect(
              child: !_isEditing
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),

                        Text(
                          'أدخل كلمة المرور الحالية',
                          style: AppTextStyles.h5.copyWith(
                            color: AppColors.neutralDarkLightest,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _PasswordTextField(
                          controller: _currentPassCtrl,
                          hintText: 'كلمة المرور الحالية',
                        ),

                        const SizedBox(height: 20),

                        Text(
                          'كلمة المرور الجديدة',
                          style: AppTextStyles.h5.copyWith(
                            color: AppColors.neutralDarkLightest,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _PasswordTextField(
                          controller: _newPassCtrl,
                          hintText: 'كلمة المرور الجديدة',
                        ),

                        const SizedBox(height: 20),

                        Text(
                          'تأكيد كلمة المرور الجديدة',
                          style: AppTextStyles.h5.copyWith(
                            color: AppColors.neutralDarkLightest,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _PasswordTextField(
                          controller: _confirmPassCtrl,
                          hintText: 'تأكيد كلمة المرور الجديدة',
                        ),

                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 100.w,
                            height: 48.h,
                            child: ElevatedButton(
                              onPressed: _savePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.mainBlueIndigoDye,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'حفظ',
                                style: AppTextStyles.actionM.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _newPassCtrl,
                          builder: (context, value, child) {
                            return PasswordRequirements(password: value.text);
                          },
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordRequirements extends StatelessWidget {
  final String password;

  const PasswordRequirements({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final rules = [
      _PasswordRule(
        label: 'يجب أن تحتوي على حرف كبير (A-Z).',
        met: password.contains(RegExp(r'[A-Z]')),
      ),
      _PasswordRule(
        label: 'يجب أن تحتوي على حرف صغير (a-z).',
        met: password.contains(RegExp(r'[a-z]')),
      ),
      _PasswordRule(
        label: 'يجب أن تحتوي على رقم واحد على الأقل.',
        met: password.contains(RegExp(r'[0-9]')),
      ),
      _PasswordRule(
        label: r'يمكن إضافة رموز خاصة مثل (! @ # $ % ( )) وهي اختيارية.',
        met: password.contains(RegExp(r'[!@#\$%^&*()\[\]{}|\<>,.?/~`\-_=+]')),
        optional: true,
      ),
      _PasswordRule(
        label: 'الحد الأدنى 8 أحرف والحد الأقصى 10 أحرف.',
        met: password.length >= 8 && password.length <= 10,
      ),
      _PasswordRule(
        label: 'لا يُسمح باستخدام المسافات.',
        met: password.isNotEmpty && !password.contains(' '),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'متطلبات كلمة المرور:',
          textDirection: TextDirection.rtl,
          style: AppTextStyles.bodyM.copyWith(
            color: AppColors.neutralDarkLightest,
          ),
        ),
        const SizedBox(height: 10),
        ...rules.map((r) => _buildRequirementRow(r)),
      ],
    );
  }

  Widget _buildRequirementRow(_PasswordRule rule) {
    final Color textColor = rule.met
        ? AppColors.successDark
        : rule.optional
        ? const Color(0xFF9AA5B4)
        : AppColors.neutralDarkLightest;

    final Color bulletColor = rule.met
        ? AppColors.successDark
        : rule.optional
        ? const Color(0xFF9AA5B4)
        : AppColors.neutralDarkLightest;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•', style: TextStyle(color: bulletColor, height: 1.4)),
          Expanded(
            child: Text(
              rule.label,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyM.copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordRule {
  final String label;
  final bool met;
  final bool optional;
  const _PasswordRule({
    required this.label,
    required this.met,
    this.optional = false,
  });
}

class _PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const _PasswordTextField({
    required this.controller,
    required this.hintText,
    super.key,
  });

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      textDirection: TextDirection.rtl,
      keyboardType: TextInputType.visiblePassword,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'[\u0600-\u06FF]')),
      ],

      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        hintText: widget.hintText,
        hintStyle: AppTextStyles.bodyM.copyWith(
          color: AppColors.neutralDarkLight.withOpacity(0.6),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.highlightDarkest, width: 1.5),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.neutralDarkLight,
          ),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
      ),
    );
  }
}

class _NameField extends StatefulWidget {
  final String firstName;
  final String restOfName;
  final bool isVerified;
  final void Function(String firstName, String restOfName)? onSave;

  const _NameField({
    super.key,
    required this.firstName,
    required this.restOfName,
    required this.isVerified,
    this.onSave,
  });

  @override
  State<_NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<_NameField> {
  bool _isEditing = false;

  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _restOfNameCtrl;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: widget.firstName);
    _restOfNameCtrl = TextEditingController(text: widget.restOfName);
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _restOfNameCtrl.dispose();
    super.dispose();
  }

  String get _fullName => [
    widget.firstName,
    widget.restOfName,
  ].where((p) => p.trim().isNotEmpty).join(' ');

  void _openEdit() {
    _firstNameCtrl.text = widget.firstName;
    _restOfNameCtrl.text = widget.restOfName;
    setState(() => _isEditing = true);
  }

  void _cancelEdit() => setState(() => _isEditing = false);

  void _save() {
    final first = _firstNameCtrl.text.trim();
    final rest = _restOfNameCtrl.text.trim();

    if (first.isEmpty) {
      FocusScope.of(context).requestFocus(FocusNode());
      return;
    }

    setState(() => _isEditing = false);
    widget.onSave?.call(first, rest);
  }

  @override
  void didUpdateWidget(_NameField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVerified && _isEditing) {
      setState(() => _isEditing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الاسم الكامل',
                textDirection: TextDirection.rtl,
                style: AppTextStyles.h6.copyWith(
                  color: AppColors.neutralDarkDarkest,
                ),
              ),
              if (!widget.isVerified)
                GestureDetector(
                  onTap: _isEditing ? _cancelEdit : _openEdit,
                  child: Text(
                    _isEditing ? 'يلغي' : 'تعديل',
                    style: AppTextStyles.bodyM.copyWith(
                      color: AppColors.highlightDarkest,
                    ),
                  ),
                ),
            ],
          ),
          if (_fullName.isNotEmpty && !_isEditing) ...[
            SizedBox(height: 6.h),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _fullName,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: AppTextStyles.bodyXL.copyWith(
                  color: AppColors.neutralDarkLight,
                ),
              ),
            ),
          ],

          AnimatedSize(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: ClipRect(
              child: !_isEditing
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6.h),

                        if (_fullName.isNotEmpty)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _fullName,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: AppTextStyles.bodyXL.copyWith(
                                color: AppColors.neutralDarkLight,
                              ),
                            ),
                          ),

                        SizedBox(height: 10.h),

                        _FieldLabel(text: 'الاسم الأول', required: true),
                        SizedBox(height: 6.h),
                        _NameTextField(
                          controller: _firstNameCtrl,
                          hintText: 'أحمد',
                          autofocus: true,
                        ),

                        SizedBox(height: 16.h),

                        _FieldLabel(required: true, text: 'باقي الاسم'),
                        SizedBox(height: 6.h),
                        _NameTextField(
                          controller: _restOfNameCtrl,
                          hintText: 'احمد محمد علي',
                        ),

                        SizedBox(height: 20.h),

                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 80.w,
                            height: 44.h,
                            child: ElevatedButton(
                              onPressed: _save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.mainBlueIndigoDye,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 10.h,
                                ),
                                minimumSize: Size(80.w, 44.h),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'حفظ',
                                style: AppTextStyles.actionM.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 4.h),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  final bool required;

  const _FieldLabel({required this.text, this.required = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.ltr,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (required) ...[
          Text(
            ' *',
            style: AppTextStyles.bodyM.copyWith(color: AppColors.errorDark),
          ),
        ],
        Text(
          text,
          textDirection: TextDirection.rtl,
          style: AppTextStyles.bodyM.copyWith(
            color: AppColors.neutralDarkDarkest,
          ),
        ),
      ],
    );
  }
}

class _NameTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool autofocus;

  const _NameTextField({
    required this.controller,
    required this.hintText,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      textDirection: TextDirection.rtl,
      keyboardType: TextInputType.name,
      style: AppTextStyles.bodyXL.copyWith(color: AppColors.neutralDarkDarkest),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: AppTextStyles.bodyXL.copyWith(
          color: AppColors.neutralDarkLight.withOpacity(0.5),
        ),
        hintTextDirection: TextDirection.rtl,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.neutralLightDarkest),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.neutralLightDarkest),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.highlightDarkest, width: 1.5),
        ),
      ),
    );
  }
}
