import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class TermsPrivacyPage extends StatelessWidget {
  const TermsPrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutralLightLight,
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGroupHeader(
                      'أولاً: الشروط والأحكام',
                      'الشروط والأحكام',
                    ),
                    SizedBox(height: 10.h),
                    _buildParagraph(
                      'يرجى قراءة الشروط والأحكام التالية بعناية قبل استخدام تطبيق خدمات الضرائب العقارية.',
                    ),
                    _buildParagraph(
                      'باستخدامك لهذا التطبيق، فإنك توافق على الالتزام بالشروط والأحكام الموضحة أدناه.',
                    ),
                    SizedBox(height: 10.h),
                    _buildSectionTitle('1. التعريف بالخدمة'),
                    SizedBox(height: 8.h),
                    _buildParagraph('يتيح التطبيق للمستخدمين:'),
                    _buildBullet('إنشاء حسابات شخصية.'),
                    _buildBullet('تقديم الإقرارات الضريبية.'),
                    _buildBullet('إصدار طلبات السداد.'),
                    _buildBullet('سداد المدفوعات إلكترونياً.'),
                    _buildBullet('متابعة الطلبات والمدفوعات.'),
                    _buildBullet('الاطلاع على بيانات حسابهم.'),
                    SizedBox(height: 10.h),
                    _buildSectionTitle('2. مسؤولية المستخدم'),
                    SizedBox(height: 8.h),
                    _buildParagraph('يلتزم المستخدم بما يلي:'),
                    _buildBullet(
                      'إدخال بيانات صحيحة ومحدثة عند التسجيل أو تقديم الإقرار.',
                    ),
                    _buildBullet('الحفاظ على سرية بيانات الدخول وكلمة المرور.'),
                    _buildBullet(
                      'عدم مشاركة بيانات الحساب مع أي طرف بأي طريقة أو شكل.',
                    ),
                    _buildBullet('استخدام التطبيق للأغراض المشروعة فقط.'),
                    _buildParagraph(
                      'ويقع على عاتق المستخدم مسؤولية أي نشاط يتم من خلال حسابه.',
                    ),
                    SizedBox(height: 10.h),
                    _buildSectionTitle('3. دقة البيانات'),
                    SizedBox(height: 8.h),
                    _buildParagraph(
                      'يتحمل المستخدم المسؤولية الكاملة عن صحة البيانات المدخلة في الإقرارات أو الطلبات.',
                    ),
                    _buildParagraph('وقد يترتب على إدخال بيانات غير صحيحة:'),
                    _buildBullet('رفض الطلب.'),
                    _buildBullet('تعليق الحساب مؤقتاً.'),
                    _buildBullet(
                      'اتخاذ إجراءات قانونية وفقاً للقوانين المنظمة.',
                    ),
                    SizedBox(height: 10.h),
                    _buildSectionTitle('4. الدفع والمعاملات'),
                    SizedBox(height: 8.h),
                    _buildBullet(
                      'يتم استخدام معاملات الدفع الإلكتروني من خلال بوابات دفع معتمدة.',
                    ),
                    _buildBullet(
                      'لا يتحمل التطبيق مسؤولية أي خسارة خارجة عن الإرادة الفنية أو البشرية.',
                    ),
                    _buildBullet(
                      'يعتبر إرسال الإيصال الإلكتروني مستنداً رسمياً لإثبات عملية الدفع.',
                    ),
                    SizedBox(height: 10.h),
                    _buildSectionTitle('5. تعليق أو إيقاف الحساب'),
                    SizedBox(height: 8.h),
                    _buildParagraph(
                      'يحوز الجهة المشغلة تعليق أو إيقاف الحساب في الحالات التالية:',
                    ),
                    _buildBullet('إساءة استخدام النظام.'),
                    _buildBullet('إدخال بيانات مضللة.'),
                    _buildBullet('مخالفة الشروط والأحكام.'),
                    SizedBox(height: 10.h),
                    _buildSectionTitle('6. التحديثات'),
                    SizedBox(height: 8.h),
                    _buildParagraph(
                      'تحتفظ الجهة المشغلة بحق تعديل هذه الشروط في أي وقت، ويتم نشر التحديثات داخل التطبيق.',
                    ),
                    _buildParagraph(
                      'وإعد استمرار استخدام التطبيق موافقة ضمنية على التعديلات.',
                    ),
                    SizedBox(height: 10.h),
                    _buildSectionTitle('7. القانون الواجب التطبيق'),
                    SizedBox(height: 8.h),
                    _buildParagraph(
                      'تخضع هذه الشروط للقوانين والأنظمة المنظمة للضرائب العقارية المعمول بها داخل جمهورية مصر العربية.',
                    ),
                    _buildParagraph(
                      'تُعد هذه الشروط خاضعة لسياسة خصوصية التطبيق ثانياً.',
                    ),
                    _buildGroupHeader('', 'سياسة الخصوصية'),
                    SizedBox(height: 8.h),
                    _buildParagraph(
                      'تحرص الجهة المشغلة على حماية خصوصية وبيانات المستخدمين.',
                    ),
                    SizedBox(height: 10.h),
                    _buildSectionTitle('1. البيانات التي يتم جمعها'),
                    SizedBox(height: 8.h),
                    _buildParagraph('قد نقوم بجمع البيانات التالية:'),
                    SizedBox(height: 8.h),
                    _buildBullet('الاسم والبيانات الشخصية.'),
                    _buildBullet('رقم الهاتف المحمول.'),
                    _buildBullet('البريد الإلكتروني.'),
                    _buildBullet('الرقم القومي أو رقم جواز السفر.'),
                    _buildBullet('بيانات العقارات والإقرارات.'),
                    _buildBullet('بيانات الدفع والمعاملات.'),
                    SizedBox(height: 10.h),
                    _buildSectionTitle('2. استخدام البيانات'),
                    SizedBox(height: 8.h),
                    _buildParagraph('يتم استخدام البيانات من أجل:'),
                    _buildBullet('إنشاء وإدارة الحساب.'),
                    _buildBullet('معالجة الإقرارات والطلبات.'),
                    _buildBullet('إرسال الإشعارات المتعلقة بالخدمة.'),
                    _buildBullet('تحسين جودة الخدمات المقدمة.'),
                    _buildBullet('الالتزام بالمتطلبات القانونية والتنظيمية.'),
                    SizedBox(height: 10.h),
                    _buildSectionTitle('3. حماية البيانات'),
                    SizedBox(height: 8.h),
                    _buildBullet('يتم تخزين البيانات في بيئة مؤمنة.'),
                    _buildBullet(
                      'يتم تطبيق بروتوكولات تقنية وتنظيمية لحماية البيانات من الوصول غير المصرح به.',
                    ),
                    _buildBullet(
                      'لا يتم الاحتفاظ بالبيانات لفترة أطول من اللازم وفق المتطلبات القانونية والتنظيمية.',
                    ),
                    SizedBox(height: 10.h),
                    _buildSectionTitle('4. مشاركة البيانات'),
                    SizedBox(height: 8.h),
                    _buildParagraph('قد يتم مشاركة البيانات مع:'),
                    _buildBullet('الجهات الحكومية المختصة.'),
                    _buildBullet('مزودي خدمات الدفع والمعاملات.'),
                    _buildBullet(
                      'مزودي خدمات الإرسال النصية أو البريد الإلكتروني.',
                    ),
                    _buildParagraph('وذلك فقط بهدف تقديم الخدمة فقط.'),
                    SizedBox(height: 10.h),
                    _buildSectionTitle('5. مدة الاحتفاظ بالبيانات'),
                    SizedBox(height: 8.h),
                    _buildParagraph(
                      'يتم الاحتفاظ بالبيانات للفترة اللازمة وفقاً للقوانين الرسمية المعمول بها.',
                    ),
                    SizedBox(height: 10.h),
                    _buildSectionTitle('6. حقوق المستخدم'),
                    SizedBox(height: 8.h),
                    _buildParagraph('يحق للمستخدم:'),
                    _buildBullet('الاطلاع على بياناته الشخصية.'),
                    _buildBullet('طلب تصحيح البيانات غير الصحيحة.'),
                    _buildBullet('تحديث بيانات الحساب من خلال التطبيق.'),
                    SizedBox(height: 10.h),
                    _buildSectionTitle('7. الاتصال بنا'),
                    SizedBox(height: 8.h),
                    _buildParagraph(
                      'في حال وجود أي استفسارات متعلقة بالخصوصية أو الشروط، يمكن التواصل من خلال القنوات الرسمية المتاحة داخل التطبيق.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupHeader(String title, String subtitle) {
    return Column(
      children: [
        Text(
          title,
          textDirection: TextDirection.rtl,
          style: AppTextStyles.h2.copyWith(color: AppColors.mainBlueIndigoDye),
        ),
        Text(
          subtitle,
          textDirection: TextDirection.rtl,
          style: AppTextStyles.h4.copyWith(color: AppColors.mainBlueSecondary),
        ),
      ],
    );
  }

  /// Numbered sub-section title INSIDE the white container
  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      textDirection: TextDirection.rtl,
      style: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkDark),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        text,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        style: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkDark),
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, right: 8.w),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 7.h, left: 8.w),
            child: Container(
              width: 5.w,
              height: 5.w,
              decoration: BoxDecoration(
                color: AppColors.mainBlueSecondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyM.copyWith(
                color: AppColors.neutralDarkDark,
                fontSize: 13.5.sp,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.neutralLightDarkest,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: AppColors.neutralLightLight,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: AppColors.mainBlueSecondary,
          size: 20.sp,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'الشروط والخصوصية',
        style: AppTextStyles.actionXL.copyWith(
          color: AppColors.mainBlueSecondary,
        ),
      ),
    );
  }
}
