import 'dart:io';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/helper.dart';

class PickChatImageUseCase extends NoParamUseCase<File> {
  @override
  Future<DataState<File>> call() async {
    try {
      File? file = await pickImageAsFile(maxWidth: 350, maxHeight: 350, quality: 50, source: ImageSource.gallery);
      if (file != null) {
        return DataSuccess(file);
      }
      return DataFailed('خطا هنگام برداشتن تصویر!');
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطا هنگام برداشتن تصویر!');
    }
  }

}