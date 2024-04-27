import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UtilimageSelector {
  static showImagePicker(
      {required BuildContext context,
      required Function() onGallery,
      required Function onCamera}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                context.pop();
                onGallery();
              },
              title: const Text(
                'Buka dari Gallery',
              ),
              leading: const Icon(Icons.image),
            ),
            ListTile(
              onTap: () {
                context.pop();
                onCamera();
              },
              title: const Text(
                'Gunakan Kamera',
              ),
              leading: const Icon(Icons.camera_alt),
            ),
          ],
        );
      },
    );
  }
}
