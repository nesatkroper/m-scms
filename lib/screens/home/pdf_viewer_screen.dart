import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:m_scms/constants/constant.dart';
import 'package:m_scms/models/book.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io' as io;

class PdfViewerScreen extends StatefulWidget {
  final Book book;
  const PdfViewerScreen({super.key, required this.book});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  dynamic _localFile; // Use dynamic to avoid File issues on web
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _downloadPdf();
  }

  Future<void> _downloadPdf() async {
    if (kIsWeb) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    try {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await http.get(Uri.parse(widget.book.url));

      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final fileName = widget.book.url
            .split('/')
            .last
            .replaceAll('%20', '_')
            .replaceAll(' ', '_');
        final file = io.File('${directory.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);

        if (mounted) {
          setState(() {
            _localFile = file;
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Server returned status code ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kWhiteColor),
        backgroundColor: kPrimaryColor,
        title: Text(
          widget.book.name,
          style: const TextStyle(
            color: kWhiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body:
          _isLoading
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Downloading PDF..."),
                  ],
                ),
              )
              : _errorMessage != null
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: kDangerColor,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Could not load PDF",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: kGreyColor),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "URL: ${widget.book.url}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: kGreyColor, fontSize: 10),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _downloadPdf,
                        child: const Text("Retry Download"),
                      ),
                    ],
                  ),
                ),
              )
              : kIsWeb
              ? SfPdfViewer.network(widget.book.url)
              : SfPdfViewer.file(_localFile!),
    );
  }
}
