import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../styles/app_theme.dart';
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
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    final profile = state.profile;

    if (_isEditing) return _buildEditMode(profile);
    return _buildViewMode(profile, state);
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
              Text('Edit Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
              Row(
                children: [
                  TextButton(
                    onPressed: () => setState(() => _isEditing = false),
                    child: Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.accentGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _handleSave,
                      icon: const Icon(Icons.save, size: 16),
                      label: const Text('Save'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
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
              color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Center(
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppTheme.accentGradient,
                        ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.backgroundDark : Colors.white,
                          child: Text(
                            profile.name.isNotEmpty ? profile.name[0] : '?',
                            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppTheme.primaryAccent),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            gradient: AppTheme.accentGradient,
                            shape: BoxShape.circle,
                            border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.backgroundDark : Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                Divider(color: AppTheme.glassBorder),
                const SizedBox(height: 16),

                // General info
                Text('General Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
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
                Text('This text appears large at the top of your profile.', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                const SizedBox(height: 12),
                TextField(
                  controller: _bioCtrl,
                  maxLines: 4,
                  style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                  decoration: _inputDec('Bio'),
                ),

                const SizedBox(height: 24),
                Divider(color: AppTheme.glassBorder),
                const SizedBox(height: 16),

                // Contact
                Text('Contact Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
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

  Widget _buildViewMode(ProfileData profile, ProfileState state) {
    final notifier = ref.read(profileProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Edit button
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppTheme.primaryAccent.withOpacity(0.15),
                  AppTheme.secondaryAccent.withOpacity(0.1),
                ]),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryAccent.withOpacity(0.3)),
              ),
              child: ElevatedButton.icon(
                onPressed: () => _startEditing(profile),
                icon: const Icon(Icons.edit, size: 14),
                label: const Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: AppTheme.primaryAccent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Profile card
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassSurface : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                // Banner with gradient — taller, more dramatic
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 120,
                      decoration: const BoxDecoration(
                        gradient: AppTheme.accentGradient,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Center(
                          child: Text(
                            profile.bannerText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white.withOpacity(0.25),
                              letterSpacing: 6,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Centered avatar overlapping the banner
                    Positioned(
                      bottom: -44,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppTheme.accentGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryAccent.withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.backgroundDark : Colors.white,
                          child: Text(
                            profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Name, role, bio — stacked vertically with breathing room
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
                  child: Column(
                    children: [
                      // Name
                      Text(
                        profile.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Role badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            AppTheme.primaryAccent.withOpacity(0.2),
                            AppTheme.secondaryAccent.withOpacity(0.15),
                          ]),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.primaryAccent.withOpacity(0.3)),
                        ),
                        child: ShaderMask(
                          shaderCallback: (bounds) =>
                              AppTheme.accentGradient.createShader(bounds),
                          child: Text(
                            profile.role,
                            style: TextStyle(
                               fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Bio
                      if (profile.bio.isNotEmpty)
                        Text(
                          profile.bio,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                            height: 1.6,
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Divider
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.transparent,
                            AppTheme.glassBorder,
                            AppTheme.primaryAccent.withOpacity(0.3),
                            AppTheme.glassBorder,
                            Colors.transparent,
                          ]),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Contact Info — structured as chips
                      Row(
                        children: [
                          Expanded(
                            child: _buildContactChip(
                              Icons.email_outlined,
                              profile.email,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildContactChip(
                              Icons.phone_outlined,
                              profile.phone,
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

          // ─── Switch Club Section ───
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => AppTheme.accentGradient.createShader(bounds),
                      child: Icon(Icons.swap_horiz_rounded, size: 22, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    const SizedBox(width: 8),
                    Text('Switch Club', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Switch between your club dashboards.', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: profile.clubs.map((club) {
                      final isActive = state.activeClub?.id == club.id;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () => notifier.switchClub(club.id),
                          child: Column(
                            children: [
                              Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: isActive ? AppTheme.accentGradient : null,
                                  border: isActive ? null : Border.all(color: AppTheme.glassBorder, width: 2),
                                  color: isActive ? null : (Theme.of(context).brightness == Brightness.dark ? AppTheme.glassSurface : AppTheme.lightBg),
                                ),
                                child: Center(
                                  child: Text(
                                    club.name.split(' ').last.substring(0, 1),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: isActive ? Colors.white : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 60,
                                child: Text(
                                  club.name,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isActive ? (Theme.of(context).brightness == Brightness.dark ? Colors.white : AppTheme.primaryAccent) : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                if (state.activeClub != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.primaryAccent.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, size: 16, color: AppTheme.primaryAccent),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Active: ${state.activeClub!.name}',
                            style: const TextStyle(fontSize: 12, color: AppTheme.primaryAccent, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          state.activeClub!.role,
                          style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ─── Club Memberships ───
          Row(
            children: [
              ShaderMask(
                shaderCallback: (bounds) => AppTheme.accentGradient.createShader(bounds),
                child: Icon(Icons.emoji_events, size: 20, color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(width: 8),
            Text('Club Memberships', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
            ],
          ),
          const SizedBox(height: 16),

          ...profile.clubs.map((club) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassSurface : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppTheme.accentGradient),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: AppTheme.backgroundDark,
                        child: Text(club.name.split(' ').last[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryAccent)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(club.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                    const SizedBox(height: 4),
                    ShaderMask(
                      shaderCallback: (bounds) => AppTheme.accentGradient.createShader(bounds),
                       child: Text(club.role, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
                    ),
                    const SizedBox(height: 8),
                    Text(club.description, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4)),
                    const SizedBox(height: 14),
                    Divider(color: AppTheme.glassBorder),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.3)),
                              color: const Color(0xFF22C55E).withOpacity(0.1),
                            ),
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.message, size: 14, color: Color(0xFF22C55E)),
                              label: const Text('WhatsApp', style: TextStyle(fontSize: 11, color: Color(0xFF22C55E))),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.tertiaryAccent.withOpacity(0.3)),
                              color: AppTheme.tertiaryAccent.withOpacity(0.1),
                            ),
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.send, size: 14, color: AppTheme.tertiaryAccent),
                              label: Text('Telegram', style: TextStyle(fontSize: 11, color: AppTheme.tertiaryAccent)),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 24),

          // ─── Sign Out Button ───
          GestureDetector(
            onTap: () => GoRouter.of(context).go('/login'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
                color: const Color(0xFFEF4444).withOpacity(0.08),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, size: 20, color: Color(0xFFEF4444)),
                  SizedBox(width: 10),
                  Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildContactChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? AppTheme.backgroundDark.withOpacity(0.5) : AppTheme.lightBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder),
      ),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                AppTheme.accentGradient.createShader(bounds),
            child: Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _editField(TextEditingController ctrl, String label, {IconData? icon}) {
    return TextField(
      controller: ctrl,
      style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        prefixIcon: icon != null ? Icon(icon, size: 18, color: AppTheme.textSecondary) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppTheme.primaryAccent)),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.backgroundDark.withOpacity(0.5) : AppTheme.lightBg,
      ),
    );
  }

  InputDecoration _inputDec(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppTheme.textSecondary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppTheme.primaryAccent)),
      filled: true,
      fillColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.backgroundDark.withOpacity(0.5) : AppTheme.lightBg,
    );
  }
}
