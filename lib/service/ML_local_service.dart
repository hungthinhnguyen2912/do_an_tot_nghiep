import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:graduate/model/History_model.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class MlLocalService extends GetxController {
  late Interpreter _interpreter;
  RxString result = "No classification yet".obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<History> his;
  List<String> labels = [
    'Bean',
    'Bitter_Gourd',
    'Bottle_Gourd',
    'Brinjal',
    'Broccoli',
    'Cabbage',
    'Capsicum',
    'Carrot',
    'Cauliflower',
    'Cucumber',
    'Papaya',
    'Potato',
    'Pumpkin',
    'Radish',
    'Tomato',
  ];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      print("🔄 Đang tải mô hình từ assets...");
      final options = InterpreterOptions();
      // Load model từ assets
      _interpreter = await Interpreter.fromAsset(
        'assets/tflite/MobileNet_ModelV2.tflite',
        options: options,
      );
      print("✅ Mô hình local đã tải thành công!");
    } catch (e) {
      print("❌ Lỗi tải mô hình local: $e");
    }
    print("📌 Input tensor shape: ${_interpreter.getInputTensor(0).shape}");
    print("📌 Output tensor shape: ${_interpreter.getOutputTensor(0).shape}");
  }

  Future<void> classifyImage(File imageFile) async {
    img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
    if (image == null) {
      result.value = "Error loading image";
      return;
    }

    image = img.copyResize(image, width: 224, height: 224);

    // Chuẩn bị input
    List input = List.generate(
      1,
          (i) => List.generate(
        224,
            (y) => List.generate(224, (x) => List.filled(3, 0.0)),
      ),
    );

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        var pixel = image.getPixelSafe(x, y);
        if (pixel is img.PixelUint8) {
          num red = pixel.r;
          num green = pixel.g;
          num blue = pixel.b;

          input[0][y][x][0] = red.toDouble() / 255;
          input[0][y][x][1] = green.toDouble() / 255;
          input[0][y][x][2] = blue.toDouble() / 255;
        }
      }
    }

    // Chuẩn bị output
    List output = List.generate(1, (i) => List.filled(15, 0.0));

    // Chạy mô hình
    _interpreter.run(input, output);

    // Lấy class có giá trị cao nhất
    List<double> probabilities = output[0].cast<double>();
    int labelIndex = probabilities.indexOf(
      probabilities.reduce((a, b) => a > b ? a : b),
    );
    result.value = "${labels[labelIndex]}";
  }
  Future<void> postHistory (History his) async {
    await _firestore.collection("History").add(his.toMap());
  }
  Stream<List<Map<String, dynamic>>> getUserHistory() {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    return _firestore
        .collection("History")
        .where("userId", isEqualTo: userId)
        .orderBy("timestamp", descending: true) // Sắp xếp giảm dần theo timestamp
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}