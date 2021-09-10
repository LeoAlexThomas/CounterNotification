import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalStorage {
  Future<String> _getPath() async {
    Directory? dir = await getExternalStorageDirectory();
    return '${dir!.path}';
  }

  Future<File> _getFile() async {
    String path = await _getPath();
    return File('$path/data.txt');
  }

  Future<String> readData() async {
    File file = await _getFile();
    return file.readAsString();
  }

  writeData(String data) async {
    File file = await _getFile();
    file.writeAsString(data);
  }
}
