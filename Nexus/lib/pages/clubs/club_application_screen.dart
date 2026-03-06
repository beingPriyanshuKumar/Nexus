import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../styles/app_theme.dart';
import '../../../../utils/models/club_model.dart';
import '../../components/ui/glass_card.dart';

class ClubApplicationScreen extends StatefulWidget {
  final ClubModel club;
  const ClubApplicationScreen({super.key, required this.club});

  @override
  State<ClubApplicationScreen> createState() => _ClubApplicationScreenState();
}

class _ClubApplicationScreenState extends State<ClubApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Form fields matching web's ApplicationForm.jsx
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _regNumberController = TextEditingController();
  final _phoneController = TextEditingController();
  final _motivationController = TextEditingController();
  final _projectLinkController = TextEditingController();

  String _branch = '';
  String _division = '';
  String _positionYear = '';
  String _domain = '';
  double _priority = 1;

  static const _branches = [
    'Computer Engineering',
    'Information Technology',
    'Electronics and Telecommunication',
    'Mechanical Engineering',
    'Automotive and Robotics Engineering',
  ];

  static const _divisions = ['A', 'B'];
  static const _years = ['FE', 'SE'];
  static const _domains = [
    'Frontend Development',
    'Backend Development',
    'Full Stack Development',
    'App Dev',
    'AI/ML',
    'Cloud / DevOps',
    'UI/UX Design',
    'Blockchain',
    'Flutter',
    'Outreach',
  ];

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    // Simulate submission
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Application submitted for ${widget.club.name}! 🎉'),
        backgroundColor: Colors.greenAccent[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _regNumberController.dispose();
    _phoneController.dispose();
    _motivationController.dispose();
    _projectLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.backgroundDark, AppTheme.backgroundLightGradient],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Apply to ${widget.club.name}',
                              style: Theme.of(context).textTheme.titleLarge),
                          Text('Fill your data',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GlassCard(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Full Name
                              _buildTextField(
                                controller: _fullNameController,
                                label: 'Full Name *',
                                hint: 'Enter your full name',
                                icon: Icons.person_outline,
                                validator: (v) => (v?.isEmpty ?? true) ? 'Required' : null,
                              ),
                              const SizedBox(height: 16),

                              // Email
                              _buildTextField(
                                controller: _emailController,
                                label: 'College Email *',
                                hint: 'Enter your college email',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) => (v?.isEmpty ?? true) ? 'Required' : null,
                              ),
                              const SizedBox(height: 16),

                              // Branch & Division
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildDropdown(
                                      label: 'Branch *',
                                      value: _branch.isEmpty ? null : _branch,
                                      items: _branches,
                                      onChanged: (v) => setState(() => _branch = v ?? ''),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  SizedBox(
                                    width: 100,
                                    child: _buildDropdown(
                                      label: 'Division *',
                                      value: _division.isEmpty ? null : _division,
                                      items: _divisions,
                                      onChanged: (v) => setState(() => _division = v ?? ''),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Position/Year & Reg Number
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: _buildDropdown(
                                      label: 'Year *',
                                      value: _positionYear.isEmpty ? null : _positionYear,
                                      items: _years,
                                      onChanged: (v) => setState(() => _positionYear = v ?? ''),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildTextField(
                                      controller: _regNumberController,
                                      label: 'Registration No. *',
                                      hint: 'Enter reg number',
                                      icon: Icons.badge_outlined,
                                      validator: (v) => (v?.isEmpty ?? true) ? 'Required' : null,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Phone & Priority
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      controller: _phoneController,
                                      label: 'Phone *',
                                      hint: '10-digit number',
                                      icon: Icons.phone_outlined,
                                      keyboardType: TextInputType.phone,
                                      validator: (v) {
                                        if (v?.isEmpty ?? true) return 'Required';
                                        if (v!.length != 10) return '10 digits';
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  SizedBox(
                                    width: 120,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Priority: ${_priority.round()}',
                                            style: TextStyle(
                                                color: AppTheme.textSecondary,
                                                fontSize: 12)),
                                        Slider(
                                          value: _priority,
                                          min: 1,
                                          max: 15,
                                          divisions: 14,
                                          activeColor: AppTheme.primaryAccent,
                                          onChanged: (v) => setState(() => _priority = v),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Motivation
                              TextFormField(
                                controller: _motivationController,
                                maxLines: 4,
                                maxLength: 500,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Why do you want to join ${widget.club.abbr}? *',
                                  hintText: 'Tell us your motivation...',
                                  alignLabelWithHint: true,
                                  counterStyle: TextStyle(color: AppTheme.textSecondary),
                                ),
                                validator: (v) => (v?.isEmpty ?? true) ? 'Required' : null,
                              ),
                              const SizedBox(height: 16),

                              // Domain
                              _buildDropdown(
                                label: 'Your Domain *',
                                value: _domain.isEmpty ? null : _domain,
                                items: _domains,
                                onChanged: (v) => setState(() => _domain = v ?? ''),
                              ),
                              const SizedBox(height: 16),

                              // Project Link
                              _buildTextField(
                                controller: _projectLinkController,
                                label: 'Best Project (GitHub Link)',
                                hint: 'https://github.com/...',
                                icon: Icons.link_rounded,
                                keyboardType: TextInputType.url,
                              ),
                              const SizedBox(height: 28),

                              // Submit
                              ElevatedButton(
                                onPressed: _isLoading ? null : _handleSubmit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryAccent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  disabledBackgroundColor:
                                      AppTheme.primaryAccent.withOpacity(0.5),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ))
                                    : const Text('Submit Application',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                              ),

                              const SizedBox(height: 12),
                              Text(
                                'By submitting this form, you agree to join our amazing community!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
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
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null
            ? Icon(icon, color: AppTheme.textSecondary, size: 20)
            : null,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label),
      dropdownColor: const Color(0xFF1E293B),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      hint: Text('Select', style: TextStyle(color: AppTheme.textSecondary)),
      isExpanded: true,
      items: items
          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
