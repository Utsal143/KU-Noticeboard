import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notices_app/Widgets/notices_card.dart';

class AllRecentNoticesScreen extends StatelessWidget {
  final List<QueryDocumentSnapshot> recentNotices;

  const AllRecentNoticesScreen({Key? key, required this.recentNotices})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text('All Recent Notices'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: recentNotices.length,
          itemBuilder: (context, index) {
            var notice = recentNotices[index].data() as Map<String, dynamic>;
            return NoticeCard(
              title: notice['title'] ?? '',
              subtitle: notice['content'] ?? '',
              imageUrl: notice['image'] ?? '',
              author: 'Admin',
              elevation: 5,
              noticesUrl: notice['notices'],
            );
          },
        ),
      ),
    );
  }
}
