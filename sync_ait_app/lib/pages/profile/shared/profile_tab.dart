import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/profile/profile_provider.dart';
import '../../../utils/models/profile_model.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  bool _isEditing = false;
  late TextEditingController _nameCtrl;
  late TextEditingController _bioCtrl;
  late TextEditingController _roleCtrl;
  late TextEditingController _bannerCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _bioCtrl = TextEditingController();
    _roleCtrl = TextEditingController();
    _bannerCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    _roleCtrl.dispose();
    _bannerCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _startEditing(ProfileData profile) {
    _nameCtrl.text = profile.name;
    _bioCtrl.text = profile.bio;
    _roleCtrl.text = profile.role;
    _bannerCtrl.text = profile.bannerText;
    _emailCtrl.text = profile.email;
    _phoneCtrl.text = profile.phone;
    setState(() => _isEditing = true);
  }

  void _handleSave() {
    final notifier = ref.read(profileProvider.notifier);
    final profile = ref.read(profileProvider).profile;
    notifier.updateProfile(profile.copyWith(
      name: _nameCtrl.text,
      bio: _bioCtrl.text,
      role: _roleCtrl.text,
      bannerText: _bannerCtrl.text,
      email: _emailCtrl.text,
      phone: _phoneCtrl.text,
    ));
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context, ) {
    final state = ref.watch(profileProvider);
    final profile = state.profile;

    if (_isEditing) return _buildEditMode(profile);
    return _buildViewMode(profile);
  }

  Widget _buildEditMode(ProfileData profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Edit Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
              Row(
                children: [
                  TextButton(
                    onPressed: () => setState(() => _isEditing = false),
                    child: const Text('Cancel', style: TextStyle(color: Color(0xFF6B7280))),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _handleSave,
                    icon: const Icon(Icons.save, size: 16),
                    label: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF3F4F6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: const Color(0xFFEFF6FF),
                        child: Text(
                          profile.name.isNotEmpty ? profile.name[0] : '?',
                          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(color: Color(0xFFF3F4F6)),
                const SizedBox(height: 16),

                // General info
                const Text('General Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF111827))),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _editField(_nameCtrl, 'Full Name')),
                    const SizedBox(width: 12),
                    Expanded(child: _editField(_roleCtrl, 'Role')),
                  ],
                ),
                const SizedBox(height: 12),
                _editField(_bannerCtrl, 'Banner Text'),
                const SizedBox(height: 4),
                const Text('This text appears large at the top of your profile.', style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
                const SizedBox(height: 12),
                TextField(
                  controller: _bioCtrl,
                  maxLines: 4,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF111827)),
                  decoration: _inputDec('Bio'),
                ),

                const SizedBox(height: 24),
                const Divider(color: Color(0xFFF3F4F6)),
                const SizedBox(height: 16),

                // Contact
                const Text('Contact Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF111827))),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _editField(_emailCtrl, 'Email Address', icon: Icons.email_outlined)),
                    const SizedBox(width: 12),
                    Expanded(child: _editField(_phoneCtrl, 'Phone Number', icon: Icons.phone_outlined)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildViewMode(ProfileData profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Edit button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => _startEditing(profile),
              icon: const Icon(Icons.edit, size: 14),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEFF6FF),
                foregroundColor: const Color(0xFF2563EB),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Profile card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF3F4F6)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                // Banner
                Container(
                  width: double.infinity,
                  height: 100,
                  color: const Color(0xFF111827),
                  child: Center(
                    child: Text(
                      profile.bannerText,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ),

                // Avatar + info
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Transform.translate(
                        offset: const Offset(0, -40),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 36,
                                backgroundColor: const Color(0xFFEFF6FF),
                                child: Text(profile.name.isNotEmpty ? profile.name[0] : '?',
                                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(profile.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                                Text(profile.role, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Contact + Bio
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('CONTACT INFO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF111827), letterSpacing: 1)),
                                const SizedBox(height: 12),
                                _contactRow(Icons.email_outlined, profile.email),
                                const SizedBox(height: 8),
                                _contactRow(Icons.phone_outlined, profile.phone),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('BIO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF111827), letterSpacing: 1)),
                                const SizedBox(height: 8),
                                Text(profile.bio, style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563), height: 1.5)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Clubs section
          Row(
            children: [
              const Icon(Icons.emoji_events, size: 20, color: Color(0xFF111827)),
              const SizedBox(width: 8),
              const Text('Club Memberships & Communities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
            ],
          ),
          const SizedBox(height: 16),

          ...profile.clubs.map((club) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF3F4F6)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFFF3F4F6),
                      child: Text(club.name.split(' ').last[0], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF374151))),
                    ),
                    const SizedBox(height: 12),
                    Text(club.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                    const SizedBox(height: 4),
                    Text(club.role, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF2563EB))),
                    const SizedBox(height: 8),
                    Text(club.description, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), height: 1.4)),
                    const SizedBox(height: 14),
                    const Divider(color: Color(0xFFF3F4F6)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.message, size: 14, color: Color(0xFF15803D)),
                            label: const Text('WhatsApp', style: TextStyle(fontSize: 11, color: Color(0xFF15803D))),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFBBF7D0)),
                              backgroundColor: const Color(0xFFF0FDF4),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.send, size: 14, color: Color(0xFF0369A1)),
                            label: const Text('Telegram', style: TextStyle(fontSize: 11, color: Color(0xFF0369A1))),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFBAE6FD)),
                              backgroundColor: const Color(0xFFF0F9FF),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _contactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 8),
        Flexible(child: Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563)))),
      ],
    );
  }

  Widget _editField(TextEditingController ctrl, String label, {IconData? icon}) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(fontSize: 13, color: Color(0xFF111827)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        prefixIcon: icon != null ? Icon(icon, size: 18, color: const Color(0xFF9CA3AF)) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFD1D5DB))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFD1D5DB))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2563EB))),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
      ),
    );
  }

  InputDecoration _inputDec(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFD1D5DB))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFD1D5DB))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2563EB))),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
    );
  }
}
