import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  HistoryPage({super.key}) : userId = FirebaseAuth.instance.currentUser?.uid ?? "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection("History")
            .where("userId", isEqualTo: userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error loading history"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No history found!"));
          }

          var historyList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              var history = historyList[index];

              return Card(
                child: ListTile(
                  leading: history['imageUrl'] != null
                      ? Image.network(history['imageUrl'], width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.image_not_supported), // Icon thay thế nếu không có ảnh
                  title: Text(history['kind'] ?? "Unknown"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

