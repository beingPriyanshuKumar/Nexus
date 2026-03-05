import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/profile/profile_provider.dart';
import '../../../utils/models/profile_model.dart';

class TasksTab extends ConsumerStatefulWidget {
  const TasksTab({super.key});

  @override
  ConsumerState<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends ConsumerState<TasksTab> {
  bool _showAddForm = false;
  bool _isEditing = false;
  String? _currentTaskId;
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _deadlineCtrl = TextEditingController();
  String _selectedAssignee = '';
  String _selectedPriority = 'Medium';

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _deadlineCtrl.dispose();
    super.dispose();
  }

  void _resetForm() {
    _titleCtrl.clear();
    _descCtrl.clear();
    _deadlineCtrl.clear();
    _selectedAssignee = '';
    _selectedPriority = 'Medium';
    _isEditing = false;
    _currentTaskId = null;
  }

  void _openEditModal(TaskData task) {
    setState(() {
      _titleCtrl.text = task.title;
      _descCtrl.text = task.description;
      _deadlineCtrl.text = task.deadline;
      _selectedAssignee = task.assignedTo;
      _selectedPriority = task.priority;
      _currentTaskId = task.id;
      _isEditing = true;
      _showAddForm = true;
    });
  }

  void _handleSubmit() {
    if (_titleCtrl.text.isEmpty || _selectedAssignee.isEmpty) return;
    final notifier = ref.read(profileProvider.notifier);
    final state = ref.read(profileProvider);

    if (_isEditing && _currentTaskId != null) {
      final task = state.allTasks.firstWhere((t) => t.id == _currentTaskId);
      notifier.editTask(task.copyWith(
        title: _titleCtrl.text,
        description: _descCtrl.text,
        assignedTo: _selectedAssignee,
        assignedToName: state.allMembers.where((m) => m.id == _selectedAssignee).map((m) => m.name).firstOrNull ?? 'Unknown',
        deadline: _deadlineCtrl.text,
        priority: _selectedPriority,
      ));
    } else {
      notifier.addTask(TaskData(
        id: '',
        clubId: state.activeClub?.id ?? '',
        title: _titleCtrl.text,
        description: _descCtrl.text,
        assignedTo: _selectedAssignee,
        assignedToName: '',
        status: 'Pending',
        priority: _selectedPriority,
        deadline: _deadlineCtrl.text,
        createdAt: '',
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
    final role = state.role;
    final members = state.clubMembers;
    final assignableMembers = role == 'TE' ? members : members.where((m) => m.role == 'FE').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Active Tasks', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                  Text('Track project progress.', style: TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
                ],
              ),
              if (role != 'FE')
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
                  label: Text(_showAddForm && !_isEditing ? 'Close' : 'New Task'),
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
          if (_showAddForm && role != 'FE')
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_isEditing ? 'Edit Task' : 'Create Task',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF111827))),
                  const SizedBox(height: 16),
                  _buildField(_titleCtrl, 'Task Title'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedAssignee.isEmpty ? null : _selectedAssignee,
                          decoration: _inputDec('Assign To...'),
                          dropdownColor: Colors.white,
                          items: assignableMembers.map((m) => DropdownMenuItem(value: m.id, child: Text('${m.name} (${m.role})'))).toList(),
                          onChanged: (v) => setState(() => _selectedAssignee = v ?? ''),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedPriority,
                          decoration: _inputDec('Priority'),
                          dropdownColor: Colors.white,
                          items: const [
                            DropdownMenuItem(value: 'Low', child: Text('Low Priority')),
                            DropdownMenuItem(value: 'Medium', child: Text('Medium Priority')),
                            DropdownMenuItem(value: 'High', child: Text('High Priority')),
                          ],
                          onChanged: (v) => setState(() => _selectedPriority = v ?? 'Medium'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildField(_deadlineCtrl, 'Deadline (YYYY-MM-DD)'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descCtrl,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF111827)),
                    decoration: _inputDec('Description (Optional)'),
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
                        child: Text(_isEditing ? 'Update Task' : 'Create Task'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Kanban columns
          ...['Pending', 'In Progress', 'Completed'].map((status) {
            final tasksForStatus = state.clubTasks.where((t) {
              if (t.status != status) return false;
              if (role == 'TE') return true;
              final assignedMember = members.where((m) => m.id == t.assignedTo).firstOrNull;
              return assignedMember?.role == 'FE';
            }).toList();

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(status, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6B7280), letterSpacing: 0.5)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
                        ),
                        child: Text('${tasksForStatus.length}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF374151))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (tasksForStatus.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE5E7EB), style: BorderStyle.solid, width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(child: Text('Empty', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13))),
                    )
                  else
                    ...tasksForStatus.map((task) => _TaskCard(
                          task: task,
                          canManage: role != 'FE',
                          onEdit: () => _openEditModal(task),
                          onDelete: () => ref.read(profileProvider.notifier).deleteTask(task.id),
                          onComplete: () => ref.read(profileProvider.notifier).updateTaskStatus(task.id, 'Completed'),
                        )),
                ],
              ),
            );
          }),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(fontSize: 13, color: Color(0xFF111827)),
      decoration: _inputDec(hint),
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

class _TaskCard extends StatelessWidget {
  final TaskData task;
  final bool canManage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onComplete;

  const _TaskCard({
    required this.task,
    required this.canManage,
    required this.onEdit,
    required this.onDelete,
    required this.onComplete,
  });

  Color _priorityColor() {
    switch (task.priority) {
      case 'High': return const Color(0xFFDC2626);
      case 'Medium': return const Color(0xFFF59E0B);
      default: return const Color(0xFF3B82F6);
    }
  }

  Color _priorityBg() {
    switch (task.priority) {
      case 'High': return const Color(0xFFFEF2F2);
      case 'Medium': return const Color(0xFFFFFBEB);
      default: return const Color(0xFFEFF6FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(task.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF111827))),
              ),
              if (canManage) ...[
                GestureDetector(
                  onTap: onEdit,
                  child: const Icon(Icons.edit, size: 14, color: Color(0xFF9CA3AF)),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onDelete,
                  child: const Icon(Icons.delete_outline, size: 14, color: Color(0xFF9CA3AF)),
                ),
              ],
            ],
          ),
          if (task.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(task.description, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _priorityBg(),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: _priorityColor().withValues(alpha: 0.3)),
                ),
                child: Text(task.priority, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: _priorityColor())),
              ),
              const SizedBox(width: 8),
              Icon(Icons.person, size: 12, color: const Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Text(task.assignedToName.split(' ')[0], style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 12, color: Color(0xFF9CA3AF)),
                  const SizedBox(width: 4),
                  Text(task.deadline, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
                ],
              ),
              if (task.status != 'Completed')
                GestureDetector(
                  onTap: onComplete,
                  child: const Text('Complete', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF059669))),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
