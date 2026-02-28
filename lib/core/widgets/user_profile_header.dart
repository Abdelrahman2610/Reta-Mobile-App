import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/core/theme/app_text_styles.dart';
import 'package:reta/features/auth/data/models/user_models.dart';
import 'package:reta/features/auth/presentation/cubit/notifications_cubit.dart';
import 'package:reta/features/auth/presentation/pages/notifications_page.dart';

class UserProfileHeader extends StatefulWidget {
  final UserModel user;

  const UserProfileHeader({super.key, required this.user});

  @override
  State<UserProfileHeader> createState() => _UserProfileHeaderState();
}

class _UserProfileHeaderState extends State<UserProfileHeader> {
  File? _pickedImage;
  final _picker = ImagePicker();

  Future<void> _openNotifications() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<NotificationsCubit>(),
          child: const NotificationsPage(),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final source = await _showImageSourceSheet();
    if (source == null) return;

    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 512,
      maxHeight: 512,
    );

    if (picked != null) setState(() => _pickedImage = File(picked.path));
  }

  Future<ImageSource?> _showImageSourceSheet() async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutralLightDark,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'اختر صورة',
                style: AppTextStyles.h5.copyWith(
                  color: AppColors.neutralDarkDarkest,
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.mainBlueSecondary,
                ),
                title: Text(
                  'الكاميرا',
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.bodyM.copyWith(
                    color: AppColors.neutralDarkDarkest,
                  ),
                ),
                onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.mainBlueSecondary,
                ),
                title: Text(
                  'معرض الصور',
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.bodyM.copyWith(
                    color: AppColors.neutralDarkDarkest,
                  ),
                ),
                onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, notifState) {
        final unread = notifState.unreadCount;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            textDirection: TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Notification Bell ────────────────────────────────────
              GestureDetector(
                onTap: _openNotifications,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: AppColors.neutralLightMedium,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_none_outlined,
                        color: AppColors.highlightDarkest,
                        size: 26,
                      ),
                    ),
                    if (unread > 0)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            unread > 9 ? '9+' : '$unread',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // ── Name / Phone / Email ─────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.name ?? '',
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.neutralDarkDarkest,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (widget.user.phone != null)
                      Text(
                        widget.user.phone!,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.right,
                        style: AppTextStyles.bodyS.copyWith(
                          color: AppColors.neutralDarkLight,
                        ),
                      ),
                    if (widget.user.email != null)
                      Text(
                        widget.user.email!,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.right,
                        style: AppTextStyles.bodyS.copyWith(
                          color: AppColors.neutralDarkLight,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // ── Avatar with edit button ──────────────────────────────
              Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.highlightLightest,
                        shape: BoxShape.circle,
                        image: _pickedImage != null
                            ? DecorationImage(
                                image: FileImage(_pickedImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _pickedImage == null
                          ? const Icon(
                              Icons.person_rounded,
                              size: 40,
                              color: AppColors.highlightLight,
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.highlightDarkest,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
