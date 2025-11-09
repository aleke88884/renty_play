import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:renty_play/features/feature_home/ui/home_page.dart';

void main() {
  runApp(const RentTechApp());
}

class RentTechApp extends StatelessWidget {
  const RentTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RentTech Auth',
      home: AuthPage(),
    );
  }
}

// Custom Colors
const Color primaryBlue = Color(0xFF667EEA);
const Color primaryPurple = Color(0xFF764BA2);
const Color textGray = Color(0xFF6B7280);
const Color inputBorder = Color(0xFFE5E7EB);
const Color inputBackground = Color(0xFFF9FAFB);

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  static const String routeName = '/auth';

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  int _currentTabIndex = 0;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: primaryBlue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      // Use SingleChildScrollView to prevent overflow when keyboard appears
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Adjust the height to ensure it fills the screen dynamically
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // 1. Header Section with Gradient
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(30, 60, 30, 80),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryBlue, primaryPurple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Back Button
                            const GradientBackButton(),
                            const SizedBox(height: 30),
                            Text(
                              _currentTabIndex == 0
                                  ? "Добро пожаловать!"
                                  : "Создайте аккаунт",
                              style: const TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _currentTabIndex == 0
                                  ? "Войдите, чтобы продолжить"
                                  : "Зарегистрируйтесь по номеру телефона",
                              style: const TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 2. Content Section (White Card) - FIX APPLIED HERE
                    Expanded(
                      child: Transform.translate(
                        // Use Transform.translate to visually shift the card up by 30 pixels,
                        // avoiding the negative margin assertion error.
                        offset: const Offset(0, -30),
                        child: Container(
                          width: double.infinity,
                          // Removed margin: const EdgeInsets.only(top: -30), which caused the error.
                          // Increase top padding by 30 (70 total) to compensate for the visual shift
                          // and keep the content visually aligned under the header text.
                          padding: const EdgeInsets.fromLTRB(30, 70, 30, 40),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.05),
                                offset: Offset(0, -10),
                                blurRadius: 30,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Tabs
                              _buildTabs(),
                              const SizedBox(height: 30),

                              // Form Fields
                              _buildPhoneInput(),
                              const SizedBox(height: 20),
                              _buildPasswordInput(),

                              if (_currentTabIndex == 0) ...[
                                const SizedBox(height: 10),
                                // Forgot Password link for Login tab
                                const Align(
                                  alignment: Alignment.centerRight,
                                  child: ForgotPasswordLink(),
                                ),
                              ],
                              const SizedBox(height: 30),

                              // Primary Button
                              PrimaryAuthButton(
                                text: _currentTabIndex == 0
                                    ? "Войти"
                                    : "Зарегистрироваться",
                                onPressed: () => context.go(HomePage.routeName),
                              ),

                              // Divider and Social Buttons
                              const DividerWithText(text: "или войти через"),

                              // Updated Social Buttons (Phone/SMS and Google)
                              SocialButtons(
                                onPressed: (provider) {
                                  _showSnackbar("Войти через $provider...");
                                },
                              ),

                              // Footer Text
                              const Spacer(),
                              const FooterText(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: TabButton(
              text: "Вход",
              isActive: _currentTabIndex == 0,
              onTap: () => setState(() => _currentTabIndex = 0),
            ),
          ),
          Expanded(
            child: TabButton(
              text: "Регистрация",
              isActive: _currentTabIndex == 1,
              onTap: () => setState(() => _currentTabIndex = 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneInput() {
    return InputGroup(
      label: "Номер телефона",
      icon: Icons.phone_android_rounded,
      placeholder: "+7 (999) 999-99-99",
      controller: _phoneController,
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildPasswordInput() {
    return InputGroup(
      label: "Пароль",
      icon: Icons.lock_rounded,
      placeholder: "••••••••",
      controller: _passwordController,
      isPassword: true,
    );
  }
}

// MARK: - Custom Widgets

/// Custom back button matching the header style
class GradientBackButton extends StatelessWidget {
  const GradientBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.go(HomePage.routeName);
          },
          borderRadius: BorderRadius.circular(20),
          child: const Center(
            child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}

/// Custom tab button for switching between Login and Registration
class TabButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const TabButton({
    super.key,
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'SF Pro Display',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isActive ? primaryBlue : textGray,
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom input group with label, icon, and text field
class InputGroup extends StatelessWidget {
  final String label;
  final IconData icon;
  final String placeholder;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;

  const InputGroup({
    super.key,
    required this.label,
    required this.icon,
    required this.placeholder,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          style: const TextStyle(fontFamily: 'SF Pro Display', fontSize: 16),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: textGray.withOpacity(0.6)),
            filled: true,
            fillColor: inputBackground,
            prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: inputBorder, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: inputBorder, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: primaryBlue, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

/// The main primary button with the gradient fill
class PrimaryAuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryAuthButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [primaryBlue, primaryPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.3),
            offset: const Offset(0, 10),
            blurRadius: 25,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Crucial for gradient to show
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Divider with centered text
class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        children: [
          const Expanded(child: Divider(color: inputBorder, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 14,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ),
          const Expanded(child: Divider(color: inputBorder, thickness: 1)),
        ],
      ),
    );
  }
}

/// Forgot Password link
class ForgotPasswordLink extends StatelessWidget {
  const ForgotPasswordLink({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Placeholder for navigation to password reset
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Переход к сбросу пароля...")),
        );
      },
      child: const Text(
        "Забыли пароль?",
        style: TextStyle(
          fontFamily: 'SF Pro Display',
          color: primaryBlue,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Social login buttons (Phone/SMS and Google)
class SocialButtons extends StatelessWidget {
  final void Function(String provider) onPressed;

  const SocialButtons({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // SMS/Phone Button (replacing Apple)
        Expanded(
          child: SocialButton(
            icon: Icons.sms_outlined,
            provider: "SMS",
            onPressed: onPressed,
          ),
        ),
        const SizedBox(width: 12),
        // Google Button
        Expanded(
          child: SocialButton(
            // Using a generic Google icon, or could use an image asset
            icon: Icons.flutter_dash, // Placeholder for Google icon
            provider: "Google",
            onPressed: onPressed,
            // Customizing the appearance for Google to match the "🔵" from the mockup
            customIconColor: const Color(0xFF4285F4),
          ),
        ),
      ],
    );
  }
}

/// Individual social button component
class SocialButton extends StatelessWidget {
  final IconData icon;
  final String provider;
  final Color? customIconColor;
  final void Function(String provider) onPressed;

  const SocialButton({
    super.key,
    required this.icon,
    required this.provider,
    required this.onPressed,
    this.customIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: inputBorder, width: 2),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onPressed(provider),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Center(
              child: Icon(
                icon,
                size: 24,
                color: customIconColor ?? Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Footer text with registration link
class FooterText extends StatelessWidget {
  const FooterText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Нет аккаунта? ',
          style: const TextStyle(
            fontFamily: 'SF Pro Display',
            color: textGray,
            fontSize: 14,
          ),
          children: [
            TextSpan(
              text: 'Зарегистрироваться',
              style: const TextStyle(
                fontFamily: 'SF Pro Display',
                color: primaryBlue,
                fontWeight: FontWeight.w600,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Placeholder for navigation to registration
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Переход к регистрации...")),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}
