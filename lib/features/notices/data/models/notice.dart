class Notice {
  final int id;
  final String title;
  final String content;
  final int countryId;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Notice({
    required this.id,
    required this.title,
    required this.content,
    required this.countryId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    try {
      return Notice(
        id: json['id']?.toInt() ?? 0,
        title: json['title']?.toString() ?? '',
        content: json['content']?.toString() ?? '',
        countryId: json['countryId']?.toInt() ?? 1,
        status: json['status']?.toInt() ?? 0,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
            : DateTime.now(),
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
            : DateTime.now(),
      );
    } catch (e) {
      print('⚠️ Notice parsing error: $e');
      print('⚠️ Problematic JSON: $json');

      // Return a default notice if parsing fails
      return Notice(
        id: 0,
        title: 'Error Loading Notice',
        content: 'Failed to load notice content',
        countryId: 1,
        status: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'countryId': countryId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Notice copyWith({
    int? id,
    String? title,
    String? content,
    int? countryId,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Notice(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      countryId: countryId ?? this.countryId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Notice(id: $id, title: $title, content: $content, countryId: $countryId, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Notice &&
        other.id == id &&
        other.title == title &&
        other.content == content &&
        other.countryId == countryId &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        content.hashCode ^
        countryId.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
