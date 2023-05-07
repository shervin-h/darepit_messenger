import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import 'package:image_picker/image_picker.dart';

Future<String?> pickImage({
  ImageSource source = ImageSource.camera,
  CameraDevice preferredCameraDevice = CameraDevice.rear,
  int? quality,
  double? maxWidth,
  double? maxHeight,
}) async {
  String? encodedImage;
  XFile? xFile = await ImagePicker().pickImage(
    source: source,
    preferredCameraDevice: preferredCameraDevice,
    imageQuality: quality ?? 70,
    maxWidth: maxWidth ?? 900,
    maxHeight: maxHeight ?? 900,
  );

  if (xFile != null) {
    img.Image? capturedImage = img.decodeImage(await xFile.readAsBytes());
    if (capturedImage != null) {
      File file;
      if (capturedImage.height < capturedImage.width) {
        img.Image orientedImage = img.copyRotate(capturedImage, angle: 90);
        file = await File(xFile.path).writeAsBytes(
          img.encodeJpg(orientedImage),
          mode: FileMode.write,
        );
      } else {
        file = await File(xFile.path).writeAsBytes(img.encodeJpg(capturedImage));
      }

      Uint8List bytes = await file.readAsBytes();
      encodedImage = base64Encode(bytes);
    }
  }

  return encodedImage;
}

Future<File?> pickImageAsFile({
  ImageSource source = ImageSource.camera,
  CameraDevice preferredCameraDevice = CameraDevice.rear,
  int? quality,
  double? maxWidth,
  double? maxHeight,
}) async {
  XFile? xFile = await ImagePicker().pickImage(
    source: source,
    preferredCameraDevice: preferredCameraDevice,
    imageQuality: quality ?? 70,
    maxWidth: maxWidth ?? 900,
    maxHeight: maxHeight ?? 900,
  );

  if (xFile != null) {
    img.Image? capturedImage = img.decodeImage(await xFile.readAsBytes());
    if (capturedImage != null) {
      File file;
      if (capturedImage.height < capturedImage.width) {
        img.Image orientedImage = img.copyRotate(capturedImage, angle: 90);
        file = await File(xFile.path).writeAsBytes(
          img.encodeJpg(orientedImage),
          mode: FileMode.write,
        );
      } else {
        file = await File(xFile.path).writeAsBytes(img.encodeJpg(capturedImage));
      }

      return file;
    }
  }

  return null;
}

Future<List<String>> pickMultiImage() async {
  List<String> encodedImages = [];

  List<XFile> xFiles = await ImagePicker().pickMultiImage();

  if (xFiles.isNotEmpty) {
    for (XFile xFile in xFiles) {
      encodedImages.add(base64Encode(await xFile.readAsBytes()));
    }
  }
  return encodedImages;
}

Color convertNameToColor(String name) {
  switch (name) {
    case 'white':
      return Colors.white;
    case 'blue':
      return Colors.blue;
    case 'light_blue':
      return Colors.lightBlue;
    case 'red':
      return Colors.red;
    case 'orange':
      return Colors.orange;
    case 'deep_orange':
      return Colors.deepOrange;
    case 'deep_orange_accent':
      return Colors.deepOrangeAccent;
    case 'yellow':
      return Colors.yellow;
    case 'grey':
      return Colors.grey;
    case 'purple':
      return Colors.purple;
    case 'deep_purple':
      return Colors.deepPurple;
    case 'purple_accent':
      return Colors.purpleAccent;
    case 'pink':
      return Colors.pink;
    case 'green':
      return Colors.green;

    default:
      return Colors.white;
  }
}

/// This method will generate unique Id similar to (-N4pvg_50j1CEqSb3SZt)
String getCustomUniqueId() {
  const String pushChars = '-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz';
  int lastPushTime = 0;
  List lastRandChars = [];
  int now = DateTime.now().millisecondsSinceEpoch;
  bool duplicateTime = (now == lastPushTime);
  lastPushTime = now;
  List timeStampChars = List<String>.filled(8, '0');
  for (int i = 7; i >= 0; i--) {
    timeStampChars[i] = pushChars[now % 64];
    now = (now / 64).floor();
  }
  if (now != 0) {
    debugPrint("Id should be unique");
  }
  String uniqueId = timeStampChars.join('');
  if (!duplicateTime) {
    for (int i = 0; i < 12; i++) {
      lastRandChars.add((Random().nextDouble() * 64).floor());
    }
  } else {
    int i = 0;
    for (int i = 11; i >= 0 && lastRandChars[i] == 63; i--) {
      lastRandChars[i] = 0;
    }
    lastRandChars[i]++;
  }
  for (int i = 0; i < 12; i++) {
    uniqueId += pushChars[lastRandChars[i]];
  }
  return uniqueId;
}



/// Use for generate UUID
class RanKeyAssets {
  var smallAlphabets = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z'
  ];
  var digits = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];
}

/// Scenario to generate a unique cryptographically secure random id. with 4 random generations id's
/// 1. First 4 Alphabets from an alphabets list [a-z].
/// 2. Middle 4 digits from a digits list [0-9].
/// 3. DateTime 4 microseconds since epoch substring 8 - 12 because they change frequently.
/// 4. Last 4 Alphabets from an alphabets list [a-z].
randomIdGenerator() {
  var ranAssets = RanKeyAssets();
  String first4alphabets = '';
  String middle4Digits = '';
  String last4alphabets = '';
  for (int i = 0; i < 4; i++) {
    first4alphabets += ranAssets.smallAlphabets[
    Random.secure().nextInt(ranAssets.smallAlphabets.length)];

    middle4Digits +=
    ranAssets.digits[Random.secure().nextInt(ranAssets.digits.length)];

    last4alphabets += ranAssets.smallAlphabets[
    Random.secure().nextInt(ranAssets.smallAlphabets.length)];
  }

  return '$first4alphabets-$middle4Digits-${DateTime.now().microsecondsSinceEpoch.toString().substring(8, 12)}-$last4alphabets';
}

