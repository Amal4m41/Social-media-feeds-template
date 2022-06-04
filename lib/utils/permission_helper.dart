import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  //Handles the permission dialog.
  static Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      PermissionStatus result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else if (result == PermissionStatus.permanentlyDenied) {
        return false; //or could navigate to the settings of this app
      } else {
        return false;
      }
    }
  }
}
