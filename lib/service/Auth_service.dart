import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduate/view/Log_in_page.dart';
import 'package:graduate/widget/Bottom_navigation_bar.dart';

import '../P.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxString nameUser = "".obs;
  RxString emailUser = "".obs;
  RxString avaUrl = "".obs;

  @override
  void onInit() {
    super.onInit();
    if (FirebaseAuth.instance.currentUser != null) {
      getCurrentUser();
    } else {
      print("Chưa có user đăng nhập, không gọi getCurrentUser()");
    }
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
        await P.auth.getCurrentUser();
        Get.offAll(() => BottomNavBar()); // Điều hướng đến Home
      } else {
        Get.snackbar("Warning", "Login failed. Please try again.");
      }
    } catch (e) {
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
  Future<void> signOut() async {
    await _auth.signOut();
    Get.offAll(LogInPage());
  }
  Future<void> register(String email, String password, String username) async {
    if (email.trim().isEmpty ||
        password.trim().isEmpty ||
        username.trim().isEmpty) {
      Get.snackbar("Error", "All fields are required.");
      return;
    }

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
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
          "avaUrl": "",
        });

        Get.snackbar("Success", "Registration successful! Please log in.");
        Get.off(() => LogInPage());
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error Register", e.message ?? "Registration failed");
    } catch (e) {
      Get.snackbar("Fire store Error", "");
      // print("Failed to write user data: ${e.toString()}");
    }
  }
  Future<void> getCurrentUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection("User")
                .doc(user.uid)
                .get();
        if (userDoc.exists && userDoc.data() != null) {
          var data = userDoc.data() as Map<String, dynamic>;
          print("Dữ liệu user từ Firestore: $data");

          nameUser.value = data["username"] ?? "Không có tên";
          avaUrl.value = data["avaUrl"] ?? "";
          emailUser.value = user.email ?? "";
        } else {
          print("Không tìm thấy user trong Firestore");
          nameUser.value = "Không có tên";
          avaUrl.value = "";
          emailUser.value = "";
        }
      }
    } catch (e) {
      print("Lỗi khi lấy dữ liệu người dùng: $e");
    }
  }
  Future<void> uploadAvaUrlToFirebase(String ava) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection("User").doc(user.uid).update({"avaUrl": ava});
      avaUrl.value = ava;
    }
  }
  Future<void> reauthenticateAndChangePassword(String oldPassword, String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && user.email != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword,
        );

        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
        print("Mật khẩu đã được cập nhật sau khi xác thực lại!");
        Get.snackbar("Thành công", "Mật khẩu đã được cập nhật.");
        Get.to(LogInPage());
      }
    } catch (e) {
      print("Lỗi xác thực lại: $e");
      Get.snackbar("Lỗi", "Mật khẩu cũ không đúng hoặc có lỗi xảy ra.");
    }
  }
  Future<void> changeUserName (String newName) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        _firestore.collection("User").doc(user.uid).update({
          "username" : newName
        });
      } catch (e) {
        Get.dialog(AlertDialog(title: Text("Can not change user name")));
      }
    } else {

    }
  }
  // Future<void> changeEmail(String newEmail, String password) async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? user = auth.currentUser;
  //
  //   if (user != null) {
  //     try {
  //       AuthCredential credential = EmailAuthProvider.credential(
  //         email: user.email!,
  //         password: password,
  //       );
  //       await user.reauthenticateWithCredential(credential);
  //       await user.updateEmail(newEmail);
  //
  //       print("✅ Email đã được cập nhật!");
  //     } catch (e) {
  //       print("❌ Lỗi khi đổi email: $e");
  //     }
  //   }
  // }

}
