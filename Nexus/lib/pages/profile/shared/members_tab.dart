import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../styles/app_theme.dart';
import '../../../providers/profile/profile_provider.dart';
import '../../../utils/models/profile_model.dart';

class MembersTab extends ConsumerStatefulWidget {
  const MembersTab({super.key});

  @override
  ConsumerState<MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends ConsumerState<MembersTab> {
  String _searchTerm = '';
  bool _showAddForm = false;
  bool _isEditing = false;
  String? _currentMemberId;
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _domainCtrl = TextEditingController();
  String _selectedRole = 'FE';
  String _selectedStatus = 'Active';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _domainCtrl.dispose();
    super.dispose();
  }

  void _resetForm() {
    _nameCtrl.clear();
    _emailCtrl.clear();
    _domainCtrl.clear();
    _selectedRole = 'FE';
    _selectedStatus = 'Active';
    _isEditing = false;
    _currentMemberId = null;
  }

  void _openEditModal(MemberData member) {
    setState(() {
      _nameCtrl.text = member.name;
      _emailCtrl.text = member.email;
      _domainCtrl.text = member.domain;
      _selectedRole = member.role;
      _selectedStatus = member.status;
      _currentMemberId = member.id;
      _isEditing = true;
      _showAddForm = true;
    });
  }

  void _handleSubmit() {
    if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _domainCtrl.text.isEmpty) return;
    final notifier = ref.read(profileProvider.notifier);
    final state = ref.read(profileProvider);

    if (_isEditing && _currentMemberId != null) {
      final member = state.allMembers.firstWhere((m) => m.id == _currentMemberId);
      notifier.editMember(member.copyWith(
        name: _nameCtrl.text,
        email: _emailCtrl.text,
        role: _selectedRole,
        domain: _domainCtrl.text,
        status: _selectedStatus,
      ));
    } else {
      notifier.addMember(MemberData(
        id: '',
        clubId: state.activeClub?.id ?? '',
        name: _nameCtrl.text,
        email: _emailCtrl.text,
        role: _selectedRole,
        domain: _domainCtrl.text,
        status: _selectedStatus,
      ));
    }

    setState(() {
      _showAddForm = false;
      _resetForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    final canManage = state.role == 'TE' || state.role == 'SE';
    final members = state.clubMembers
        .where((m) =>
            m.name.toLowerCase().contains(_searchTerm.toLowerCase()) ||
            m.email.toLowerCase().contains(_searchTerm.toLowerCase()) ||
            m.domain.toLowerCase().contains(_searchTerm.toLowerCase()))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Team Members', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  Text(canManage ? 'Manage your team members.' : 'View team members.',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                ],
              ),
              if (canManage)
                Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.accentGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() {
                      if (_showAddForm && !_isEditing) {
                        _showAddForm = false;
                      } else {
                        _resetForm();
                        _showAddForm = true;
                      }
                    }),
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(_showAddForm && !_isEditing ? 'Close' : 'Add Member'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Add/Edit Form
          if (_showAddForm && canManage)
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
                  Text(_isEditing ? 'Edit Member' : 'Add New Member',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
                  const SizedBox(height: 16),
                  _buildTextField(_nameCtrl, 'Name'),
                  const SizedBox(height: 12),
                  _buildTextField(_emailCtrl, 'Email'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedRole,
                          decoration: _inputDecoration('Role'),
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13),
                          items: [
                            const DropdownMenuItem(value: 'FE', child: Text('FE')),
                            if (state.role == 'TE') const DropdownMenuItem(value: 'SE', child: Text('SE')),
                          ],
                          onChanged: (v) => setState(() => _selectedRole = v ?? 'FE'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField(_domainCtrl, 'Domain (e.g. Frontend)')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => setState(() { _showAddForm = false; _resetForm(); }),
                        child: Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(_isEditing ? 'Update Member' : 'Save Member'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          if (_showAddForm) const SizedBox(height: 16),

          // Members list
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder),
            ),
            child: Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text('All Members', style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
                      const Spacer(),
                      SizedBox(
                        width: 200,
                        height: 36,
                        child: TextField(
                          onChanged: (v) => setState(() => _searchTerm = v),
                          style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(color: AppTheme.textSecondary),
                            prefixIcon: Icon(Icons.search, size: 18, color: AppTheme.textSecondary),
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppTheme.glassBorder),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppTheme.glassBorder),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppTheme.primaryAccent),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.backgroundDark.withOpacity(0.5) : AppTheme.lightBg,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder),

                // Members
                if (members.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(child: Text('No members found.', style: TextStyle(color: AppTheme.textSecondary))),
                  )
                else
                  ...members.map((member) => _MemberRow(
                        member: member,
                        canManage: canManage,
                        canEditThisMember: state.role == 'TE' || member.role == 'FE',
                        onEdit: () => _openEditModal(member),
                        onDelete: () => ref.read(profileProvider.notifier).removeMember(member.id),
                      )),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
      decoration: _inputDecoration(hint),
    );
  }

  InputDecoration _inputDecoration(String hint) {
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

class _MemberRow extends StatelessWidget {
  final MemberData member;
  final bool canManage;
  final bool canEditThisMember;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MemberRow({
    required this.member,
    required this.canManage,
    required this.canEditThisMember,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.accentGradient,
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.backgroundDark : Colors.white,
              child: Text(member.name[0], style: const TextStyle(color: AppTheme.primaryAccent, fontWeight: FontWeight.w500, fontSize: 13)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name, style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface, fontSize: 14)),
                const SizedBox(height: 2),
                Text(member.email, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _Badge(text: member.role, color: AppTheme.primaryAccent),
                    _Badge(text: member.domain, color: AppTheme.tertiaryAccent),
                    _Badge(
                      text: member.status,
                      color: member.status == 'Active' ? const Color(0xFF10B981) : AppTheme.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (canManage) ...[
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, size: 18, color: canEditThisMember ? AppTheme.textSecondary : (Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder)),
                  onPressed: canEditThisMember ? onEdit : null,
                  tooltip: canEditThisMember ? 'Edit Member' : 'Cannot edit this role',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(height: 12),
                IconButton(
                  icon: Icon(Icons.delete_outline, size: 18, color: canEditThisMember ? const Color(0xFFEF4444) : (Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder)),
                  onPressed: canEditThisMember ? onDelete : null,
                  tooltip: canEditThisMember ? 'Remove Member' : 'Cannot remove this role',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color)),
    );
  }
}
