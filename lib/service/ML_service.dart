import 'package:get/get.dart';
import 'dart:io';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:graduate/model/History_model.dart';

class MlFirebaseService extends GetxController {
  late Interpreter _interpreter;
  RxString result = "No classification yet".obs;
  RxList historyList = [].obs;
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
    'Tomato'
  ];

  @override
  void onInit() {
    super.onInit();
    _loadModel();
  }

  Future<void> _loadModel() async {
    // Get.snackbar("Wait a minute", "We are downloading model");
    try {
      print("🔄 Đang tải model từ Firebase...");
      // Get.snackbar("Waiting to download model", "Please wait a minute");
      final model = await FirebaseModelDownloader.instance.getModel(
        "classification",
        FirebaseModelDownloadType.localModelUpdateInBackground,
      );
      _interpreter = await Interpreter.fromFile(File(model.file.path));
      print("✅ Model đã tải xong!");
      // Get.snackbar("Download completed","");
    } catch (e) {
      print("❌ Lỗi tải model: $e");
    }
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
            (i) =>
            List.generate(
                224, (y) => List.generate(224, (x) => List.filled(3, 0.0))));
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
        probabilities.reduce((a, b) => a > b ? a : b));
    result.value = "${labels[labelIndex]}";
  }
}