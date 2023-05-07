import 'package:flusher/features/feature_messaging/data/repositories/room_repository_impl.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/chat_item_settings/chat_item_settings_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/pick_image/chat_pick_image_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/profile/edit_profile_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/rooms/drawer/rooms_drawer_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/rooms/rooms_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/rooms/search/search_rooms_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/rooms/visited_rooms/visited_rooms_bloc.dart';
import 'package:flusher/screens/splash/splash_bloc.dart';
import 'package:get_it/get_it.dart';

import 'features/feature_messaging/data/repositories/user_repository_impl.dart';
import 'features/feature_messaging/data/sources/remote/api_provider.dart';
import 'features/feature_messaging/domain/repositories/room_repository.dart';
import 'features/feature_messaging/domain/repositories/user_repository.dart';
import 'features/feature_messaging/presentation/bloc/chat/chat_bloc.dart';
import 'features/feature_messaging/presentation/bloc/chat/wallpaper_selection/wallpaper_selection_bloc.dart';
import 'features/feature_messaging/presentation/bloc/login/login_bloc.dart';
import 'features/feature_messaging/presentation/bloc/register/register_bloc.dart';

final getIt = GetIt.instance;

void setup() {
  /// remote api or local data source
  getIt.registerSingleton<ApiProvider>(ApiProvider());

  /// repositories
  getIt.registerSingleton<UserRepository>(UserRepositoryImpl());
  getIt.registerSingleton<RoomRepository>(RoomRepositoryImpl());

  /// bloc
  getIt.registerSingleton<SplashBloc>(SplashBloc());
  getIt.registerSingleton<RegisterBloc>(RegisterBloc());
  getIt.registerSingleton<LoginBloc>(LoginBloc());
  getIt.registerSingleton<ChatBloc>(ChatBloc());
  getIt.registerSingleton<RoomsBloc>(RoomsBloc());
  getIt.registerSingleton<RoomsDrawerBloc>(RoomsDrawerBloc());
  getIt.registerSingleton<WallpaperSelectionBloc>(WallpaperSelectionBloc());
  getIt.registerSingleton<ChatItemSettingsBloc>(ChatItemSettingsBloc());
  getIt.registerSingleton<SearchRoomsBloc>(SearchRoomsBloc());
  getIt.registerSingleton<VisitedRoomsBloc>(VisitedRoomsBloc());
  getIt.registerSingleton<EditProfileBloc>(EditProfileBloc());
  getIt.registerSingleton<ChatPickImageBloc>(ChatPickImageBloc());
}