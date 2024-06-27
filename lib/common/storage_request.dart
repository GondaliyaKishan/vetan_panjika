import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PermissionRequests {

  Future<String> storagePermission() async {
    // below android13 devices
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo version = await deviceInfo.androidInfo;
    if (Platform.isAndroid) {
      final status = await (version.version.sdkInt! >= 33 ? Permission.photos
          .request() : Permission.storage.request());
      if (status.isGranted) {
        return "Granted";
      } else if (status.isPermanentlyDenied || status.isRestricted) {
        await openAppSettings();
        return "DeniedAll";
      } else {
        return "notDenied";
      }
    } else {
      return "iOS";
    }
  }
}