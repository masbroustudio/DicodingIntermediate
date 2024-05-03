import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import 'package:flutter/material.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/data/model/story_response.dart';
import 'package:story_app/data/model/user.dart';

enum ApiState {
  initial,
  loading,
  loaded,
  error,
  noData,
}

class StoryProvider extends ChangeNotifier {
  final StoryApiService _apiService;

  StoryProvider(this._apiService);

  ApiState storyState = ApiState.initial;
  bool isUploading = false;
  String message = "";
  StoryResponse? uploadResponse;

  List<Story> _storyList = [];
  String _errorMessage = "";

  bool _isFetching = false;

  bool get isFetching => _isFetching;

  int pageItems = 1;
  int sizeItems = 10;
  bool hasMorePages = true;

  String get errorMessage => _errorMessage;
  List<Story> get storyList => _storyList;

  Future<bool> register(User user) async {
    try {
      final response = await _apiService.register(user);
      return response.error == false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      return response.error == false;
    } catch (e) {
      return false;
    }
  }

  Future<void> addNewStory(List<int> bytes, String fileName, String description,
      {double? lat, double? lon}) async {
    try {
      _startUploading();
      final response = await _apiService.addNewStory(
        bytes,
        description,
        fileName,
        lat: lat,
        lon: lon,
      );
      _handleUploadResponse(response);
    } catch (e) {
      _handleUploadError(e);
    }
  }

  Future<void> addNewStoryGuest(String description, File photo,
      {double? lat, double? lon}) async {
    try {
      _startUploading();

      final fileBytes = await photo.readAsBytes();
      final compressedImageBytes = await compressImage(fileBytes);

      final response = await _apiService.addNewStoryGuest(
        description,
        File.fromRawPath(Uint8List.fromList(compressedImageBytes)),
        lat: lat,
        lon: lon,
      );

      _handleUploadResponse(response);
    } catch (e) {
      _handleUploadError(e);
    }
  }

  Future<void> getAllStories({int? page, int? size, int? location}) async {
    try {
      if (page == null || page == 1) {
        resetPagination(); // Reset pagination if it's a new request
        _startLoading();
      }
      _resetError();

      final response = await _apiService.getAllStories(
        page: page ?? pageItems,
        size: sizeItems,
        location: location,
      );

      _handleStoryListResponse(response);

      if (response.listStory!.length < sizeItems) {
        hasMorePages = false;
      } else {
        pageItems += 1;
      }
    } catch (e) {
      _handleError(e);
    } finally {
      _stopLoading();
    }
  }

  Future<Story?> getDetailStory(String id) async {
    try {
      final response = await _apiService.getDetailStory(id);
      return response.story;
    } catch (e) {
      return null;
    }
  }

  Future<List<int>> compressImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;

    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = <int>[];

    do {
      compressQuality -= 10;

      newByte = img.encodeJpg(
        image,
        quality: compressQuality,
      );

      length = newByte.length;
    } while (length > 1000000);

    return newByte;
  }

  void _startUploading() {
    message = "";
    uploadResponse = null;
    isUploading = true;
    notifyListeners();
  }

  void _handleUploadResponse(StoryResponse response) {
    message = response.message ?? "Success";
    uploadResponse = response;
    isUploading = false;
    notifyListeners();
  }

  void _handleUploadError(dynamic e) {
    isUploading = false;
    message = e.toString();
    notifyListeners();
  }

  void _handleStoryListResponse(StoryResponse response) {
    if (pageItems == 1) {
      _storyList = response.listStory ?? [];
    } else {
      _storyList.addAll(response.listStory ?? []);
    }
    message = 'Success';
    notifyListeners();
  }

  void _startLoading() {
    _isFetching = true;

    storyState = ApiState.loading;
    notifyListeners();
  }

  void _stopLoading() {
    _isFetching = false;

    storyState = ApiState.loaded;
    notifyListeners();
  }

  void _handleError(dynamic e) {
    storyState = ApiState.error;
    _errorMessage = e.toString();
    notifyListeners();
  }

  void _resetError() {
    _errorMessage = "";
  }

  void resetPagination() {
    pageItems = 1;
    hasMorePages = true;
  }
}
