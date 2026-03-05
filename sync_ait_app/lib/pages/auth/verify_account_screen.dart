import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../styles/app_theme.dart';
import '../../components/ui/glass_card.dart';
import '../../components/ui/animated_primary_button.dart';
import '../../providers/auth/auth_provider.dart';

class VerifyAccountScreen extends ConsumerStatefulWidget {
  const VerifyAccountScreen({super.key});

  @override
  ConsumerState<VerifyAccountScreen> createState() =>
      _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends ConsumerState<VerifyAccountScreen> {
  String _otp = '';
  bool _isLoading = false;
  bool _otpSent = false;
  String? _message;

  Future<void> _sendOtp() async {
    final user = ref.read(authProvider).user;
    if (user == null) return;

    setState(() => _isLoading = true);
    final result =
        await ref.read(authProvider.notifier).sendVerifyOtp(user.email);
    setState(() {
      _isLoading = false;
      _otpSent = result.success;
      _message = result.message;
    });
  }

  Future<void> _verify() async {
    if (_otp.length != 6) return;

    setState(() => _isLoading = true);
    final result = await ref.read(authProvider.notifier).verifyAccount(_otp);
    setState(() {
      _isLoading = false;
      _message = result.message;
    });

    if (result.success && mounted) {
      final user = ref.read(authProvider).user;
      if (user?.year != null) {
        context.go('/profile/${user!.year}');
      } else {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.backgroundDark,
                  AppTheme.backgroundLightGradient
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Decorative orb
          Positioned(
            top: -80,
            left: -40,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.secondaryAccent.withOpacity(0.12),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  // Icon
                  Icon(
                    Icons.verified_user_rounded,
                    size: 80,
                    color: AppTheme.secondaryAccent,
                  ).animate().fadeIn(duration: 500.ms).scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1.0, 1.0),
                        curve: Curves.easeOutBack,
                      ),

                  const SizedBox(height: 24),

                  Text(
                    'Verify Your Account',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium,
                  ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

                  const SizedBox(height: 8),

                  Text(
                    'Enter the 6-digit OTP sent to your email',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

                  const SizedBox(height: 48),

                  GlassCard(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        // Send OTP button
                        if (!_otpSent) ...[
                          AnimatedPrimaryButton(
                            text: 'Send OTP',
                            isLoading: _isLoading,
                            onPressed: _sendOtp,
                          ),
                        ] else ...[
                          // OTP Input
                          PinCodeTextField(
                            appContext: context,
                            length: 6,
                            onChanged: (value) {
                              setState(() => _otp = value);
                            },
                            onCompleted: (value) {
                              setState(() => _otp = value);
                            },
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(12),
                              fieldHeight: 56,
                              fieldWidth: 44,
                              activeFillColor:
                                  AppTheme.glassSurface,
                              inactiveFillColor:
                                  AppTheme.glassSurface,
                              selectedFillColor:
                                  AppTheme.primaryAccent.withOpacity(0.1),
                              activeColor: AppTheme.primaryAccent,
                              inactiveColor: AppTheme.glassBorder,
                              selectedColor: AppTheme.primaryAccent,
                            ),
                            enableActiveFill: true,
                            keyboardType: TextInputType.number,
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 24),

                          AnimatedPrimaryButton(
                            text: 'Verify Account',
                            isLoading: _isLoading,
                            onPressed: _verify,
                          ),

                          const SizedBox(height: 16),

                          TextButton(
                            onPressed: _isLoading ? null : _sendOtp,
                            child: Text(
                              'Resend OTP',
                              style: TextStyle(
                                color: AppTheme.primaryAccent.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ],

                        // Status message
                        if (_message != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            _message!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _message!.contains('success') ||
                                      _message!.contains('sent')
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 500.ms).slideY(
                        begin: 0.2,
                        end: 0,
                      ),

                  const SizedBox(height: 24),

                  TextButton.icon(
                    onPressed: () => context.go('/login'),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Back to Login'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
