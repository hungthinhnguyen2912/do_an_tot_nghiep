import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:graduate/view/Log_in_page.dart';
import 'package:graduate/widget/Bottom_navigation_bar.dart';

import '../P.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxString nameUser = "".obs ;
  RxString avaUrl = "".obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCurrentUser();
  }

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Kiểm tra xem user đã được xác thực chưa
      if (userCredential.user != null) {
        Get.snackbar("Success", "Login successful!");
        Get.offAll(() => BottomNavBar()); // Điều hướng đến Home
      } else {
        Get.snackbar("Warning", "Login failed. Please try again.");
      }
    }  catch (e) {
      if (e is FirebaseAuthException) {
        // Firebase Authentication error
        if (e.code == 'user-not-found') {
          // Handle user not found error
          Get.snackbar("Error", "User not found");
        } else if (e.code == 'wrong-password') {
          // Handle wrong password error
          Get.snackbar("Error", "Wrong pass");
        } else {
          // Handle other Firebase Authentication errors
          Get.snackbar("Error", "Dont know error");
          // print(e.code);
        }
      } else {
        // Handle non-Firebase Authentication errors
        // print('An unexpected error occurred: $e');
      }
    }
  }
  Future<void> signOut ()async {
    await _auth.signOut();
  }
  Future<void> register(String email, String password, String username) async {
    if (email.trim().isEmpty || password.trim().isEmpty || username.trim().isEmpty) {
      Get.snackbar("Error", "All fields are required.");
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        // Kiểm tra Firestore có bị null không
        await _firestore.collection('User').doc(user.uid).set({
          "uid": user.uid,
          "email": user.email,
          "username": username,
          "createdAt": FieldValue.serverTimestamp(),
          "avaUrl" : ""
        });

        Get.snackbar("Success", "Registration successful! Please log in.");
        Get.off(() => LogInPage());
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error Register", e.message ?? "Registration failed");
    } catch (e) {
      Get.snackbar("Fire store Error","");
      // print("Failed to write user data: ${e.toString()}");
    }
  }
  Future<void> getCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection("User").doc(user.uid).get();
      if (userDoc.exists) {
        // print("Dữ liệu user từ Firestore: ${userDoc.data()}");
        nameUser.value = userDoc["username"] ?? "Không có tên";
        avaUrl.value = userDoc["avaUrl"] ?? "";
      } else {
        // print("Không tìm thấy user trong Firestore");
        nameUser.value = "Không có tên";
        avaUrl.value = "";
      }
    } else {
      // print("Không có user nào đang đăng nhập");
    }
  }

  Future<void> uploadAvaUrlToFirebase(String ava) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection("User").doc(user.uid).update({
        "avaUrl": ava
      });
      avaUrl.value = ava;
    }
  }

}