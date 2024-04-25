import 'dart:io';

import 'package:flutstory/data/providers/addstory_provider.dart';
import 'package:flutstory/data/providers/allstory_provider.dart';
import 'package:flutstory/utils/utilimage_selector.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../data/network/response_call.dart';

class AddstoryPage extends StatefulWidget {
  static const path = 'add';

  const AddstoryPage({super.key});

  @override
  State<AddstoryPage> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddstoryPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController inputDescription = TextEditingController();

  _onGallery() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image == null) return;

    final directory = await getApplicationSupportDirectory();
    final name = path.basename(image.path);
    final imageFile = File('${directory.path}/$name');
    final savedFile = await File(image.path).copy(imageFile.path);

    if (mounted) {
      context.read<AddstoryProvider>().setImage(savedFile);
    }
  }

  _onCamera() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    if (image == null) return;

    final directory = await getApplicationSupportDirectory();
    final name = path.basename(image.path);
    final imageFile = File('${directory.path}/$name');
    final savedFile = await File(image.path).copy(imageFile.path);

    if (mounted) {
      context.read<AddstoryProvider>().setImage(savedFile);
    }
  }

  void _handleSelectPick() {
    UtilimageSelector.showImagePicker(
        context: context, onGallery: _onGallery, onCamera: _onCamera);
  }

  void _handleAddStory() async {
    final addProvider = context.read<AddstoryProvider>();

    if (addProvider.selectedImage == null) {
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.textPleaseSelectImage);
      return;
    }

    if (!formKey.currentState!.validate()) return;

    final isAdded = await addProvider.addStory(inputDescription.text.trim());

    if (!isAdded) {
      Fluttertoast.showToast(msg: addProvider.responseCall.message.toString());
      return;
    }

    if (mounted) {
      context.read<AllstoryProvider>().getAllStories();
      addProvider.resetInput();
      context.pop();
    }
  }

  @override
  void dispose() {
    inputDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.textStoryAddNew),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            InkWell(
              onTap: _handleSelectPick,
              borderRadius: BorderRadius.circular(7),
              child: Ink(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Consumer<AddstoryProvider>(
                    builder: (context, state, child) {
                  if (state.selectedImage != null) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            state.selectedImage!,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Center(
                          child: Icon(
                            Icons.add_photo_alternate,
                            size: 60,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  }

                  return const Center(
                    child: Icon(
                      Icons.add_photo_alternate,
                      size: 60,
                      color: Colors.grey,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 8,
              minLines: 3,
              controller: inputDescription,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.textDescription,
                labelText: AppLocalizations.of(context)!.textDescription,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.textRequired;
                }

                return null;
              },
            ),
            const SizedBox(height: 8),
            Consumer<AddstoryProvider>(
              builder: (context, value, child) {
                return ElevatedButton(
                  onPressed: value.responseCall.status == Status.loading
                      ? () {}
                      : _handleAddStory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: value.responseCall.status == Status.loading
                        ? Colors.grey
                        : Colors.blue,
                  ),
                  child: Text(AppLocalizations.of(context)!.textStoryAddNew),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
