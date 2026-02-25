class Subject {
  final int id;
  final String name;
  final String code;
  final int departmentId;
  final String description;
  final int creditHours;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Subject({
    required this.id,
    required this.name,
    required this.code,
    required this.departmentId,
    required this.description,
    required this.creditHours,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      departmentId:
          json['department_id'] is int
              ? json['department_id']
              : int.tryParse(json['department_id'].toString()) ?? 0,
      description: json['description'] as String,
      creditHours:
          json['credit_hours'] is int
              ? json['credit_hours']
              : int.tryParse(json['credit_hours'].toString()) ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt:
          (json['deleted_at'] != null && json['deleted_at'] is String)
              ? DateTime.tryParse(json['deleted_at'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'department_id': departmentId,
      'description': description,
      'credit_hours': creditHours,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
