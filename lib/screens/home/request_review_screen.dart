import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:m_scms/constants/constant.dart';
import 'package:m_scms/providers/auth_provider.dart';
import 'package:m_scms/services/auth_service.dart';

class RequestReviewPage extends StatefulWidget {
  const RequestReviewPage({super.key});

  @override
  State<RequestReviewPage> createState() => _RequestReviewPageState();
}

class _RequestReviewPageState extends State<RequestReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController(
    text: "Review Request",
  );
  final TextEditingController _bodyController = TextEditingController();

  int? _selectedTeacherId;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final enrollments = authProvider.userData?['enrollments'] ?? [];

    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kWhiteColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Request Review",
          style: TextStyle(fontWeight: FontWeight.bold, color: kWhiteColor),
        ),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 24),
              const Text(
                "Select Teacher/Subject",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kGreyColor,
                ),
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: kLightGreyColor.withValues(alpha: 0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                hint: const Text("Choose a course"),
                initialValue: _selectedTeacherId,
                items:
                    enrollments.map<DropdownMenuItem<int>>((dynamic emp) {
                      final course = emp['course_offering'];
                      return DropdownMenuItem<int>(
                        value:
                            course['teacher_id'],
                        child: Text(
                          "${course['subject']['name']} (ID: ${course['teacher_id']})",
                        ),
                      );
                    }).toList(),
                onChanged: (val) => setState(() => _selectedTeacherId = val),
                validator:
                    (val) => val == null ? "Please select a teacher" : null,
              ),

              const SizedBox(height: 20),
              _buildLabel("Message Title"),
              TextFormField(
                controller: _titleController,
                decoration: _inputDecoration("e.g. Assignment Review"),
                validator: (v) => v!.isEmpty ? "Title is required" : null,
              ),

              const SizedBox(height: 20),
              _buildLabel("Your Message"),
              TextFormField(
                controller: _bodyController,
                maxLines: 5,
                decoration: _inputDecoration(
                  "Describe what you want the teacher to review...",
                ),
                validator:
                    (v) => v!.isEmpty ? "Message body is required" : null,
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "Send Request",
                            style: TextStyle(
                              color: kWhiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kPrimaryColor, const Color(0xFF6A1B9A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: kWhiteColor.withValues(alpha: 0.2),
            child: const Icon(Icons.rate_review, color: kWhiteColor, size: 30),
          ),
          const SizedBox(height: 16),
          const Text(
            'Submit a Review Request',
            style: TextStyle(
              color: kWhiteColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your teacher will be notified of your request.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kWhiteColor.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final service = AuthService();
    final result = await service.sendRequestReview(
      teacherId: _selectedTeacherId!,
      title: _titleController.text,
      body: _bodyController.text,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (result['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Request sent successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? "Failed to send"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: kDarkGreyColor,
        fontSize: 16,
      ),
    ),
  );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: kGreyColor.withValues(alpha: 0.5)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: kGreyColor.withValues(alpha: 0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: kPrimaryColor, width: 2),
    ),
  );
}
