//For file related operations
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_media_feeds_template/utils/permission_helper.dart';

enum SaveFileOperationResponse {
  success,
  permissionError,
  error,
}

class FileOperations {
  //Takes care of creating a path for the file and downloading it there.
  static Future<SaveFileOperationResponse> saveFile(
      {required String url,
      required String filename,
      String? folderName,
      required void Function(int, int) downloadProgressCallback}) async {
    Directory? directory;
    print('start');
    try {
      if (Platform.isAndroid) {
        if (await PermissionHelper.requestPermission(Permission.storage)) {
          /*
          Path to a directory where the application may access top level storage.
           The current operating system should be determined before issuing this function
            call, as this functionality is only available on Android.
           */
          directory = await getExternalStorageDirectory();
          // /storage/emulated/0/Android/data/com.amaldev.file_downloader/files
          print(directory!.path);
          List<String> folders = directory.path.split('/');
          String newPath = '';
          for (int i = 1; i < folders.length; i++) {
            if (folders[i] == 'Android') {
              break;
            }
            newPath += '/${folders[i]}';
          }
          if (folderName != null) {
            newPath += '/SocialMediaFeedsTemplateApp/$folderName';
          } else {
            newPath += '/SocialMediaFeedsTemplateApp';
          }
          print("New path : $newPath"); //example L '/storage/emulated/0/SocialMediaFeedsTemplateApp'
          directory = Directory(newPath);
          print(directory.path);
        } else {
          return SaveFileOperationResponse.permissionError;
        }
      } else {
        directory = (await getApplicationDocumentsDirectory());
      }
      //If the directory doesn't exist then create it.
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        //this is complete path of the file that we want to create.
        File saveFile = File(directory.path + '/$filename');

        //Now we have to download the file and save it at this path.
        await Dio().download(url, saveFile.path, onReceiveProgress: downloadProgressCallback);

        print(saveFile.path);
        await OpenFile.open(saveFile.path);
        return SaveFileOperationResponse.success;
      }
    } catch (e) {
      print(e);
    }
    print('in the end');
    return SaveFileOperationResponse.error;
  }
}
