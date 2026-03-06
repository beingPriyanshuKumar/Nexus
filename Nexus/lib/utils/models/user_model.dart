class UserModel {
  final String? id;
  final String name;
  final String email;
  final String? year; // FE, SE, TE, BE
  final bool isAccountVerified;
  final String? phone;
  final String? bio;
  final String? avatar;
  final List<String> skills;
  final String? role;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.year,
    this.isAccountVerified = false,
    this.phone,
    this.bio,
    this.avatar,
    this.skills = const [],
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String?,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      year: json['year'] as String?,
      isAccountVerified: json['isAccountVerified'] as bool? ?? false,
      phone: json['phone'] as String?,
      bio: json['bio'] as String?,
      avatar: json['avatar'] as String?,
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'name': name,
      'email': email,
      if (year != null) 'year': year,
      'isAccountVerified': isAccountVerified,
      if (phone != null) 'phone': phone,
      if (bio != null) 'bio': bio,
      if (avatar != null) 'avatar': avatar,
      'skills': skills,
      if (role != null) 'role': role,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? year,
    bool? isAccountVerified,
    String? phone,
    String? bio,
    String? avatar,
    List<String>? skills,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      year: year ?? this.year,
      isAccountVerified: isAccountVerified ?? this.isAccountVerified,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      avatar: avatar ?? this.avatar,
      skills: skills ?? this.skills,
      role: role ?? this.role,
    );
  }
}
