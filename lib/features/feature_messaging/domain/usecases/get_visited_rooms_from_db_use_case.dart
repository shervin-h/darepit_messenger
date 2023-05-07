import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/features/feature_messaging/domain/repositories/room_repository.dart';
import 'package:flusher/locator.dart';
import 'package:flutter/cupertino.dart';

import '../entities/room_entity.dart';

class GetVisitedRoomsFromDbUseCase extends NoParamUseCase<List<RoomEntity>> {

  final roomRepository = getIt<RoomRepository>();

  @override
  Future<DataState<List<RoomEntity>>> call() async {
    try {
      final roomEntities = await roomRepository.fetchAllVisitedRooms();
      return DataSuccess(roomEntities);
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطا!');
    }
  }

}