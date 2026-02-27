import 'package:m_scms/constants/constant.dart';

class Book {
  final String name;
  final String filename;
  final String url;
  final String? thumbnail;
  final String size;
  final String extension;
  final DateTime lastModified;

  Book({
    required this.name,
    required this.filename,
    required this.url,
    this.thumbnail,
    required this.size,
    required this.extension,
    required this.lastModified,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      name: json['name'] ?? 'Unknown Book',
      filename: json['filename'] ?? '',
      url: Constant.resolveUrl(json['url']),
      thumbnail: Constant.resolveUrl(json['thumbnail']),
      size: json['size'] ?? '0 MB',
      extension:
          json['extension'] ??
          (json['filename']?.toString().split('.').last ?? 'pdf'),
      lastModified:
          DateTime.tryParse(json['last_modified'] ?? '') ?? DateTime.now(),
    );
  }
}
