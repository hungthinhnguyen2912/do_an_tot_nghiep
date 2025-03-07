import 'dart:convert';

import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:graduate/model/History_model.dart';
import 'package:graduate/view/Vegetable_detail_page.dart';
import 'package:graduate/widget/app_color.dart';
import 'package:graduate/P.dart';

class ClassificationPage extends StatefulWidget {
  const ClassificationPage({super.key});

  @override
  State<ClassificationPage> createState() => _ClassificationPageState();
}

class _ClassificationPageState extends State<ClassificationPage> {
  List<dynamic> vegetables = [];
  bool isLoading = false; // Trạng thái hiển thị loading
  bool isImageSelected = false; // Trạng thái kiểm tra đã chọn ảnh chưa

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    String jsonString = await rootBundle.loadString('assets/vegetable.json');
    setState(() {
      vegetables = json.decode(jsonString);
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().green,
        title: Text(
          "Vegetable Classification",
          style: TextStyle(
            color: AppColor().white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Obx(() {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child:
                        P.pickImage.pickedFile.value != null
                            ? Image.file(
                              P.pickImage.pickedFile.value!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                            : Container(
                              height: 224,
                              width: 224,
                              color: AppColor().green.withOpacity(0.2),
                              child: Icon(
                                Icons.image,
                                size: 100,
                                color: AppColor().green,
                              ),
                            ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            Obx(
              () => Text(
                "Result: ${P.localML.result.value}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColor().green,
                ),
              ),
            ),
            const Spacer(),
            Column(
              children: [
                // Chỉ hiển thị nút "Classify Image" khi ảnh đã được chọn
                if (isImageSelected)
                  isLoading
                      ? CircularProgressIndicator(
                        color: AppColor().green,
                      ) // Hiển thị loading khi đang xử lý
                      : _buildButton(
                        "Classify Image",
                        Icons.analytics,
                        () async {
                          setState(() {
                            isLoading = true; // Hiển thị loading
                          });

                          await P.localML.classifyImage(
                            P.pickImage.pickedFile.value!,
                          );
                          await P.pickImage.uploadToCloudinary();

                          String classifiedName = P.localML.result.value;
                          var vegetable = vegetables.firstWhere(
                            (veg) => veg["name"] == classifiedName,
                            orElse: () => null,
                          );

                          if (vegetable != null) {
                            History his = History(
                              _auth.currentUser!.uid,
                              Timestamp.fromDate(DateTime.now()),
                              kind: classifiedName,
                              imageUrl: P.pickImage.imageUrl.value,
                            );

                            await P.localML.postHistory(his);
                          }

                          setState(() {
                            isLoading = false; // Ẩn loading
                          });

                          if (vegetable != null) {
                            Get.to(
                              VegetableDetailPage(
                                nameVegetable: vegetable["name"],
                                title: vegetable["title"],
                                detail: vegetable["detail"],
                              ),
                            );
                          }
                        },
                      ),
                _buildButton("Pick Image from Gallery", Icons.image, () async {
                  await P.pickImage.pickImage();
                  setState(() {
                    isImageSelected = P.pickImage.pickedFile.value != null;
                  });
                }),
                _buildButton(
                  "Capture Image from Camera",
                  Icons.camera_alt,
                  () async {
                    await P.pickImage.captureImage();
                    setState(() {
                      isImageSelected =
                          P.pickImage.pickedFile.value !=
                          null; // Kiểm tra đã chụp ảnh chưa
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String title, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor().green,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
      ),
    );
  }
}
