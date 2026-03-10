import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:reta/features/auth/data/models/user_models.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'declaration_guide_page.dart';

class GuestDeclarationsPage extends StatefulWidget {
  final UserModel? user;

  const GuestDeclarationsPage({super.key, this.user});

  @override
  State<GuestDeclarationsPage> createState() => _GuestDeclarationsPageState();
}

class _GuestDeclarationsPageState extends State<GuestDeclarationsPage> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => _DeclarationsHome(
            onNavigateToGuide: () {
              _navigatorKey.currentState?.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => DeclarationGuidePage(user: widget.user),
                ),
                (route) => false,
              );
            },
          ),
        );
      },
    );
  }
}

class _DeclarationsHome extends StatelessWidget {
  final VoidCallback onNavigateToGuide;

  const _DeclarationsHome({required this.onNavigateToGuide});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutralLightMedium,
        appBar: AppBar(
          backgroundColor: AppColors.mainBlueIndigoDye,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.neutralLightLightest,
              size: 18,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'إقراراتي',
            style: AppTextStyles.actionXL.copyWith(
              color: AppColors.neutralLightLightest,
            ),
          ),
        ),
        body: Column(
          children: [
            _buildDeclarationBanner(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  'إدارة الإقرارات المضافة إلى حسابي',
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.mainBlueIndigoDye,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    color: AppColors.neutralDarkLightest,
                    dashPattern: const [6, 4],
                    radius: Radius.circular(12),
                    strokeWidth: 1.5,
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.9,
                    alignment: Alignment.center,
                    child: Text(
                      'لم يتم إضافة أي إقرار بعد',
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.neutralDarkLightest,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeclarationBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.warningDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onNavigateToGuide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تقديم الإقرار الضريبي',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: AppTextStyles.h3.copyWith(
                color: AppColors.neutralLightLightest,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'قدّم إقرارك الضريبي بسهولة من خلال إضافة وحداتك العقارية، ومراجعة بياناتها، ثم إصدار طلبات السداد المرتبطة بها، مع إمكانية المتابعة والدفع لاحقًا من حسابك.',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyM.copyWith(
                color: AppColors.neutralLightLightest,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: onNavigateToGuide,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  textDirection: TextDirection.ltr,
                  children: [
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.neutralDarkDark,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'ابدأ الآن',
                      style: AppTextStyles.actionM.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.neutralDarkDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
