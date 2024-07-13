import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

class ImageControllerMulti extends GetxController {
  RxList<String> imagePathsmulti = <String>[].obs;

  Future<void> getImages() async {
    final ImagePicker _picker = ImagePicker();

    List<XFile>? images = await _picker.pickMultiImage(
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 80,
    );

    if (images != null && images.isNotEmpty) {
      if (imagePathsmulti.isNotEmpty) {
        imagePathsmulti.clear();
      }

      images.forEach((XFile image) {
        imagePathsmulti.add(image.path);
      });
    }
  }
}
