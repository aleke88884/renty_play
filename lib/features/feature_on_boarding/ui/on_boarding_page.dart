import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:renty_play/features/feature_auth/ui/auth_page.dart';
import 'package:renty_play/features/feature_registration/ui/registration_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  static const String routeName = '/onboarding';

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  // This value will control the active dot indicator
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Removed the outer fixed-size Container (width: 375, height: 812)
    // and its fixed styling to allow the widget to take the full screen.
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Outer screen background
      body: Center(
        child: Container(
          // 2. The inner container now fills the available space
          // and has the desired gradient/styling.
          // Removed fixed width/height for responsiveness.
          decoration: BoxDecoration(
            color: Colors.white, // Base color (mostly covered by gradient)
            borderRadius: BorderRadius.circular(
              0,
            ), // No rounded corners for full screen
            // The box shadow is removed here as it doesn't make sense
            // for a full-screen widget.
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Gradient background
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              // Subtle pattern overlay
              Opacity(
                opacity: 0.1,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(-0.6, -0.4),
                      colors: [Colors.white24, Colors.transparent],
                      radius: 1.0,
                    ),
                  ),
                ),
              ),

              // Content
              SafeArea(
                child: Padding(
                  // Reduced padding slightly for smaller screens
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30, // Slightly reduced horizontal padding
                    vertical: 40, // Slightly reduced vertical padding
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),

                      // Floating logo
                      AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          final y = Tween(begin: 0.0, end: -15.0)
                              .animate(
                                CurvedAnimation(
                                  parent: _floatController,
                                  curve: Curves.easeInOut,
                                ),
                              )
                              .value;
                          return Transform.translate(
                            offset: Offset(0, y),
                            child: child,
                          );
                        },
                        child: Container(
                          // Use a fraction of screen width for more adaptive sizing
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.width * 0.35,
                          decoration: BoxDecoration(
                            // 3. Corrected Colors.white.withValues(alpha: .25)
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: [
                              BoxShadow(
                                // 4. Corrected Colors.black.withValues(alpha: 0.2)
                                color: Colors.black.withOpacity(0.2),
                                offset: const Offset(0, 20),
                                blurRadius: 40,
                              ),
                            ],
                            backgroundBlendMode: BlendMode.overlay,
                          ),
                          child: const Center(
                            child: Text("🎮", style: TextStyle(fontSize: 70)),
                          ),
                        ),
                      ),

                      const SizedBox(height: 50),

                      const Text(
                        "RentTech",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Арендуй технику, когда она тебе нужна — быстро и удобно",
                        textAlign: TextAlign.center,
                        // Ensure text is constrained by default horizontal padding
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 70),

                      // Buttons
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF667EEA),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                shadowColor: Colors.black.withOpacity(
                                  0.2,
                                ), // Corrected alpha
                                elevation: 8,
                              ),
                              onPressed: () {
                                context.go(AuthPage.routeName);
                              },
                              child: const Text(
                                "Войти",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Colors.white30,
                                  width: 2,
                                ),
                                backgroundColor: Colors.white.withOpacity(
                                  0.2,
                                ), // Corrected alpha
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () {
                                context.go(RegistrationPage.routeName);
                              },
                              child: const Text(
                                "Зарегистрироваться",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Dots indicator (Adaptive to screen width via spacing)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          final active = index == currentPage;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: active ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: active
                                  ? Colors.white
                                  : Colors.white.withOpacity(
                                      0.4,
                                    ), // Corrected alpha
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 40),

                      // Features (Adaptive to screen width via Row and spacing)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          _Feature(icon: "⚡", text: "Быстро"),
                          SizedBox(
                            width: 30,
                          ), // Fixed spacing is generally fine here
                          _Feature(icon: "🔒", text: "Безопасно"),
                          SizedBox(width: 30),
                          _Feature(icon: "💰", text: "Выгодно"),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  final String icon;
  final String text;

  const _Feature({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
