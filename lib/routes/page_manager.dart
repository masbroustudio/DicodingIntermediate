import 'dart:async';

import 'package:flutter/material.dart';

class PageManager extends ChangeNotifier {
  // Tambahkan variabel Completer bernama _completer untuk menangani proses pengembalian data di waktu tertentu.
  late Completer<String> _completer;

  // buat fungsi baru untuk menunggu data berhasil didapatkan.
  Future<String> waitForResult() async {
    _completer = Completer<String>();
    return _completer.future;
  }

  void returnData(String value) {
    _completer.complete(value);
  }
}
