import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeProvider extends ChangeNotifier {
  XFile? imageFile;
  String? imagePath;

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }
}
