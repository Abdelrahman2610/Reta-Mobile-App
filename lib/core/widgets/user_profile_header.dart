import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                      '${widget.user.firstname ?? ''} ${widget.user.lastname ?? ''}'
                          .trim(),
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
            ],
          ),
        );
      },
    );
  }
}
