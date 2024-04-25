import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

import '../data/network/response_call.dart';
import '../data/repositories/story_repository.dart';

class AddProvider extends ChangeNotifier {
  final StoryRepository storyRepository;

  ResponseCall responseCall = ResponseCall.iddle("iddle");

  File? selectedImage;

  AddProvider({required this.storyRepository});

  resetInput() {
    responseCall = ResponseCall.iddle("iddle");
    selectedImage = null;
    notifyListeners();
  }

  setImage(File file) {
    selectedImage = file;
    notifyListeners();
  }

  Future<List<int>> compressImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;
    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];
    do {
      ///
      compressQuality -= 10;
      newByte = img.encodeJpg(
        image,
        quality: compressQuality,
      );
      length = newByte.length;
    } while (length > 1000000);
    return newByte;
  }

  Future<bool> addStory(String description) async {
    responseCall = ResponseCall.loading("loading");
    notifyListeners();

    if (selectedImage == null) {
      responseCall = ResponseCall.error("Error: no image provided");
      notifyListeners();
      return false;
    }

    try {
      Uint8List bytes = await selectedImage!.readAsBytes();
      List<int> compressedBytes = await compressImage(bytes);
      Uint8List finalBytes = Uint8List.fromList(compressedBytes);

      final compressedFile = await selectedImage!.writeAsBytes(finalBytes);

      final response = await storyRepository.addStory(
        description: description,
        image: compressedFile,
      );

      responseCall = ResponseCall.completed("completed");
      notifyListeners();

      return response;
    } catch (e) {
      responseCall = ResponseCall.error(e.toString());
      notifyListeners();
      return false;
    }
  }
}
