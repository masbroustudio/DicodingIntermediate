import 'dart:developer';

import 'package:flutter/material.dart';

import '../data/models/story.dart';
import '../data/network/response_call.dart';
import '../data/repositories/story_repository.dart';

class StoryProvider extends ChangeNotifier {
  final StoryRepository storyRepository;

  ResponseCall<List<Story>> responseCall =
      ResponseCall<List<Story>>.iddle("iddle");

  int page = 1;
  int size = 10;

  StoryProvider({required this.storyRepository});

  Future<void> getAllStories() async {
    responseCall = ResponseCall.loading("loading");
    notifyListeners();

    try {
      final result = await storyRepository.getAllStories();

      responseCall = ResponseCall.completed(result);
      notifyListeners();
    } catch (e) {
      log(e.toString(), name: "STORY PROVIDER");

      responseCall = ResponseCall.error(e.toString());
      notifyListeners();
    }
  }
}
