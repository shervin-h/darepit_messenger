import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/features/feature_messaging/data/sources/local/app_room_provider.dart';
import 'package:flusher/features/feature_messaging/domain/entities/room_entity.dart';
import 'package:flusher/features/feature_messaging/domain/repositories/room_repository.dart';
import 'package:flusher/locator.dart';
import 'package:flutter/cupertino.dart';

class InsertVisitedRoomToLocalDbUseCase extends OneParamUseCase<bool, RoomEntity> {

  final roomRepository = getIt<RoomRepository>();

  @override
  Future<DataState<bool>> call(RoomEntity param) async {
    try {
      final resultDb = await roomRepository.insertVisitedRoom(roomEntity: param);
      if (resultDb) {
        return DataSuccess(true);
      } else {
        return DataFailed('خطا هنگام ذخیره اتاق بازدید شده!');
      }
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطا!');
    }
  }

}