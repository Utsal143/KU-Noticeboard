import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference noticesCollection =
      FirebaseFirestore.instance.collection('KU-Notices');

  Future<void> addNotice(
      String title,
      String content,
      String imageUrl,
      String noticesUrl,
      Timestamp scheduledAt,
      String fcmToken,
      String category) async {
    Timestamp createdAt = Timestamp.now();
    await noticesCollection.add({
      'title': title,
      'content': content,
      'image': imageUrl,
      'noticesUrl': noticesUrl,
      'created_at': createdAt,
      'scheduled_at': scheduledAt,
      'fcmToken': fcmToken,
      'category': category
    });
  }

  Stream<List<QueryDocumentSnapshot>> getNoticesStream() {
    return noticesCollection.snapshots().map((snapshot) => snapshot.docs);
  }
}
