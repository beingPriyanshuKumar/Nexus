import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                  const Text('Team Members', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                  Text(canManage ? 'Manage your team members.' : 'View team members.',
                      style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
                ],
              ),
              if (canManage)
                ElevatedButton.icon(
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
                    backgroundColor: const Color(0xFF111827),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_isEditing ? 'Edit Member' : 'Add New Member',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF111827))),
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
                          dropdownColor: Colors.white,
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
                        child: const Text('Cancel', style: TextStyle(color: Color(0xFF6B7280))),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(_isEditing ? 'Update Member' : 'Save Member'),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Text('All Members', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
                      const Spacer(),
                      SizedBox(
                        width: 200,
                        height: 36,
                        child: TextField(
                          onChanged: (v) => setState(() => _searchTerm = v),
                          style: const TextStyle(fontSize: 13, color: Color(0xFF111827)),
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                            prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF9CA3AF)),
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF2563EB)),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),

                // Members
                if (members.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: Text('No members found.', style: TextStyle(color: Color(0xFF6B7280)))),
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
      style: const TextStyle(fontSize: 13, color: Color(0xFF111827)),
      decoration: _inputDecoration(hint),
    );
  }

  InputDecoration _inputDecoration(String hint) {
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
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFEFF6FF),
            child: Text(member.name[0], style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w500)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827), fontSize: 14)),
                const SizedBox(height: 2),
                Text(member.email, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _Badge(text: member.role, bg: const Color(0xFFF3F4F6), fg: const Color(0xFF374151)),
                    _Badge(text: member.domain, bg: const Color(0xFFEFF6FF), fg: const Color(0xFF1D4ED8)),
                    _Badge(
                      text: member.status,
                      bg: member.status == 'Active' ? const Color(0xFFECFDF5) : const Color(0xFFF9FAFB),
                      fg: member.status == 'Active' ? const Color(0xFF047857) : const Color(0xFF6B7280),
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
                  icon: Icon(Icons.edit, size: 18, color: canEditThisMember ? const Color(0xFF6B7280) : const Color(0xFFD1D5DB)),
                  onPressed: canEditThisMember ? onEdit : null,
                  tooltip: canEditThisMember ? 'Edit Member' : 'Cannot edit this role',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(height: 12),
                IconButton(
                  icon: Icon(Icons.delete_outline, size: 18, color: canEditThisMember ? const Color(0xFFEF4444) : const Color(0xFFD1D5DB)),
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
  final Color bg;
  final Color fg;
  const _Badge({required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: fg.withValues(alpha: 0.2)),
      ),
      child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: fg)),
    );
  }
}
