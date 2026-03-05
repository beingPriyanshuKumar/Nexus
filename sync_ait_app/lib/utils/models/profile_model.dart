class ClubInfo {
  final String id;
  final String name;
  final String role;
  final String logo;
  final String description;
  final String whatsapp;
  final String telegram;

  const ClubInfo({
    required this.id,
    required this.name,
    required this.role,
    required this.logo,
    required this.description,
    required this.whatsapp,
    required this.telegram,
  });
}

class ProfileData {
  String id;
  String name;
  String email;
  String phone;
  String gender;
  String role;
  List<String> domains;
  List<String> connectedClubs;
  String avatar;
  String bannerText;
  String bio;
  List<ClubInfo> clubs;

  ProfileData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.role,
    required this.domains,
    required this.connectedClubs,
    required this.avatar,
    required this.bannerText,
    required this.bio,
    required this.clubs,
  });

  ProfileData copyWith({
    String? name,
    String? email,
    String? phone,
    String? role,
    String? avatar,
    String? bannerText,
    String? bio,
  }) {
    return ProfileData(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender,
      role: role ?? this.role,
      domains: domains,
      connectedClubs: connectedClubs,
      avatar: avatar ?? this.avatar,
      bannerText: bannerText ?? this.bannerText,
      bio: bio ?? this.bio,
      clubs: clubs,
    );
  }
}

class MemberData {
  final String id;
  final String clubId;
  String name;
  String email;
  String role;
  String domain;
  String status;

  MemberData({
    required this.id,
    required this.clubId,
    required this.name,
    required this.email,
    required this.role,
    required this.domain,
    required this.status,
  });

  MemberData copyWith({
    String? name,
    String? email,
    String? role,
    String? domain,
    String? status,
  }) {
    return MemberData(
      id: id,
      clubId: clubId,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      domain: domain ?? this.domain,
      status: status ?? this.status,
    );
  }
}

class TaskData {
  final String id;
  final String clubId;
  String title;
  String description;
  String assignedTo;
  String assignedToName;
  String status;
  String priority;
  String deadline;
  String createdAt;

  TaskData({
    required this.id,
    required this.clubId,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.assignedToName,
    required this.status,
    required this.priority,
    required this.deadline,
    required this.createdAt,
  });

  TaskData copyWith({
    String? title,
    String? description,
    String? assignedTo,
    String? assignedToName,
    String? status,
    String? priority,
    String? deadline,
  }) {
    return TaskData(
      id: id,
      clubId: clubId,
      title: title ?? this.title,
      description: description ?? this.description,
      assignedTo: assignedTo ?? this.assignedTo,
      assignedToName: assignedToName ?? this.assignedToName,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt,
    );
  }
}

class MessageData {
  final String id;
  final String clubId;
  final String senderId;
  final String senderName;
  final String? receiverId;
  final String content;
  final String timestamp;
  final String avatar;

  const MessageData({
    required this.id,
    required this.clubId,
    required this.senderId,
    required this.senderName,
    this.receiverId,
    required this.content,
    required this.timestamp,
    this.avatar = '',
  });
}

class NotificationData {
  final String id;
  final String title;
  final String message;
  final String type;
  bool isRead;
  final String timestamp;

  NotificationData({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.timestamp,
  });
}
