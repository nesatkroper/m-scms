import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:m_scms/constants/constant.dart';
import 'package:m_scms/providers/auth_provider.dart';
import 'package:m_scms/models/book.dart';
import 'package:m_scms/screens/home/pdf_viewer_screen.dart';
import 'package:pdfx/pdfx.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).fetchBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kWhiteColor),
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: const Text(
          'Library',
          style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: kWhiteColor),
            onPressed: () => authProvider.fetchBooks(),
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
            authProvider.isLoading && authProvider.books.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : authProvider.books.isEmpty
                ? const Center(child: Text("No books available"))
                : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: authProvider.books.length,
                  itemBuilder: (context, index) {
                    return _buildBookCard(context, authProvider.books[index]);
                  },
                ),
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, Book book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PdfViewerScreen(book: book)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: BookThumbnail(book: book),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: kDarkGreyColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.size,
                    style: const TextStyle(fontSize: 12, color: kGreyColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookThumbnail extends StatefulWidget {
  final Book book;
  const BookThumbnail({super.key, required this.book});

  @override
  State<BookThumbnail> createState() => _BookThumbnailState();
}

class _BookThumbnailState extends State<BookThumbnail> {
  String? _thumbnailPath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    if (widget.book.thumbnail != null && widget.book.thumbnail!.isNotEmpty) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      return;
    }
    try {
      final directory = await getTemporaryDirectory();
      final fileName = widget.book.url.split('/').last.replaceAll(' ', '_');
      final path = '${directory.path}/thumb_$fileName.png';
      final file = File(path);

      if (await file.exists()) {
        if (mounted) {
          setState(() {
            _thumbnailPath = path;
            _isLoading = false;
          });
        }
        return;
      }

      final response = await http.get(Uri.parse(widget.book.url));

      if (response.statusCode != 200) {
        throw Exception('Server returned ${response.statusCode}');
      }
      final pdfFile = File('${directory.path}/temp_$fileName.pdf');
      await pdfFile.writeAsBytes(response.bodyBytes);

      final document = await PdfDocument.openFile(pdfFile.path);
      final page = await document.getPage(1);
      final pageImage = await page.render(
        width: page.width,
        height: page.height,
      );

      await file.writeAsBytes(pageImage!.bytes);
      await document.close();
      await pdfFile.delete();

      if (mounted) {
        setState(() {
          _thumbnailPath = path;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Thumbnail generation error: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (widget.book.thumbnail != null && widget.book.thumbnail!.isNotEmpty) {
      return Image.network(
        widget.book.thumbnail!,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    }
    if (_thumbnailPath != null) {
      return Image.file(
        File(_thumbnailPath!),
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: kPrimaryColor.withValues(alpha: 0.1),
      child: const Center(
        child: Icon(Icons.book, size: 50, color: kPrimaryColor),
      ),
    );
  }
}
