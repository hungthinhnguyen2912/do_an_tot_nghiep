import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  final String kind;
  final String imageUrl;
  final String userId;
  final Timestamp timestamp;
  History(this.userId, this.timestamp, {required this.kind, required this.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      'kind': this.kind,
      'imageUrl': this.imageUrl,
      'userId': this.userId,
      'timestamp' : this.timestamp
    };
  }

}