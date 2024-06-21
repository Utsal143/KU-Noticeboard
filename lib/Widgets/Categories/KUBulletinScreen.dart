import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notices_app/Widgets/notices_card.dart';

class Kubulletinscreen extends StatelessWidget {
  const Kubulletinscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KU Bulletin", style: TextStyle(fontSize: 24)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('KU-Notices')
            .where('category', isEqualTo: 'KU Bulletin')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> notices = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notices.length,
            itemBuilder: (BuildContext context, int index) {
              var notice = notices[index].data() as Map<String, dynamic>;
              return NoticeCard(
                  title: notice['title'] ?? '',
                  subtitle: notice['content'] ?? '',
                  imageUrl: notice['image'] ?? '',
                  author: 'Admin',
                  noticesUrl: notice['noticesUrl'] ?? '');
            },
          );
        },
      ),
    );
  }
}
