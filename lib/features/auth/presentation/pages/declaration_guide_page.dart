import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reta/features/auth/data/models/user_models.dart';
import 'package:reta/features/components/app_bar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../declarations/presentations/pages/select_applicant_type_page.dart';
import 'auth_gate_dialog.dart';

class DeclarationGuidePage extends StatefulWidget {
  final UserModel? user;

  const DeclarationGuidePage({super.key, this.user});

  @override
  State<DeclarationGuidePage> createState() => _DeclarationGuidePageState();
}

class _DeclarationGuidePageState extends State<DeclarationGuidePage> {
  bool _hasReadInstructions = false;

  void _onContinue() {
    if (widget.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SelectApplicantTypePage(declarationId: -1),
        ),
      );
    } else {
      showAuthGateDialog(
        context,
        title: 'يتطلب تسجيل الدخول',
        message:
            'يرجى تسجيل الدخول أو إنشاء حساب جديد لتتمكن من تقديم الإقرار الضريبي والاستفادة من خدمات مصلحة الضرائب العقارية.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutralLightMedium,
        appBar: MainAppBar(
          title: 'طلب إقرار ضريبي جديد',
          backgroundColor: AppColors.mainBlueIndigoDye,
          titleTextStyle: AppTextStyles.actionXL.copyWith(
            color: AppColors.neutralLightLightest,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.neutralLightLightest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.neutralLightLightest),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الدليل الإرشادي لتقديم الإقرار الضريبي',
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.mainBlueIndigoDye,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'يرجى قراءة التعليمات التالية بعناية قبل البدء في تقديم الإقرار الضريبي، لضمان إدخال البيانات بشكل صحيح واستكمال الإقرار بنجاح.',
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.mainBlueSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('1. نطاق الإقرار'),
                          _buildBullet(
                            'يتيح لك هذا الإقرار تقديم إقرار موحد شامل لجميع ممتلكاتك العقارية.',
                          ),
                          _buildBullet(
                            'يمكن إضافة أكثر من عقار ضمن نفس الإقرار، مهما اختلف نوعه أو استخدامه.',
                          ),
                          const SizedBox(height: 16),
                          _buildSectionTitle('2. أنواع العقارات المشمولة'),
                          Text(
                            'يشمل الإقرار جميع أنواع العقارات مثل:',
                            textDirection: TextDirection.rtl,
                            style: AppTextStyles.bodyL.copyWith(
                              color: AppColors.neutralDarkDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildBullet('الوحدات السكنية'),
                          _buildBullet('الوحدات التجارية'),
                          _buildBullet('الوحدات الإدارية'),
                          _buildBullet('الوحدات الخدمية'),
                          _buildBullet('المنشآت بمختلف أنواعها'),
                          _buildBullet(
                            'الحالات الخاصة مثل التركيبات الثابتة أو الأراضي المستغلة',
                          ),
                          const SizedBox(height: 16),
                          _buildSectionTitle('3. إضافة أكثر من عقار'),
                          _buildBullet(
                            'يمكنك إضافة عقار واحد أو أكثر داخل نفس الإقرار.',
                          ),
                          _buildBullet(
                            'يمكنك مراجعة العقارات المضافة، تعديل بياناتها، أو حذف أي عقار قبل إرسال الإقرار النهائي.',
                          ),
                          const SizedBox(height: 16),
                          _buildSectionTitle('4. دقة البيانات'),
                          _buildBullet(
                            'يرجى التأكد من صحة ودقة جميع البيانات المدخلة لكل عقار.',
                          ),
                          _buildBullet(
                            'تقديم بيانات غير دقيقة قد يؤدي إلى تأخير فحص الإقرار أو طلب استكمال بيانات.',
                          ),
                          const SizedBox(height: 16),
                          _buildSectionTitle('5. مراجعة الإقرار قبل الإرسال'),
                          _buildBullet(
                            'بعد الانتهاء من إدخال جميع العقارات، سيتم عرض ملخص كامل للإقرار.',
                          ),
                          _buildBullet(
                            'يرجى مراجعة البيانات بعناية قبل الإرسال النهائي.',
                          ),
                          const SizedBox(height: 16),
                          _buildSectionTitle('6. الإقرار والمسؤولية'),
                          _buildBullet(
                            'بإرسال الإقرار، يقر الممول بصحة البيانات المدخلة ومسؤوليته عنها وفقًا للقانون.',
                          ),
                          _buildBullet(
                            'يخضع الإقرار للفحص والمراجعة من قبل مصلحة الضرائب العقارية.',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _hasReadInstructions = !_hasReadInstructions;
                          });
                        },
                        child: Row(
                          textDirection: TextDirection.rtl,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _hasReadInstructions
                                      ? AppColors.highlightDarkest
                                      : AppColors.neutralLightDarkest,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                                color: _hasReadInstructions
                                    ? AppColors.highlightDarkest
                                    : Colors.transparent,
                              ),
                              child: _hasReadInstructions
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 14,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'أقر بأنني قرأت وفهمت التعليمات الواردة في الدليل الإرشادي، وأوافق على الالتزام بها عند تقديم الإقرار الضريبي.',
                                textDirection: TextDirection.rtl,
                                style: AppTextStyles.bodyM.copyWith(
                                  color: AppColors.neutralDarkLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _hasReadInstructions ? _onContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.highlightDarkest,
                    disabledBackgroundColor: AppColors.neutralLightDark,
                    foregroundColor: AppColors.neutralLightLightest,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'المتابعة إلى نموذج الإقرار',
                    style: AppTextStyles.actionM.copyWith(
                      color: _hasReadInstructions
                          ? AppColors.neutralLightLightest
                          : AppColors.neutralDarkLight,
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
}

Widget _buildSectionTitle(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      style: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkDark),
    ),
  );
}

Widget _buildBullet(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(Icons.circle, size: 6, color: AppColors.neutralDarkDark),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.right,
            style: AppTextStyles.bodyM.copyWith(
              color: AppColors.neutralDarkDark,
            ),
          ),
        ),
      ],
    ),
  );
}
