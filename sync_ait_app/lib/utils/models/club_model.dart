class ClubModel {
  final String abbr;
  final String name;
  final String? fullForm;
  final String? img;
  final String? desc;
  final List<String> focusAreas;
  final List<String> activities;
  final String? who;
  final List<String> keywords;
  final List<String> events;
  final List<String> media;

  ClubModel({
    required this.abbr,
    required this.name,
    this.fullForm,
    this.img,
    this.desc,
    this.focusAreas = const [],
    this.activities = const [],
    this.who,
    this.keywords = const [],
    this.events = const [],
    this.media = const [],
  });

  factory ClubModel.fromJson(Map<String, dynamic> json) {
    return ClubModel(
      abbr: json['abbr'] as String? ?? '',
      name: json['name'] as String? ?? '',
      fullForm: json['fullForm'] as String?,
      img: json['img'] as String?,
      desc: json['desc'] as String?,
      focusAreas: _parseStringList(json['focusAreas']),
      activities: _parseStringList(json['activities']),
      who: json['who'] as String?,
      keywords: _parseStringList(json['keywords']),
      events: _parseStringList(json['events']),
      media: _parseStringList(json['media']),
    );
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'abbr': abbr,
      'name': name,
      if (fullForm != null) 'fullForm': fullForm,
      if (img != null) 'img': img,
      if (desc != null) 'desc': desc,
      'focusAreas': focusAreas,
      'activities': activities,
      if (who != null) 'who': who,
      'keywords': keywords,
      'events': events,
      'media': media,
    };
  }
}
