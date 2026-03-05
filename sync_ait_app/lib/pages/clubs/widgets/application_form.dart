import 'package:flutter/material.dart';
import '../../../../components/ui/app_text_field.dart';
import '../../../../components/ui/animated_primary_button.dart';
import '../../../../components/ui/glass_card.dart';

class ApplicationForm extends StatefulWidget {
  final String clubId;
  const ApplicationForm({super.key, required this.clubId});

  @override
  State<ApplicationForm> createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Application Form',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _reasonController,
              labelText: 'Why do you want to join?',
              hintText: 'Explain your motivation...',
              prefixIcon: Icons.edit,
            ),
            const SizedBox(height: 24),
            AnimatedPrimaryButton(
              text: 'Submit Application',
              onPressed: () {
                // Submit logic
              },
            ),
          ],
        ),
      ),
    );
  }
}
