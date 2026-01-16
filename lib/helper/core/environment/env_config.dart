import 'dart:io';

import '../../app_string.dart';
import '../../enum.dart';

class EnvironmentConfig {
  final String baseApiurl;
  final String title;
  final String appUpdateDate;
  final String releaseDate;
  final bool enableLogs; // Display logs in console
  final bool
      enableNetworkImages; // Disable or enable loading images from s3. disbale in dev stage for reduce the s3 hits.
  final String version;
  late PlatformType platformType;

  EnvironmentConfig({
    required this.baseApiurl,
    required this.title,
    required this.appUpdateDate,
    required this.releaseDate,
    required this.enableLogs,
    required this.enableNetworkImages,
    required this.version,
  }) {
    if (Platform.isAndroid) {
      platformType = PlatformType.android;
    } else if (Platform.isIOS) {
      platformType = PlatformType.ios;
    } else {
      throw Exception(platformNotSupportedMsg);
    }
  }
}
