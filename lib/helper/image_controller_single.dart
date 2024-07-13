
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:image_picker/image_picker.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageController extends GetxController {
  RxString imagePath = ''.obs;
  RxString imageUrl = ''.obs;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      imagePath.value = image.path;
      imageUrl.value = '';
    }
  }

  void setImageUrl(String url) {
    imageUrl.value = url;
    imagePath.value = '';
  }
}
