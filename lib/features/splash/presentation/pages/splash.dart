import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  late AnimationController _gradientController;
  late Animation<double> _gradientAnim;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.78, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoController.forward();

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);

    _gradientAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _gradientController,
        curve: Curves.easeInOutCubic,
      ),
    );

    Future.delayed(const Duration(seconds: 4), _navigate);
  }

  void _navigate() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/guest');
  }

  @override
  void dispose() {
    _logoController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _gradientAnim,
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // ── Base color ──────────────────────────
              Container(color: const Color(0xFF1A7AB8)),

              // ── Top-to-bottom gradient overlay ──────
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x820472C4), // #0472C4 at 51% opacity
                      Color(0xFF1D2832), // mainDarkBlue fully opaque
                    ],
                  ),
                ),
              ),

              // ── Teal tint overlay ───────────────────
              Container(color: const Color.fromARGB(133, 30, 99, 120)),

              // ── Deep blue tint overlay ──────────────
              Container(color: const Color.fromARGB(133, 27, 75, 130)),

              // ── Bottom-right triangle accent ────────
              Positioned(
                bottom: 0,
                right: 0,
                child: CustomPaint(
                  size: const Size(310, 400),
                  painter: _TriangleCornerPainter(),
                ),
              ),

              // ── Centered logo + text ─────────────────
              SafeArea(
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ── Logo with glow ──
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.white.withOpacity(0.55),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                ),
                                BoxShadow(
                                  color: AppColors.white.withOpacity(0.28),
                                  blurRadius: 20,
                                  spreadRadius: 8,
                                ),
                                BoxShadow(
                                  color: AppColors.white.withOpacity(0.12),
                                  blurRadius: 40,
                                  spreadRadius: 14,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // ── App name ──
                          Text(
                            'مصلحة الضرائب العقارية',
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                              height: 1.15,
                              letterSpacing: 0.3,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // ── Subtitle ──
                          Text(
                            'مرحبا بك في خدمات مصلحة الضرائب العقارية',
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: AppTextStyles.bodyM.copyWith(
                              // ✅ fixed
                              color: AppColors.white.withOpacity(0.82),
                              fontSize: 17,
                              height: 1.3,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────
// Triangle Corner Painter
// ─────────────────────────────────────────
class _TriangleCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF060E18).withOpacity(0.0),
          const Color(0xFF060E18).withOpacity(0.10),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
