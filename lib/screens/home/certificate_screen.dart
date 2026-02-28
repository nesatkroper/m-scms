import 'package:flutter/material.dart';
import 'package:m_scms/constants/constant.dart';
import 'package:provider/provider.dart';
import 'package:m_scms/providers/auth_provider.dart';
import 'package:m_scms/screens/home/pdf_viewer_screen.dart';
import 'package:m_scms/screens/home/image_viewer_screen.dart';
import 'package:m_scms/models/book.dart';
import 'package:path/path.dart' as p;

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userData = authProvider.userData;

    List<dynamic> enrollments = [];
    if (userData != null && userData['enrollments'] != null) {
      enrollments =
          (userData['enrollments'] as List)
              .where(
                (e) =>
                    e['certificate'] != null &&
                    e['certificate'].toString().isNotEmpty,
              )
              .toList();
    }

    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: kWhiteColor),
        elevation: 0,
        title: const Text(
          'My Certificates',
          style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: kWhiteColor),
            onPressed: () => authProvider.fetchUserProfile(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kPrimaryColor.withValues(alpha: 0.1), kLightGreyColor],
          ),
        ),
        child:
            enrollments.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: enrollments.length,
                  itemBuilder: (context, index) {
                    return _buildCertificateCard(enrollments[index]);
                  },
                ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.workspace_premium_outlined,
            size: 80,
            color: kGreyColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Certificates Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kDarkGreyColor,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Your official certificates will appear here once you complete your courses.',
              textAlign: TextAlign.center,
              style: TextStyle(color: kGreyColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateCard(dynamic enrollment) {
    final offering = enrollment['course_offering'] ?? {};
    final subject = offering['subject'] ?? {};
    final certPath = enrollment['certificate'].toString();
    final subjectName = subject['name'] ?? 'Unknown Course';

    final extension = p.extension(certPath).toLowerCase();
    final isImage = ['.png', '.jpg', '.jpeg', '.webp'].contains(extension);
    final fullUrl = Constant.resolveUrl(certPath);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kAccentColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.workspace_premium,
                color: kAccentColor,
                size: 28,
              ),
            ),
            title: Text(
              subjectName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: kDarkGreyColor,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Course Code: ${subject['code'] ?? 'N/A'}',
                  style: const TextStyle(fontSize: 12, color: kGreyColor),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: kSuccessColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'COMPLETED',
                      style: TextStyle(
                        color: kSuccessColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                if (isImage) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ImageViewerScreen(
                            imageUrl: fullUrl,
                            title: "Certificate - $subjectName",
                          ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PdfViewerScreen(
                            book: Book(
                              name: "Certificate - $subjectName",
                              filename: certPath.split('/').last,
                              url: fullUrl,
                              size: "N/A",
                              extension: "pdf",
                              lastModified: DateTime.now(),
                            ),
                          ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: kWhiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: Text(isImage ? 'Download' : 'View Cert'),
            ),
          ),
          if (isImage)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: Image.network(
                  fullUrl,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.grey.withValues(alpha: 0.1),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image,
                              color: kGreyColor,
                              size: 40,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Certificate Image Not Found',
                              style: TextStyle(color: kGreyColor, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
