import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:reta/core/theme/app_colors.dart';
import 'package:reta/features/components/app_text.dart';
import 'package:reta/features/components/circular_progress_indicator_platform_widget.dart';
import 'package:reta/features/payment/presentations/cubit/payment_electronic/payment_electronic_cubit.dart';
import 'package:reta/features/payment/presentations/pages/payment_request_page.dart';
import 'package:reta/features/payment/presentations/pages/payment_result_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/helpers/app_enum.dart';
import '../../../../core/helpers/extensions/dimensions.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../components/app_bar.dart';
import '../../data/models/payment_electronic_data.dart';

class ElectronicPaymentPage extends StatelessWidget {
  final int claimId;
  final String? declarationId;
  final ClaimsSource source;
  final bool fromDebts;

  const ElectronicPaymentPage({
    super.key,
    required this.claimId,
    this.declarationId,
    required this.source,
    required this.fromDebts,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentElectronicCubit()..initiatePayment(claimId),
      child: _ElectronicPaymentView(
        claimId: claimId,
        declarationId: declarationId,
        source: source,
        fromDebts: fromDebts,
      ),
    );
  }
}

class _ElectronicPaymentView extends StatelessWidget {
  final String? declarationId;
  final ClaimsSource source;
  final int claimId;
  final bool fromDebts;

  const _ElectronicPaymentView({
    this.declarationId,
    required this.source,
    required this.claimId,
    required this.fromDebts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightMedium,
      appBar: MainAppBar(
        title: 'الدفع الإلكتروني',
        backButtonAction: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: PaymentRequestsPage(
              declarationId: declarationId ?? '',
              claimsSource: source,
              fromDebts: fromDebts,
            ),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
          );
        },
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: AppText(
                  text: state.message,
                  alignment: Alignment.center,
                  color: AppColors.white,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PaymentElectronicLoading) {
            return const CircularProgressIndicatorPlatformWidget();
          }
          if (state is PaymentElectronicError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      text: state.message,
                      fontSize: 14.sp,
                      color: AppColors.neutralDarkMedium,
                      alignment: AlignmentDirectional.center,
                    ),
                    16.hs,
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const AppText(
                        text: 'رجوع',
                        alignment: AlignmentDirectional.center,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is PaymentElectronicSuccess) {
            return _PaymentWebView(
              paymentData: state.data,
              claimId: claimId,
              declarationId: declarationId ?? '',
              source: source,
              onPaymentSuccess: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentResultPage(
                      isSuccess: true,
                      claimId: claimId,
                      declarationId: declarationId,
                      source: source,
                      fromDebts: fromDebts,
                    ),
                  ),
                );
              },
              onPaymentFail: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentResultPage(
                      isSuccess: false,
                      declarationId: declarationId,
                      source: source,
                      claimId: claimId,
                      fromDebts: fromDebts,
                    ),
                  ),
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
  final PaymentElectronicData paymentData;
  final int claimId;
  final String declarationId;
  final ClaimsSource source;
  final VoidCallback onPaymentSuccess;
  final VoidCallback onPaymentFail;

  const _PaymentWebView({
    required this.paymentData,
    required this.claimId,
    required this.declarationId,
    required this.source,
    required this.onPaymentSuccess,
    required this.onPaymentFail,
  });

  @override
  State<_PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<_PaymentWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasNavigated = false;

  Future<void> _checkPaymentStatus(String claimId) async {
    if (mounted) setState(() => _isLoading = true);

    try {
      final response = await DioClient.instance.dio.get(
        '/declaration-system/declarations/user/claims/$claimId',
      );

      final isPaid = response.data['data']['paid'] == true;

      if (!mounted) return;

      if (isPaid) {
        widget.onPaymentSuccess();
      } else {
        widget.onPaymentFail();
      }
    } catch (e) {
      if (!mounted) return;
      widget.onPaymentFail();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onNavigationRequest: (request) {
            final url = request.url;

            if (_hasNavigated) return NavigationDecision.prevent;

            if (url.contains(
              '${ApiConstants.baseEnvUrl.replaceAll("https://", "").replaceAll("http://", "")}/tax-declaration/payment/',
            )) {
              _hasNavigated = true;
              final uri = Uri.parse(url);
              final claimId = uri.pathSegments.last;
              _checkPaymentStatus(claimId);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.paymentData.paymentUrl),
        method: LoadRequestMethod.post,
        body: Uint8List.fromList(
          'SenderID=${Uri.encodeComponent(widget.paymentData.senderID)}'
                  '&RandomSecret=${Uri.encodeComponent(widget.paymentData.randomSecret)}'
                  '&RequestObject=${Uri.encodeComponent(widget.paymentData.requestObject)}'
                  '&HashedRequestObject=${Uri.encodeComponent(widget.paymentData.hashedRequestObject)}'
              .codeUnits,
        ),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );
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
