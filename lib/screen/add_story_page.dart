import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/home_provider.dart';
import 'package:story_app/provider/story_provider.dart';

class AddStoryPage extends StatefulWidget {
  final LatLng inputLang;

  const AddStoryPage({super.key, this.inputLang = const LatLng(0.0, 0.0)});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Story'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePreview(),
              _buildImageButtons(),
              _buildDescriptionTextField(),
              _buildInputLocationButton(),
              _buildUploadButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    final imagePath = context.watch<HomeProvider>().imagePath;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: imagePath == null
          ? const Center(
              child: Icon(
                Icons.image,
                size: 80,
                color: Colors.grey,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: kIsWeb
                  ? Image.network(
                      imagePath.toString(),
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(imagePath.toString()),
                      fit: BoxFit.cover,
                    ),
            ),
    );
  }

  Widget _buildImageButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildElevatedButton("Gallery", _onGalleryView),
          const SizedBox(width: 16),
          _buildElevatedButton("Camera", _onCameraView),
        ],
      ),
    );
  }

  Widget _buildElevatedButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildDescriptionTextField() {
    return TextField(
      controller: descriptionController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: const InputDecoration(
        hintText: 'Enter your story description...',
        labelText: 'Description',
        border: OutlineInputBorder(),
        hintStyle: TextStyle(color: Colors.grey),
        contentPadding: EdgeInsets.all(16.0),
      ),
    );
  }

  Widget _buildInputLocationButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ElevatedButton(
        onPressed: () {
          context.goNamed('picker');
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          "Input Location ${(widget.inputLang != const LatLng(0.0, 0.0)) ? "\u2713" : ""}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton() {
    final isUploading = context.watch<StoryProvider>().isUploading;

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ElevatedButton(
        onPressed: isUploading ? null : _onUpload,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.greenAccent,
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: isUploading
            ? const SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                "Upload",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  _onUpload() async {
    final ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);

    final uploadProvider = context.read<StoryProvider>();

    final homeProvider = context.read<HomeProvider>();
    final imagePath = homeProvider.imagePath;
    final imageFile = homeProvider.imageFile;

    if (imagePath == null || imageFile == null) return;

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();
    final newBytes = await uploadProvider.compressImage(bytes);

    await uploadProvider.addNewStory(
      newBytes,
      fileName,
      descriptionController.text.isNotEmpty
          ? descriptionController.text
          : 'No Description',
      lat: widget.inputLang.latitude,
      lon: widget.inputLang.longitude,
    );

    if (uploadProvider.uploadResponse != null) {
      homeProvider.setImageFile(null);
      homeProvider.setImagePath(null);
      if (!context.mounted) return;
      // context.pop(true);
      Navigator.pop("true" as BuildContext);
    }

    scaffoldMessengerState.showSnackBar(
      SnackBar(content: Text(uploadProvider.message)),
    );
  }

  _onGalleryView() async {
    final provider = context.read<HomeProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<HomeProvider>();

    final ImagePicker picker = ImagePicker();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }
}
