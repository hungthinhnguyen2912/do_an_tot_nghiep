class History {
  final String kind;
  final String imageUrl;
  final String userId;
  History(this.userId, {required this.kind, required this.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      'kind': this.kind,
      'imageUrl': this.imageUrl,
      'userId': this.userId,
    };
  }

  // factory History.fromMap(Map<String, dynamic> map) {
  //   return History(
  //     kind: map['kind'] as String,
  //     imageUrl: map['imageUrl'] as String,
  //     userId: map['userId'] as String,
  //   );
  // }
}