import 'package:flusher/config/app_settings.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/features/feature_messaging/domain/entities/room_entity.dart';
import 'package:flusher/features/feature_messaging/domain/entities/user_entity.dart';
import 'package:flusher/features/feature_messaging/domain/repositories/room_repository.dart';
import 'package:flusher/features/feature_messaging/domain/repositories/user_repository.dart';
import 'package:flusher/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EnterTheSelectedRoomUseCase extends TwoParamsUseCase<UserEntity, RoomEntity, String> {

  final userRepository = getIt<UserRepository>();
  final roomRepository = getIt<RoomRepository>();
  final supabaseClient = Supabase.instance.client;

  @override
  Future<DataState<UserEntity>> call(RoomEntity param1, String param2) async {
    // param1: RoomEntity, param2: email
    try {
      UserEntity? userEntity = await userRepository.fetchUserData(email: param2);
      if (userEntity != null) {
        userEntity.room = param1.name;
        AppSettings.room = param1.name;
        await userRepository.updateUserData(userData: {'room': param1.name});

        int userId = AppSettings.userId;
        if (userId == -1 || userId == 0) {
          final supabaseClient = Supabase.instance.client;
          final User? currentUser = supabaseClient.auth.currentUser;
          if (currentUser != null && currentUser.email != null && currentUser.email!.isNotEmpty) {
            final List userData = await supabaseClient.from('users').select('id').eq('email', currentUser.email!);
            userId = userData.first['id'];
            AppSettings.userId = userId;
          }
        }

        if (param1.userId != userId) {
          RoomEntity? cachedRoom = await roomRepository.fetchVisitedRoom(roomId: param1.roomId);
          if (cachedRoom != null) {
            await roomRepository.updateVisitedRoom(roomEntity: param1);
          } else {
            await roomRepository.insertVisitedRoom(roomEntity: param1);
          }
        }


        /// Under Constructing
        // supabaseClient.from('user_room').select('*').eq('room_id', value).then((value) {
        //
        // });
        // supabaseClient.from('user_room')
        //     .insert({'user_id': AppSettings.userId, 'room_id': param1.roomId});

        /// End of Under Constructing

        return DataSuccess(userEntity);
      }
      return DataFailed('کاربری وجود ندارد!');
    } on AuthException catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.message);
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطا هنگام واکشی اطلاعات کاربر!');
    }
  }
}