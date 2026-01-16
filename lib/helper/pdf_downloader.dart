import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

import 'app_message.dart';

class PDFDownloader {
  static Future<String?> downloadPDF(String url, String fileName) async {
    try {
      Dio dio = Dio();
      String savePath;

      if (Platform.isAndroid) {
        // Request storage permission for Android
        if (await _requestStoragePermission()) {
          String downloadsPath = '/storage/emulated/0/Download';
          savePath = '$downloadsPath/$fileName';
        } else {
          appLog("Storage permission denied.");
          return null;
        }
      } else if (Platform.isIOS) {
        // Use application directory for iOS (user selects where to save)
        Directory dir = await getApplicationDocumentsDirectory();
        savePath = '${dir.path}/$fileName';
      } else {
        appLog("Unsupported platform");
        return null;
      }

      // Download the file
      await dio.download(url, savePath);
      appLog("File downloaded to: $savePath");

      // For iOS, open save dialog
      if (Platform.isIOS) {
        final params = SaveFileDialogParams(sourceFilePath: savePath);
        await FlutterFileDialog.saveFile(params: params);
      } else {
        appLog("File saved successfully at: $savePath");
      }

      return savePath;
    } catch (e) {
      appLog("Error downloading PDF: $e");
      return null;
    }
  }

  // Request storage permissions for Android
  static Future<bool> _requestStoragePermission() async {
    var status = await Permission.manageExternalStorage.request();
    return status.isGranted;
  }
}
