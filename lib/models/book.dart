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
    String sanitizeUrl(String? url) {
      if (url == null || url.isEmpty) return '';

      String processedUrl = url.trim();

      // If the URL from backend uses a local domain, replace it with our Constant.url
      // to ensure it works on emulators (10.0.2.2) or physical devices.
      final baseUrl = Constant.url;
      final localHosts = ['scms.local', 'localhost', '127.0.0.1'];

      // Ensure baseUrl doesn't have a trailing slash for replacement
      String cleanBaseUrl =
          baseUrl.endsWith('/')
              ? baseUrl.substring(0, baseUrl.length - 1)
              : baseUrl;

      for (var host in localHosts) {
        if (processedUrl.contains(host)) {
          processedUrl = processedUrl.replaceAll(
            RegExp('https?://$host(:\\d+)?'),
            cleanBaseUrl,
          );
        }
      }

      try {
        // Decode first to prevent double encoding, then encode properly
        return Uri.encodeFull(Uri.decodeFull(processedUrl));
      } catch (e) {
        return processedUrl.replaceAll(' ', '%20');
      }
    }

    return Book(
      name: json['name'] ?? 'Unknown Book',
      filename: json['filename'] ?? '',
      url: sanitizeUrl(json['url']),
      thumbnail: sanitizeUrl(json['thumbnail']),
      size: json['size'] ?? '0 MB',
      extension:
          json['extension'] ??
          (json['filename']?.toString().split('.').last ?? 'pdf'),
      lastModified:
          DateTime.tryParse(json['last_modified'] ?? '') ?? DateTime.now(),
    );
  }
}
