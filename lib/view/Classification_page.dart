
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduate/model/History_model.dart';
import 'package:graduate/service/ML_local_service.dart';
import 'package:graduate/service/image_service.dart';
import 'package:graduate/widget/app_color.dart';
import '../service/ML_service.dart';

class ClassificationPage extends StatelessWidget {
  ClassificationPage({super.key});
  final ImageService imageService = Get.put(ImageService());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final MlFirebaseService tfliteService = Get.put(MlFirebaseService());
  final MlLocalService localTfliteService = Get.put(MlLocalService());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vegetable Classification"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Obx(() {
                if (imageService.pickedFile.value != null) {
                  return Column(
                    children: [
                      Image.file(
                        imageService.pickedFile.value!,
                        width: 224,
                        height: 224,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                } else {
                  return Center(child: Container(
                    height: 224,
                    width: 224,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor().green
                    ),
                  ));
                }
              }),
            ),
            ElevatedButton(
              onPressed: () async {
                localTfliteService.classifyImage(imageService.pickedFile.value!);
                print('Out put: ${localTfliteService.result.value}');
                await imageService.uploadToCloudinary();
                History his = History(_auth.currentUser!.uid, kind: localTfliteService.result.value, imageUrl: imageService.imageUrl.value);
                await localTfliteService.postHistory(his);
              },
              child: const Text("Classify Image"),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                imageService.pickImage();
              },
              child: const Text("Pick Image from Gallery"),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                imageService.captureImage();
              },
              child: const Text("Capture Image from Camera"),
            ),
            Expanded(
              flex: 1,
              child: Obx(() => Center(
                child: Text(
                  "Result: ${localTfliteService.result.value}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
