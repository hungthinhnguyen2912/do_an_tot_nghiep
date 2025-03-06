import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageService extends GetxController {
  late Rx<File?> pickedFile = Rx<File?>(null);
  final ImagePicker picker = ImagePicker();
  RxString imageUrl = "".obs;
  RxString avaUrl = "".obs;
  late Rx<File?> pickedAva = Rx<File?>(null);
  void pickImage() async {
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile == null) {
      Get.snackbar("", "Can not load image");
      return;
    }
    pickedFile.value = File(imageFile.path);
  }

  void captureImage() async {
    final imageFile = await picker.pickImage(source: ImageSource.camera);
    if (imageFile == null) {
      Get.snackbar("", "Can not load image");
      return;
    }
    pickedFile.value = File(imageFile.path);
  }
  void pickAva() async {
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile == null) {
      Get.snackbar("", "Can not load image");
      return;
    }
    pickedAva.value = File(imageFile.path);
  }

  void captureAva() async {
    final imageFile = await picker.pickImage(source: ImageSource.camera);
    if (imageFile == null) {
      Get.snackbar("", "Can not load image");
      return;
    }
    pickedAva.value = File(imageFile.path);
  }

  Future<void> uploadToCloudinary() async {
    if (pickedFile.value == null) {
      print("No image selected");
      Get.snackbar("Error", "No image selected");
      return;
    }

    try {
      print('Start upload image to Cloudinary...');
      String cloudName = "dcqn3q7tg";
      String uploadPreset = "Vegetable"; // Kiểm tra lại preset này!

      Uri url = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

      var request = http.MultipartRequest("POST", url);
      request.fields["upload_preset"] = uploadPreset;
      request.fields["folder"] = "Vegetables"; // Thêm thư mục để quản lý file tốt hơn
      request.files.add(await http.MultipartFile.fromPath("file", pickedFile.value!.path));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      print("Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        imageUrl.value = jsonResponse["secure_url"];
        print(imageUrl.value);
        Get.snackbar("Success", "Image uploaded successfully!");
      } else {
        Get.snackbar("Error", "Failed to upload image");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while uploading");
      print("Upload error: $e");
    }
  }

  Future<void> uploadAvaToCloudinary() async {
    if (pickedAva.value == null) {
      print("No image selected");
      Get.snackbar("Error", "No image selected");
      return;
    }

    try {
      print('Start upload image to Cloudinary...');
      String cloudName = "dcqn3q7tg";
      String uploadPreset = "Vegetable";

      Uri url = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

      var request = http.MultipartRequest("POST", url);
      request.fields["upload_preset"] = uploadPreset;
      request.fields["folder"] = "Vegetables";
      request.files.add(await http.MultipartFile.fromPath("file", pickedAva.value!.path));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      if (response.statusCode == 200) {
        avaUrl.value = jsonResponse["secure_url"];
        print("Uploaded Avatar URL: ${avaUrl.value}");
        Get.snackbar("Success", "Image uploaded successfully!");
      } else {
        Get.snackbar("Error", "Failed to upload image");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while uploading");
      print("Upload error: $e");
    }
  }


}