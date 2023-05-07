import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

/// Directories support by platform:
///
/// Temporary	                    => Android, iOS, Linux, macOS, Window
///
/// Application Support           => Android, iOS, Linux, macOS, Window
///
/// Application Library	          => iOS, macOS️
///
/// Application Documents	        => Android, iOS, Linux, macOS, Window
///
/// External Storage	            => Android
///
/// External Cache Directories	  => Android
///
/// External Storage Directories	=> Android
///
/// Downloads	                    => Linux, macOS, Window
enum FileDirectoryIosAndroid {
  documents,
  temporary,
  support,
}


/// Directories support by platform:
///
/// Temporary	                    => Android, iOS, Linux, macOS, Window
///
/// Application Support           => Android, iOS, Linux, macOS, Window
///
/// Application Library	          => iOS, macOS️
///
/// Application Documents	        => Android, iOS, Linux, macOS, Window
///
/// External Storage	            => Android
///
/// External Cache Directories	  => Android
///
/// External Storage Directories	=> Android
///
/// Downloads	                    => Linux, macOS, Window
enum FileDirectoryAndroid {
  documents,
  temporary,
  support,
  externalStorage,
  externalCacheDirectories,
  externalStorageDirectories,
}


/// Writes a string to a file.
///
/// Opens the file, writes the string in the given encoding, and closes the
/// file. Returns a `Future<File>` that completes with this [File] object
/// once the entire operation has completed.
///
/// By default `writeString` creates the file for writing and truncates the
/// file if it already exists. In order to append the bytes to an existing
/// file, pass [FileMode.append] as the optional mode parameter.
///
/// If the argument `flush` is set to `true`, the data written will be
/// flushed to the file system before the returned future completes.
///
/// Throws a [FileSystemException] if the operation fails.
Future<File> writeString(String contents, String fileNameWithExtension, FileDirectoryIosAndroid fileDirectory) async {
  Directory directory;
  switch (fileDirectory) {
    case FileDirectoryIosAndroid.documents:
      directory = await getApplicationDocumentsDirectory();
      break;
    case FileDirectoryIosAndroid.temporary:
      directory = await getTemporaryDirectory();
      break;
    case FileDirectoryIosAndroid.support:
      directory = await getApplicationSupportDirectory();
      break;
  }
  String filePath = join(directory.path, fileNameWithExtension);
  File file = File(filePath);
  return file.writeAsString(contents, mode: FileMode.write);
}


/// Reads the entire file contents as a string using the given
/// `Encoding`.
///
/// Returns a `Future<String>` that completes with the string once
/// the file contents has been read.
Future<String> readString(String fileNameWithExtension, FileDirectoryIosAndroid fileDirectory) async {
  Directory directory;
  switch (fileDirectory) {
    case FileDirectoryIosAndroid.documents:
      directory = await getApplicationDocumentsDirectory();
      break;
    case FileDirectoryIosAndroid.temporary:
      directory = await getTemporaryDirectory();
      break;
    case FileDirectoryIosAndroid.support:
      directory = await getApplicationSupportDirectory();
      break;
  }
  String filePath = join(directory.path, fileNameWithExtension);
  try {
    File file = File(filePath);
    return file.readAsString();
  } catch (e) {
    return '';
  }
}


/// Writes a list of bytes to a file.
///
/// Opens the file, writes the list of bytes to it, and closes the file.
/// Returns a `Future<File>` that completes with this [File] object once
/// the entire operation has completed.
///
/// By default `writeBytes` creates the file for writing and truncates the
/// file if it already exists. In order to append the bytes to an existing
/// file, pass [FileMode.append] as the optional mode parameter.
///
/// If the argument `flush` is set to `true`, the data written will be
/// flushed to the file system before the returned future completes.
Future<File?> writeBytes(ByteData byteData, String fileNameWithExtension, FileDirectoryIosAndroid fileDirectory) async{
  Directory directory;
  switch (fileDirectory) {
    case FileDirectoryIosAndroid.documents:
      directory = await getApplicationDocumentsDirectory();
      break;
    case FileDirectoryIosAndroid.temporary:
      directory = await getTemporaryDirectory();
      break;
    case FileDirectoryIosAndroid.support:
      directory = await getApplicationSupportDirectory();
      break;

    default:
      directory = await getApplicationDocumentsDirectory();
  }
  String filePath = join(directory.path, fileNameWithExtension);
  try {
    File file = File(filePath);
    List<int> bytesAsUint8list = byteData.buffer.asUint8List();
    return await file.writeAsBytes(bytesAsUint8list, mode: FileMode.write);
  } catch (e) {
    debugPrint(e.toString());
  }
  return null;
}

Future<File?> writeUint8ListBytes({
  required Uint8List bytes,
  required String fileNameWithExtension,
  required FileDirectoryIosAndroid fileDirectory,
}) async{
  Directory directory;
  switch (fileDirectory) {
    case FileDirectoryIosAndroid.documents:
      directory = await getApplicationDocumentsDirectory();
      break;
    case FileDirectoryIosAndroid.temporary:
      directory = await getTemporaryDirectory();
      break;
    case FileDirectoryIosAndroid.support:
      directory = await getApplicationSupportDirectory();
      break;

    default:
      directory = await getApplicationDocumentsDirectory();
  }
  String filePath = join(directory.path, fileNameWithExtension);
  try {
    File file = File(filePath);
    return await file.writeAsBytes(bytes, mode: FileMode.write);
  } catch (e) {
    debugPrint(e.toString());
  }
  return null;
}


/// Reads the entire file contents as a list of bytes => `List<int>` or `Uint8List`.
///
/// Returns a `Future<Uint8List>` that completes with the list of bytes that
/// is the contents of the file.
Future<Uint8List?> readBytes(String fileNameWithExtension, FileDirectoryIosAndroid fileDirectory) async {
  Directory directory;
  switch (fileDirectory) {
    case FileDirectoryIosAndroid.documents:
      directory = await getApplicationDocumentsDirectory();
      break;
    case FileDirectoryIosAndroid.temporary:
      directory = await getTemporaryDirectory();
      break;
    case FileDirectoryIosAndroid.support:
      directory = await getApplicationSupportDirectory();
      break;

    default:
      directory = await getApplicationDocumentsDirectory();
  }
  String filePath = join(directory.path, fileNameWithExtension);
  try {
    File file = File(filePath);
    return file.readAsBytes();
  } catch (e) {
    debugPrint(e.toString());
    return null;
  }
}