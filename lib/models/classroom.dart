class Classroom {
  final int id;
  final String name;
  final String roomNumber;
  final int capacity;
  final DateTime createdAt;
  final DateTime updatedAt;

  Classroom({
    required this.id,
    required this.name,
    required this.roomNumber,
    required this.capacity,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id:
          json['id'] is int
              ? json['id']
              : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? 'Unknown',
      roomNumber: json['room_number']?.toString() ?? 'N/A',
      capacity:
          json['capacity'] is int
              ? json['capacity']
              : int.tryParse(json['capacity']?.toString() ?? '0') ?? 0,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
