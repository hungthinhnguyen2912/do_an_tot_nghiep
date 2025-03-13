import 'package:get/get.dart';
import 'package:graduate/service/Auth_service.dart';
import 'package:graduate/service/Image_service.dart';
import 'package:graduate/service/ML_local_service.dart';

class P {
  static void initial () {
    Get.put(AuthService());
    Get.put(ImageService());
    Get.put(MlLocalService());
    // Get.put(MlFirebaseService());
  }

  static AuthService get auth => Get.find();
  static ImageService get pickImage => Get.find();
  // static MlFirebaseService get fireBaseML => Get.find();
  static MlLocalService get localML => Get.find();
}