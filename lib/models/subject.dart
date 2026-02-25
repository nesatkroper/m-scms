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
      id: json['id'] is int ? json['id'] : 0,
      name: json['name']?.toString() ?? 'Unknown',
      code: json['code']?.toString() ?? '',
      departmentId:
          json['department_id'] is int
              ? json['department_id']
              : int.tryParse(json['department_id']?.toString() ?? '') ?? 0,
      description: json['description']?.toString() ?? '',
      creditHours:
          json['credit_hours'] is int
              ? json['credit_hours']
              : int.tryParse(json['credit_hours']?.toString() ?? '') ?? 0,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime.now(),
      deletedAt:
          json['deleted_at'] != null
              ? DateTime.tryParse(json['deleted_at'].toString())
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
