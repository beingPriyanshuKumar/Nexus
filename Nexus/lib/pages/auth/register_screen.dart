import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../components/ui/glass_card.dart';
import '../../components/ui/animated_primary_button.dart';
import '../../styles/app_theme.dart';
import '../../providers/auth/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedYear = '';
  bool _obscurePassword = true;

  static const List<String> _years = ['FE', 'SE', 'TE', 'BE'];

  void _handleSignUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill all fields', isError: true);
      return;
    }
    if (_selectedYear.isEmpty) {
      _showSnackBar('Please select your year', isError: true);
      return;
    }

    final result = await ref
        .read(authProvider.notifier)
        .signUp(name, email, password, _selectedYear);
    if (!mounted) return;

    if (result.success) {
      _showSnackBar(result.message);
      context.go('/verify-account');
    } else {
      _showSnackBar(result.message, isError: true);
    }
  }

  void _handleGoogleSignUp() async {
    _showSnackBar('Google Sign-Up coming soon!');
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.greenAccent[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.backgroundDark,
                  AppTheme.backgroundLightGradient,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),

          // Bokeh orbs
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.loginSecondaryAccent.withOpacity(0.15),
                    AppTheme.loginSecondaryAccent.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(begin: 0.9, end: 1.1, duration: 4000.ms),

          Positioned(
            bottom: -40,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.loginPrimaryAccent.withOpacity(0.12),
                    AppTheme.loginPrimaryAccent.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(begin: 1.0, end: 0.85, duration: 3500.ms),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.loginTertiaryAccent.withOpacity(0.15),
                    AppTheme.loginTertiaryAccent.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: AnimationLimiter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 600),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: -50.0,
                      child: FadeInAnimation(child: widget),
                    ),
                    children: [
                      const SizedBox(height: 40),

                      // Back button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.glassSurface,
                            border: Border.all(color: AppTheme.glassBorder),
                          ),
                          child: IconButton(
                            onPressed: () => context.pop(),
                            icon: const Icon(Icons.arrow_back_rounded,
                                color: AppTheme.textSecondary),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Header
                      Hero(
                        tag: 'auth_logo',
                        child: ShaderMask(
                          shaderCallback: (bounds) =>
                              LinearGradient(colors: [AppTheme.loginPrimaryAccent, AppTheme.loginSecondaryAccent], begin: Alignment.topLeft, end: Alignment.bottomRight).createShader(bounds),
                          child: const Icon(
                            Icons.sync_rounded,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      ShaderMask(
                        shaderCallback: (bounds) =>
                            LinearGradient(colors: [AppTheme.loginPrimaryAccent, AppTheme.loginSecondaryAccent], begin: Alignment.topLeft, end: Alignment.bottomRight).createShader(bounds),
                        child: Text(
                          'Create an account',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign up with your college credentials',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 36),

                      // Form Card
                      GlassCard(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Full Name
                            TextField(
                              controller: _nameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'John Doe',
                                labelText: 'Full Name',
                                prefixIcon: Icon(Icons.person_outline,
                                    color: AppTheme.textSecondary),
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Email
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'you@college.com',
                                labelText: 'Email address',
                                prefixIcon: Icon(Icons.email_outlined,
                                    color: AppTheme.textSecondary),
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Password
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                labelText: 'Password',
                                prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                    color: AppTheme.textSecondary),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppTheme.textSecondary,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() =>
                                        _obscurePassword = !_obscurePassword);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Year Dropdown with glow
                            DropdownButtonFormField<String>(
                              value: _selectedYear.isEmpty
                                  ? null
                                  : _selectedYear,
                              decoration: const InputDecoration(
                                labelText: 'Year',
                                prefixIcon: Icon(Icons.school_outlined,
                                    color: AppTheme.textSecondary),
                              ),
                              dropdownColor: const Color(0xFF0F172A),
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
                              hint: Text('Select year',
                                  style: TextStyle(
                                      color: AppTheme.textSecondary)),
                              items: _years
                                  .map((y) => DropdownMenuItem(
                                      value: y, child: Text(y)))
                                  .toList(),
                              onChanged: (val) {
                                setState(() => _selectedYear = val ?? '');
                              },
                              selectedItemBuilder: (context) {
                                return _years.map((y) {
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      y,
                                      style: const TextStyle(
                                        color: AppTheme.loginSecondaryAccent,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                            const SizedBox(height: 28),

                            // Sign Up button
                              AnimatedPrimaryButton(
                                text: 'Create Account',
                                isLoading: authState.isLoading,
                                onPressed: _handleSignUp,
                                isLogin: true,
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Divider
                      Row(
                        children: [
                          Expanded(
                              child: Divider(
                                  color: AppTheme.glassBorder, thickness: 1)),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: Text('or',
                                style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 13)),
                          ),
                          Expanded(
                              child: Divider(
                                  color: AppTheme.glassBorder, thickness: 1)),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Google Auth with gradient border
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.glassBorder,
                              AppTheme.primaryAccent.withOpacity(0.3),
                              AppTheme.glassBorder,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundDark,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: OutlinedButton.icon(
                            onPressed: _handleGoogleSignUp,
                            icon: const Text('G',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            label: const Text('Sign up with Google'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide.none,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account? ',
                              style: Theme.of(context).textTheme.bodyMedium),
                          GestureDetector(
                            onTap: () => context.go('/login'),
                            child: ShaderMask(
                              shaderCallback: (bounds) =>
                                  AppTheme.accentGradient
                                      .createShader(bounds),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Terms
                      Text(
                        'By continuing, you agree to our Terms & Privacy Policy.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
