import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/auth/presentation/cubit/user_profile_cubit.dart';
import 'package:reta/features/auth/presentation/cubit/user_profile_state.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/user_models.dart';

class UserProfilePage extends StatelessWidget {
  final UserModel user;

  const UserProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileCubit()..loadFromUser(user),
      child: const _UserProfileView(),
    );
  }
}

class _UserProfileView extends StatelessWidget {
  const _UserProfileView();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutralLightLight,
        appBar: _ProfileAppBar(),
        body: BlocConsumer<UserProfileCubit, UserProfileState>(
          listenWhen: (previous, current) =>
              previous is UserProfileLoaded && current is UserProfileError,
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
          },
          buildWhen: (previous, current) => current is! UserProfileError,
          builder: (context, state) {
            if (state is UserProfileLoaded) {
              return _ProfileBody(state: state);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

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

class _ProfileBody extends StatelessWidget {
  final UserProfileLoaded state;

  const _ProfileBody({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            _ProfileField(
              label: 'الاسم الكامل',
              value: '${state.userModel.firstname} ${state.userModel.lastname}',
            ),
            _Divider(),
            _ProfileField(
              label: 'البريد الإلكتروني',
              value: state.userModel.email ?? '',
              showEdit: true,
              showVerifyButton: !(state.userModel.emailVerified ?? false),
              onEditTap: () => _onEditTapped(context, 'البريد الإلكتروني'),
              onVerifyTap: () => _onVerifyTapped(context, 'البريد الإلكتروني'),
            ),
            _Divider(),
            _ProfileField(
              label: 'رقم الهاتف المحمول',
              value: state.userModel.phone ?? '',
              showEdit: true,
              isVerified: state.userModel.phoneVerified ?? false,
              showVerifyButton: !(state.userModel.phoneVerified ?? false),
              onEditTap: () => _onEditTapped(context, 'رقم الهاتف المحمول'),
              onVerifyTap: () => _onVerifyTapped(context, 'رقم الهاتف المحمول'),
            ),
            _Divider(),
            _ProfileField(
              label: 'الجنسية',
              value: state.userModel.nationality ?? '',
            ),
            _Divider(),
            _ProfileField(
              label: 'الرقم القومي/جواز السفر',
              value: state.userModel.nationalId ?? '',
              showEdit: true,
              showVerifyButton: !(state.userModel.nationalIdVerified ?? false),
              onEditTap: () =>
                  _onEditTapped(context, 'الرقم القومي/جواز السفر'),
              onVerifyTap: () =>
                  _onVerifyTapped(context, 'الرقم القومي/جواز السفر'),
            ),
            _Divider(),
            _ProfileField(
              label: 'مرفق الرقم القومي/جواز السفر',
              value: '',
              showEdit: true,
              onEditTap: () =>
                  _onEditTapped(context, 'مرفق الرقم القومي/جواز السفر'),
            ),
            _Divider(),
            _ProfileField(
              label: 'تاريخ الميلاد',
              value: state.userModel.dateOfBirth ?? '',
            ),
            _Divider(),
            _ProfileField(
              label: 'محل الميلاد',
              value: state.userModel.placeOfBirth ?? '',
            ),
            _Divider(),
            _ProfileField(label: 'النوع', value: state.userModel.gender ?? ''),
            _Divider(),
            _ProfileField(
              label: 'كلمة المرور',
              value: '••••••••',
              showEdit: true,
              onEditTap: () => _onEditTapped(context, 'كلمة المرور'),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  void _onEditTapped(BuildContext context, String fieldLabel) {}
  void _onVerifyTapped(BuildContext context, String fieldLabel) {}
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final bool showEdit;
  final bool isVerified;
  final bool showVerifyButton;
  final VoidCallback? onEditTap;
  final VoidCallback? onVerifyTap;

  const _ProfileField({
    required this.label,
    required this.value,
    this.showEdit = false,
    this.isVerified = false,
    this.showVerifyButton = false,
    this.onEditTap,
    this.onVerifyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                textDirection: TextDirection.rtl,
                style: AppTextStyles.h6.copyWith(
                  color: AppColors.neutralDarkDarkest,
                ),
              ),
              if (isVerified)
                _VerifiedBadge()
              else if (showEdit)
                _EditLink(onTap: onEditTap)
              else
                const SizedBox.shrink(),
            ],
          ),

          SizedBox(height: 6.h),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (value.isNotEmpty)
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

              if (showVerifyButton && onVerifyTap != null) ...[
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _VerifyButton(onTap: onVerifyTap!),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

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

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Text(
      'تم التحقق',
      textDirection: TextDirection.rtl,
      style: AppTextStyles.actionM.copyWith(color: AppColors.successMedium),
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
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

class _ErrorBody extends StatelessWidget {
  final String message;

  const _ErrorBody({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: AppColors.errorDark),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: AppTextStyles.bodyM.copyWith(
                color: AppColors.neutralDarkLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
