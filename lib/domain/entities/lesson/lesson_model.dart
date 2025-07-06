class Lesson {
  final int id;
  final String title;
  final String videoKey;
  final int? duration;
  final int? sequenceOrder;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int courseId;

  Lesson({
    required this.id,
    required this.title,
    required this.videoKey,
    this.duration,
    this.sequenceOrder,
    required this.createdAt,
    this.updatedAt,
    required this.courseId,
  });

  static Lesson fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      videoKey: json['video_key'],
      duration: json['duration'],
      sequenceOrder: json['sequence_order'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      courseId: json['course_id'],
    );
  }

}
