import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:m_scms/constants/constant.dart';
import 'package:m_scms/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userData = authProvider.userData;

    List<dynamic> allNotifications = userData?['notifications'] ?? [];

    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: kWhiteColor),
        elevation: 0,
        title: const Text(
          'All Notifications',
          style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: kWhiteColor),
            onPressed: () => authProvider.fetchUserProfile(),
          ),
        ],
      ),
      body:
          allNotifications.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: allNotifications.length,
                itemBuilder: (context, index) {
                  return _buildNotificationCard(allNotifications[index]);
                },
              ),
    );
  }

  Widget _buildNotificationCard(dynamic noti) {
    final data = noti['data'] ?? {};
    final bool isUnread = noti['read_at'] == null;

    String rawBody = data['body'] ?? "";
    String cleanBody = rawBody
        .replaceAll('\\r\\n', '\n')
        .replaceAll('\\"', '"')
        .replaceAll('"', '')
        .replaceAll('{', '')
        .replaceAll(',', '\n');

    DateTime createdAt = DateTime.parse(noti['created_at']);
    String timeAgo = DateFormat('MMM dd • hh:mm a').format(createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(15),
        border:
            isUnread
                ? Border.all(
                  color: kPrimaryColor.withValues(alpha: 0.3),
                  width: 1,
                )
                : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              data['title'] ?? 'Notification',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isUnread ? kPrimaryColor : kDarkGreyColor,
              ),
            ),
            Text(
              timeAgo,
              style: const TextStyle(fontSize: 11, color: kGreyColor),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            cleanBody,
            style: const TextStyle(
              color: Color(0xFF455A64),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
        leading: CircleAvatar(
          backgroundColor:
              isUnread ? kPrimaryColor : kGreyColor.withValues(alpha: 0.2),
          child: Icon(
            isUnread ? Icons.mark_email_unread : Icons.mark_email_read,
            color: isUnread ? kWhiteColor : kGreyColor,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(child: Text("No new notifications"));
  }
}
