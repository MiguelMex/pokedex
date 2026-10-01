import 'dart:convert';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class StorageHelper {

  //Route to AppData
  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();
    return directory.path;
  }

  Future<String> readFile(String name) async {
    try{
      final file = await getFile(name);

      if(!await file.exists()) return '';
      final contents = await file.readAsString();
      return contents;
    } catch (_) {
      return '';
    }
  }

  Future<File> getFile(String name) async {
    final path = await _localPath;
    debugPrint('File to get: $path/$name');
    final file = File('$path/$name');
    if(await file.exists()){
      debugPrint('File $path/$name exists');
    } else {
      debugPrint('File $path/$name does not exists');
    }
    return file;
  }

  Future<File> storeFile(String fileName, dynamic fileContent) async {
    final file = await getFile(fileName);
    return file.writeAsString('$fileContent');
  }

  //JSON
  Future<Map<String, dynamic>> readJson(String name) async {
    try{
      final file = await getFile(name);
      if(!await file.exists()) return {};
      final contents = await  file.readAsString();
      return jsonDecode(contents) as Map<String, dynamic>;
    } catch (_){
      return {};
    }
  }

  Future<void> writeJson(String name, Map<String, dynamic> data) async {
    final file = await getFile(name);
    debugPrint('File stored is: $name');
    debugPrint('Data to store is: $data');
    await file.writeAsString(jsonEncode(data));
    debugPrint('File written successfully');
  }
}