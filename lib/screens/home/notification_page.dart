import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eduwlc/constants/constant.dart';
import 'package:eduwlc/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userData = authProvider.userData;

    List<dynamic> allNotifications = userData?['notifications'] ?? [];

    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
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

    // Clean up the body text to make it readable
    String rawBody = data['body'] ?? "";
    String cleanBody = rawBody
        .replaceAll('\\r\\n', '\n') // Turn \r\n into actual new lines
        .replaceAll('\\"', '"') // Fix the quotes
        .replaceAll('"', '') // Remove extra quotes for better look
        .replaceAll('{', '') // Optional: remove JSON braces for cleaner text
        .replaceAll(',', '\n'); // Turn commas into new lines for list effect

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
            // Removed maxLines so it shows EVERYTHING
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

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:eduwlc/constants/constant.dart';
// import 'package:eduwlc/providers/auth_provider.dart';
// import 'package:intl/intl.dart';

// class NotificationPage extends StatefulWidget {
//   const NotificationPage({super.key});

//   @override
//   State<NotificationPage> createState() => _NotificationPageState();
// }

// class _NotificationPageState extends State<NotificationPage> {
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final userData = authProvider.userData;

//     List<dynamic> allNotifications = [];
//     if (userData != null) {
//       allNotifications = userData['notifications'] ?? [];
//     }

//     return Scaffold(
//       backgroundColor: kLightGreyColor,
//       appBar: AppBar(
//         backgroundColor: kPrimaryColor,
//         elevation: 0,
//         title: const Text(
//           'Notifications',
//           style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [kPrimaryColor.withValues(alpha: 0.1), kLightGreyColor],
//           ),
//         ),
//         child:
//             allNotifications.isEmpty
//                 ? _buildEmptyState()
//                 : SingleChildScrollView(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       _buildHeaderCard(allNotifications.length),
//                       const SizedBox(height: 24),

//                       ...allNotifications.map(
//                         (noti) => _buildNotificationCard(noti),
//                       ),

//                       const SizedBox(height: 30),
//                     ],
//                   ),
//                 ),
//       ),
//     );
//   }

//   Widget _buildHeaderCard(int count) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [kPrimaryColor, Color(0xFF6A1B9A)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: kPrimaryColor.withValues(alpha: 0.3),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 30,
//             backgroundColor: kWhiteColor.withValues(alpha: 0.2),
//             child: const Icon(
//               Icons.notifications_active,
//               color: kWhiteColor,
//               size: 30,
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'Inbox',
//             style: TextStyle(
//               color: kWhiteColor,
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'You have $count updates today',
//             style: TextStyle(
//               color: kWhiteColor.withValues(alpha: 0.8),
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNotificationCard(dynamic noti) {
//     final data = noti['data'] ?? {};
//     final bool isUnread = noti['read_at'] == null;

//     DateTime createdAt = DateTime.parse(noti['created_at']);
//     String formattedDate = DateFormat(
//       'MMM dd, yyyy • hh:mm a',
//     ).format(createdAt);

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: kWhiteColor,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: IntrinsicHeight(
//         child: Row(
//           children: [
//             Container(
//               width: 5,
//               decoration: BoxDecoration(
//                 color: isUnread ? kPrimaryColor : Colors.transparent,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   bottomLeft: Radius.circular(20),
//                 ),
//               ),
//             ),

//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             data['title'] ?? 'New Update',
//                             style: TextStyle(
//                               fontWeight:
//                                   isUnread ? FontWeight.bold : FontWeight.w600,
//                               fontSize: 16,
//                               color: kDarkGreyColor,
//                             ),
//                           ),
//                         ),
//                         if (isUnread)
//                           Container(
//                             width: 8,
//                             height: 8,
//                             decoration: const BoxDecoration(
//                               color: kPrimaryColor,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       _cleanBodyText(data['body'] ?? ''),
//                       maxLines: 3,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: kGreyColor,
//                         fontSize: 13,
//                         height: 1.4,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.access_time,
//                           size: 14,
//                           color: kGreyColor.withValues(alpha: 0.6),
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           formattedDate,
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: kGreyColor.withValues(alpha: 0.6),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _cleanBodyText(String text) {
//     return text.replaceAll('\\r\\n', ' ').replaceAll('\\"', '"').trim();
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.notifications_none,
//             size: 80,
//             color: kGreyColor.withValues(alpha: 0.3),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             "No notifications yet",
//             style: TextStyle(color: kGreyColor, fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }
// }
