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

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).fetchBooks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final filteredBooks =
        authProvider.books
            .where(
              (book) =>
                  book.name.toLowerCase().contains(_searchQuery.toLowerCase()),
            )
            .toList();

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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: const BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: const TextStyle(color: kDarkGreyColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: kWhiteColor,
                hintText: 'Search for books...',
                hintStyle: TextStyle(color: kGreyColor.withValues(alpha: 0.7)),
                prefixIcon: const Icon(Icons.search, color: kPrimaryColor),
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear, color: kGreyColor),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => authProvider.fetchBooks(),
              child:
                  authProvider.isLoading && authProvider.books.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : filteredBooks.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: kGreyColor.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? "No books available"
                                  : "No books matching '$_searchQuery'",
                              style: const TextStyle(color: kGreyColor),
                            ),
                            if (_searchQuery.isNotEmpty)
                              TextButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                                child: const Text("Clear Search"),
                              ),
                          ],
                        ),
                      )
                      : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: filteredBooks.length,
                        itemBuilder: (context, index) {
                          return _buildBookCard(context, filteredBooks[index]);
                        },
                      ),
            ),
          ),
        ],
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
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: BookThumbnail(book: book),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        book.extension.toUpperCase(),
                        style: const TextStyle(
                          color: kWhiteColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        book.size,
                        style: const TextStyle(fontSize: 12, color: kGreyColor),
                      ),
                      const Icon(
                        Icons.open_in_new,
                        size: 14,
                        color: kPrimaryColor,
                      ),
                    ],
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
      return Container(
        color: kGreyColor.withValues(alpha: 0.1),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
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
        child: Icon(Icons.book, size: 40, color: kPrimaryColor),
      ),
    );
  }
}
