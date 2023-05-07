import 'package:flusher/core/usecases/use_case.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../locator.dart';
import '../../data/sources/remote/api_provider.dart';


class IsOnlineUseCase extends NoParamUseCase<bool> {
  final apiProvider = getIt.get<ApiProvider>();
  @override
  Future<DataState<bool>> call() async {
    try {
      Response response = await apiProvider.isOnline();
      if (response.statusCode == 200) {
        return DataSuccess(true);
      } else {
        return DataFailed('لطفاً اتصال اینترنت را بررسی کنید !');
      }
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطا! لطفاً اتصال اینترنت را بررسی کنید !');
    }
  }
}