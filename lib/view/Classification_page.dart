import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduate/model/History_model.dart';
import 'package:graduate/widget/app_color.dart';
import 'package:graduate/P.dart';

class ClassificationPage extends StatelessWidget {
  ClassificationPage({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().green,
        title: Text(
          "Vegetable Classification",
          style: TextStyle(color: AppColor().white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Obx(() {
                  if (P.pickImage.pickedFile.value != null) {
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            P.pickImage.pickedFile.value!,
                            width: 224,
                            height: 224,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  } else {
                    return Center(
                      child: Container(
                        height: 224,
                        width: 224,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor().green,
                        ),
                      ),
                    );
                  }
                }),
              ),
              Expanded(
                flex: 1,
                child: Obx(
                  () => Center(
                    child: Text(
                      "Result: ${P.localML.result.value}",
                      style:  TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor().green
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColor().green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          P.localML.classifyImage(
                            P.pickImage.pickedFile.value!,
                          );
                          // print('Out put: ${P.localML.result.value}');
                          await P.pickImage.uploadToCloudinary();
                          History his = History(
                            _auth.currentUser!.uid,
                            kind: P.localML.result.value,
                            imageUrl: P.pickImage.imageUrl.value,
                          );
                          await P.localML.postHistory(his);
                        },
                        child: Center(
                          child: Text(
                            "Classify Image",
                            style: TextStyle(color: AppColor().white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColor().green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          P.pickImage.pickImage();
                        },
                        child: Center(
                          child: Text(
                            "Pick Image from Gallery",
                            style: TextStyle(color: AppColor().white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColor().green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          P.pickImage.captureImage();
                        },
                        child: Center(
                          child: Text(
                            "Capture Image from Camera",
                            style: TextStyle(color: AppColor().white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
