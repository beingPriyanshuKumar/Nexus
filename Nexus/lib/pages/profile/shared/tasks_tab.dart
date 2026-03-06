import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../styles/app_theme.dart';
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Active Tasks', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  Text('Track project progress.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                ],
              ),
              if (role != 'FE')
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
                    label: Text(_showAddForm && !_isEditing ? 'Close' : 'New Task'),
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
          if (_showAddForm && role != 'FE')
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_isEditing ? 'Edit Task' : 'Create Task',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
                  const SizedBox(height: 16),
                  _buildField(_titleCtrl, 'Task Title'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedAssignee.isEmpty ? null : _selectedAssignee,
                          decoration: _inputDec('Assign To...'),
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13),
                          items: assignableMembers.map((m) => DropdownMenuItem(value: m.id, child: Text('${m.name} (${m.role})'))).toList(),
                          onChanged: (v) => setState(() => _selectedAssignee = v ?? ''),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedPriority,
                          decoration: _inputDec('Priority'),
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13),
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
                    style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                    decoration: _inputDec('Description (Optional)'),
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
                          child: Text(_isEditing ? 'Update Task' : 'Create Task'),
                        ),
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
                color: state.activeTab == 'explore' ? Colors.transparent : (Theme.of(context).brightness == Brightness.dark ? AppTheme.backgroundDark.withOpacity(0.5) : Colors.white),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary, letterSpacing: 0.5)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.glassSurface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.glassBorder),
                        ),
                        child: Text('${tasksForStatus.length}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (tasksForStatus.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.glassBorder, style: BorderStyle.solid, width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(child: Text('Empty', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13))),
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
      style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
      decoration: _inputDec(hint),
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
      case 'High': return const Color(0xFFEF4444);
      case 'Medium': return const Color(0xFFF59E0B);
      default: return AppTheme.primaryAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassSurface : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(task.title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
              ),
              if (canManage) ...[
                GestureDetector(
                  onTap: onEdit,
                  child: Icon(Icons.edit, size: 14, color: AppTheme.textSecondary),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(Icons.delete_outline, size: 14, color: AppTheme.textSecondary),
                ),
              ],
            ],
          ),
          if (task.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(task.description, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _priorityColor().withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: _priorityColor().withOpacity(0.3)),
                ),
                child: Text(task.priority, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: _priorityColor())),
              ),
              const SizedBox(width: 8),
              Icon(Icons.person, size: 12, color: AppTheme.textSecondary),
              const SizedBox(width: 4),
              Text(task.assignedToName.split(' ')[0], style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 12, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text(task.deadline, style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                ],
              ),
              if (task.status != 'Completed')
                GestureDetector(
                  onTap: onComplete,
                  child: const Text('Complete', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF10B981))),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
