import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/models/profile_model.dart';

class ProfileState {
  final ProfileData profile;
  final List<MemberData> allMembers;
  final List<TaskData> allTasks;
  final List<MessageData> allMessages;
  final List<NotificationData> notifications;
  final String activeTab;
  final ClubInfo? activeClub;
  final String role;

  const ProfileState({
    required this.profile,
    required this.allMembers,
    required this.allTasks,
    required this.allMessages,
    required this.notifications,
    this.activeTab = 'overview',
    this.activeClub,
    required this.role,
  });

  List<MemberData> get clubMembers {
    if (activeClub == null) return [];
    return allMembers.where((m) {
      final clubs = m.clubId.split(',').map((c) => c.trim()).toList();
      return clubs.contains(activeClub!.id);
    }).toList();
  }

  List<TaskData> get clubTasks {
    if (activeClub == null) return [];
    return allTasks.where((t) => t.clubId == activeClub!.id).toList();
  }

  List<MessageData> get clubMessages {
    if (activeClub == null) return [];
    return allMessages.where((m) => m.clubId == activeClub!.id).toList();
  }

  int get unreadNotificationsCount => notifications.where((n) => !n.isRead).length;
  int get pendingTasksCount => clubTasks.where((t) => t.status != 'Completed').length;

  ProfileState copyWith({
    ProfileData? profile,
    List<MemberData>? allMembers,
    List<TaskData>? allTasks,
    List<MessageData>? allMessages,
    List<NotificationData>? notifications,
    String? activeTab,
    ClubInfo? activeClub,
    String? role,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      allMembers: allMembers ?? this.allMembers,
      allTasks: allTasks ?? this.allTasks,
      allMessages: allMessages ?? this.allMessages,
      notifications: notifications ?? this.notifications,
      activeTab: activeTab ?? this.activeTab,
      activeClub: activeClub ?? this.activeClub,
      role: role ?? this.role,
    );
  }
}

/// Holds the initialization data for the profile provider.
/// Each panel sets this provider before using profileProvider.
class ProfileInitData {
  final ProfileData profile;
  final List<MemberData> members;
  final List<TaskData> tasks;
  final List<MessageData> messages;
  final List<NotificationData> notifications;
  final String role;

  const ProfileInitData({
    required this.profile,
    required this.members,
    required this.tasks,
    required this.messages,
    required this.notifications,
    required this.role,
  });
}

/// Provider to hold the init data — overridden per panel via ProviderScope
final profileInitDataProvider = Provider<ProfileInitData>((ref) {
  throw UnimplementedError('profileInitDataProvider must be overridden');
});

/// Riverpod v3 Notifier for profile state management.
class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    final init = ref.watch(profileInitDataProvider);
    return ProfileState(
      profile: init.profile,
      allMembers: init.members,
      allTasks: init.tasks,
      allMessages: init.messages,
      notifications: init.notifications,
      activeClub: init.profile.clubs.isNotEmpty ? init.profile.clubs[0] : null,
      role: init.role,
    );
  }

  void setActiveTab(String tab) {
    state = state.copyWith(activeTab: tab);
  }

  void switchClub(String clubId) {
    final club = state.profile.clubs.firstWhere(
      (c) => c.id == clubId,
      orElse: () => state.profile.clubs[0],
    );
    state = state.copyWith(activeClub: club);
  }

  void addTask(TaskData task) {
    final newTask = TaskData(
      id: 't${DateTime.now().millisecondsSinceEpoch}',
      clubId: task.clubId.isEmpty ? (state.activeClub?.id ?? '') : task.clubId,
      title: task.title,
      description: task.description,
      assignedTo: task.assignedTo,
      assignedToName: state.allMembers
              .where((m) => m.id == task.assignedTo)
              .map((m) => m.name)
              .firstOrNull ??
          'Unknown',
      status: 'Pending',
      priority: task.priority,
      deadline: task.deadline,
      createdAt: DateTime.now().toIso8601String(),
    );
    state = state.copyWith(allTasks: [...state.allTasks, newTask]);
    _addNotification('Task Created', 'Task "${task.title}" assigned to ${newTask.assignedToName}.', 'info');
  }

  void editTask(TaskData updatedTask) {
    final tasks = state.allTasks.map((t) => t.id == updatedTask.id ? updatedTask : t).toList();
    state = state.copyWith(allTasks: tasks);
    _addNotification('Task Updated', 'Task "${updatedTask.title}" has been updated.', 'info');
  }

  void deleteTask(String id) {
    state = state.copyWith(allTasks: state.allTasks.where((t) => t.id != id).toList());
  }

  void updateTaskStatus(String id, String status) {
    final tasks = state.allTasks.map((t) => t.id == id ? t.copyWith(status: status) : t).toList();
    state = state.copyWith(allTasks: tasks);
  }

  void sendMessage(String content, {String? receiverId}) {
    final newMsg = MessageData(
      id: 'msg${DateTime.now().millisecondsSinceEpoch}',
      clubId: state.activeClub?.id ?? '',
      senderId: state.profile.id,
      senderName: state.profile.name,
      receiverId: receiverId,
      content: content,
      timestamp: DateTime.now().toIso8601String(),
    );
    state = state.copyWith(allMessages: [...state.allMessages, newMsg]);
  }

  void addMember(MemberData member) {
    final newMember = MemberData(
      id: 'm${DateTime.now().millisecondsSinceEpoch}',
      clubId: member.clubId,
      name: member.name,
      email: member.email,
      role: member.role,
      domain: member.domain,
      status: member.status,
    );
    state = state.copyWith(allMembers: [...state.allMembers, newMember]);
    _addNotification('Member Added', '${member.name} added to the team.', 'success');
  }

  void editMember(MemberData updatedMember) {
    final members = state.allMembers.map((m) => m.id == updatedMember.id ? updatedMember : m).toList();
    state = state.copyWith(allMembers: members);
  }

  void removeMember(String id) {
    state = state.copyWith(allMembers: state.allMembers.where((m) => m.id != id).toList());
  }

  void markNotificationRead(String id) {
    final notifications = state.notifications.map((n) {
      if (n.id == id) {
        n.isRead = true;
      }
      return n;
    }).toList();
    state = state.copyWith(notifications: notifications);
  }

  void updateProfile(ProfileData updatedProfile) {
    state = state.copyWith(profile: updatedProfile);
  }

  void _addNotification(String title, String message, String type) {
    final newNotif = NotificationData(
      id: 'n${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      type: type,
      isRead: false,
      timestamp: DateTime.now().toIso8601String(),
    );
    state = state.copyWith(notifications: [newNotif, ...state.notifications]);
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(ProfileNotifier.new);
