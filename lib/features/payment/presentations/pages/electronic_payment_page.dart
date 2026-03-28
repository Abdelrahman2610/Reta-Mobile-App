import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/features/components/app_text.dart';
import 'package:reta/features/components/circular_progress_indicator_platform_widget.dart';
import 'package:reta/features/payment/presentations/cubit/payment_electronic/payment_electronic_cubit.dart';
import 'package:reta/features/payment/presentations/pages/payment_result_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../components/app_bar.dart';
import '../pages/payment_request_page.dart';

class ElectronicPaymentPage extends StatelessWidget {
  final int claimId;
  final String? declarationId;
  final ClaimsSource source;

  const ElectronicPaymentPage({
    super.key,
    required this.claimId,
    this.declarationId,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentElectronicCubit()..initiatePayment(claimId),
      child: _ElectronicPaymentView(
        claimId: claimId,
        declarationId: declarationId,
        source: source,
      ),
    );
  }
}

class _ElectronicPaymentView extends StatelessWidget {
  final String? declarationId;
  final ClaimsSource source;
  final int claimId;

  const _ElectronicPaymentView({
    this.declarationId,
    required this.source,
    required this.claimId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightMedium,
      appBar: MainAppBar(
        title: 'الدفع الإلكتروني',
        backgroundColor: AppColors.mainBlueIndigoDye,
        backButtonIconColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: BlocConsumer<PaymentElectronicCubit, PaymentElectronicState>(
        listener: (context, state) {
          if (state is PaymentElectronicError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is PaymentElectronicLoading) {
            return const CircularProgressIndicatorPlatformWidget();
          }
          if (state is PaymentElectronicError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: 'حدث خطأ أثناء بدء عملية الدفع',
                    fontSize: 14.sp,
                    color: AppColors.neutralDarkMedium,
                  ),
                  16.hs,
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const AppText(text: 'رجوع'),
                  ),
                ],
              ),
            );
          }
          if (state is PaymentElectronicSuccess) {
            return _PaymentWebView(
              url: state.paymentUrl,
              claimId: claimId,
              declarationId: declarationId ?? '',
              source: source,
              onPaymentComplete: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: PaymentRequestsPage(
                    declarationId: declarationId ?? '',
                    claimsSource: source,
                  ),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.slideUp,
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _PaymentWebView extends StatefulWidget {
  final String url;
  final int claimId;
  final String declarationId; // ← أضف
  final ClaimsSource source; // ← أضف
  final VoidCallback onPaymentComplete;

  const _PaymentWebView({
    required this.url,
    required this.claimId,
    required this.declarationId,
    required this.source,
    required this.onPaymentComplete,
  });

  @override
  State<_PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<_PaymentWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (url) {
            setState(() => _isLoading = false);

            if (url.contains('/eKhales/Success') || url.contains('success')) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => PaymentResultPage(
                    isSuccess: true,
                    onBackToPaymentList: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: PaymentRequestsPage(
                          declarationId: widget.declarationId,
                          claimsSource: widget.source,
                        ),
                        withNavBar: true,
                        pageTransitionAnimation:
                            PageTransitionAnimation.slideUp,
                      );
                    },
                    onViewDeclarationDetails: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      // navigate to declaration details
                    },
                    onBackToDeclarations: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ),
              );
            } else if (url.contains('/eKhales/Fail') || url.contains('fail')) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => PaymentResultPage(
                    isSuccess: false,
                    onRetry: () {
                      Navigator.pop(context);
                      // إعادة المحاولة — ارجع للـ WebView بنفس الـ URL
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ElectronicPaymentPage(
                            claimId: widget.claimId,
                            declarationId: widget.declarationId,
                            source: widget.source,
                          ),
                        ),
                      );
                    },
                    onBackToPaymentList: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: PaymentRequestsPage(
                          declarationId: widget.declarationId,
                          claimsSource: widget.source,
                        ),
                        withNavBar: true,
                        pageTransitionAnimation:
                            PageTransitionAnimation.slideUp,
                      );
                    },
                  ),
                ),
              );
            }
          },
          onNavigationRequest: (request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading) const CircularProgressIndicatorPlatformWidget(),
      ],
    );
  }
}
