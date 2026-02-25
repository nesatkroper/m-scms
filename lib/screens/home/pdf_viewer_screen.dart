import 'package:flutter/material.dart';
import 'package:m_scms/constants/constant.dart';
import 'package:m_scms/models/book.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatelessWidget {
  final Book book;
  const PdfViewerScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kWhiteColor),
        backgroundColor: kPrimaryColor,
        title: Text(
          book.name,
          style: const TextStyle(
            color: kWhiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SfPdfViewer.network(
        book.url,
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
          debugPrint("PDF Load Failed: ${details.description}");
          debugPrint("Target URL: ${book.url}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 10),
              content: Text(
                'Failed to load PDF: ${details.description}\nURL: ${book.url}',
              ),
              action: SnackBarAction(
                label: 'Retry',
                onPressed: () {
                  // Basic retry by pop and push
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
