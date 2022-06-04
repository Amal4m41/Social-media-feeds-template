import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'package:social_media_feeds_template/utils/permission_helper.dart';

void showCustomSnackBar({required BuildContext context, required String message, Color bgColor = Colors.black}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 1),
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: bgColor,
    ),
  );
}

//For fetching different types of images from different sources.
enum getImageFrom {
  network,
  asset,
  uInt8ListData,
  defaultData,
}

const String defaultUserProfileImage =
    'https://www.kindpng.com/picc/m/24-248253_user-profile-default-image-png-clipart-png-download.png';

ImageProvider getImage({
  required getImageFrom source,
  required dynamic data,
}) {
  final ImageProvider image;
  switch (source) {
    case getImageFrom.network:
      image = NetworkImage(data);
      break;
    case getImageFrom.asset:
      image = AssetImage(data);
      break;
    case getImageFrom.uInt8ListData:
      image = MemoryImage(data);
      break;
    default:
      image = const NetworkImage(defaultUserProfileImage);
  }

  return image;
}
