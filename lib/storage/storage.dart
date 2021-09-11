import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalStorage {
  // get path of external storage
  Future<String> _getPath() async {
    Directory? dir = await getExternalStorageDirectory();
    return '${dir!.path}';
  }

  // get file from given path
  Future<File> _getFile() async {
    String path = await _getPath();
    return File('$path/data.txt');
  }

  // get data from file
  Future<String> readData() async {
    File file = await _getFile();
    return file.readAsString();
  }

  // if file not precent it'll created and stroe the data otherwise update the file with given data
  writeData(String data) async {
    File file = await _getFile();
    file.writeAsString(data);
  }
}
