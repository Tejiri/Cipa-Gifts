import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

final picker = ImagePicker();

Future<File> getImage() async {
  final pickedFile = await picker.getImage(source: ImageSource.camera);
  if (pickedFile != null) {
    return File(pickedFile.path);
  } else {
    return null;
  }
}

Future<File> compressImage(File file) async {
  // Get file path
  // eg:- "Volume/VM/abcd.jpeg"
  final filePath = file.absolute.path;

  // Create output file path
  // eg:- "Volume/VM/abcd_out.jpeg"
  final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
  final splitted = filePath.substring(0, (lastIndex));
  final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

  final compressedImage = await FlutterImageCompress.compressAndGetFile(
      filePath, outPath,
      minWidth: 1000, minHeight: 1000, quality: 70);
  return compressedImage;
}
