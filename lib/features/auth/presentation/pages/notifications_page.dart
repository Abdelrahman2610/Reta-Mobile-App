import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/auth/data/models/notification_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/notifications_cubit.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.neutralLightLight,
            appBar: _buildAppBar(context),
            body: _buildBody(context, state),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, NotificationsState state) {
    switch (state.status) {
      case NotificationsStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case NotificationsStatus.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48.sp,
                color: AppColors.errorDark,
              ),
              SizedBox(height: 16.h),
              Text(
                state.errorMessage ?? 'حدث خطأ ما',
                textDirection: TextDirection.rtl,
                style: AppTextStyles.bodyM.copyWith(
                  color: AppColors.neutralDarkLight,
                ),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () =>
                    context.read<NotificationsCubit>().fetchNotifications(),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        );

      case NotificationsStatus.initial:
      case NotificationsStatus.loaded:
        if (state.notifications.isEmpty) return _buildEmpty();
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemCount: state.notifications.length,
          separatorBuilder: (_, __) => SizedBox(height: 8.h),
          itemBuilder: (context, index) {
            final item = state.notifications[index];
            return _NotificationCard(
              item: item,
              onTap: () =>
                  context.read<NotificationsCubit>().markAsRead(item.id),
            );
          },
        );
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.neutralLightDarkest,
      elevation: 0,
      surfaceTintColor: AppColors.neutralLightLight,
      automaticallyImplyLeading: false,
      title: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              'الإشعارات',
              style: AppTextStyles.actionXL.copyWith(
                color: AppColors.mainBlueSecondary,
              ),
            ),
          ),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.h),
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.mainBlueSecondary,
                  size: 20.sp,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => context.read<NotificationsCubit>().markAllAsRead(),
                child: Text(
                  'تحديد كمقروء',
                  style: AppTextStyles.bodyM.copyWith(
                    color: AppColors.mainBlueSecondary,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 64.sp,
            color: AppColors.neutralLightDark,
          ),
          SizedBox(height: 16.h),
          Text(
            'لا توجد إشعارات',
            style: AppTextStyles.bodyM.copyWith(
              color: AppColors.neutralDarkLightest,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel item;
  final VoidCallback onTap;

  const _NotificationCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.neutralLightLightest,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        child: Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.titleAr,
                    textDirection: TextDirection.rtl,
                    style: item.isRead
                        ? AppTextStyles.actionL.copyWith(
                            color: AppColors.neutralDarkDarkest,
                          )
                        : AppTextStyles.actionXL.copyWith(
                            color: AppColors.mainBlueIndigoDye,
                          ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    item.messageAr,
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.bodyM.copyWith(
                      color: AppColors.neutralDarkLight,
                    ),
                  ),
                  if (item.readAt != null) ...[
                    SizedBox(height: 8.h),
                    Text(
                      item.readAt!,
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.bodyXS.copyWith(
                        color: AppColors.neutralDarkLight,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 8.w),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.sp,
                color: AppColors.neutralDarkLightest,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
