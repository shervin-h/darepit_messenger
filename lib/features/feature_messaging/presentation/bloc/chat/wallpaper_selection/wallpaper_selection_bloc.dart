import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flusher/core/utils/constants.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/wallpaper_asset_change_use_case.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/chat_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/wallpaper_selection/wallpaper_selection_index_status.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/wallpaper_selection/wallpaper_selection_pick_gallery_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../../core/resources/data_state.dart';
import '../../../../../../core/widgets/custom_widgets.dart';
import '../../../../domain/usecases/wallpaper_changed_use_case.dart';

part 'wallpaper_selection_event.dart';
part 'wallpaper_selection_state.dart';

class WallpaperSelectionBloc extends Bloc<WallpaperSelectionEvent, WallpaperSelectionState> {
  WallpaperSelectionBloc() : super(
    WallpaperSelectionState(
      indexStatus: WallpaperSelectionIndexInitialStatus(),
      pickGalleryImageStatus: WallpaperSelectionPickGalleryImageInitialStatus(),
    ),
  ) {
    on<WallpaperSelectionEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<WallpaperChangedEvent>((event, emit) async {
      /// first clear or set to initial state
      emit(state.copyWith(
          newIndexStatus: WallpaperSelectionIndexInitialStatus(),
          newPickGalleryImageStatus: WallpaperSelectionPickGalleryImageInitialStatus()));

      emit(state.copyWith(newIndexStatus: WallpaperSelectionIndexCompletedStatus(event.selectedIndex)));

      await WallpaperAssetChangedUseCase()(AppConstant.wallpaperNames[event.selectedIndex]).then((DataState<String> dataState) {
        if (dataState is DataSuccess) {
          debugPrint(dataState.data);
          // emit(state.copyWith(newIndexStatus: WallpaperSelectionIndexCompletedStatus(event.selectedIndex)));
        } else if (dataState is DataFailed) {
          debugPrint(dataState.error);
        } else {
          debugPrint('نام کاغذ دیواری ذخیره نشد! خطای غیر منتظره!');
        }
      });

    });

    on<PickWallpaperFromGalleryEvent>((event, emit) async {
      /// first clear or set to initial state
      emit(state.copyWith(
          newIndexStatus: WallpaperSelectionIndexInitialStatus(),
          newPickGalleryImageStatus: WallpaperSelectionPickGalleryImageInitialStatus()));

      emit(state.copyWith(newPickGalleryImageStatus: WallpaperSelectionPickGalleryImageLoadingStatus()));
      await WallpaperChangedUseCase()().then((DataState<String> dataState) {
        if (dataState is DataSuccess && dataState.data != null) {
          emit(state.copyWith(newPickGalleryImageStatus: WallpaperSelectionPickGalleryImageCompletedStatus(dataState.data!, event.selectedIndex)));
          BlocProvider.of<ChatBloc>(event.context).add(LoadChatWallpaperEvent());
          showCustomSuccessSnackBar(event.context, 'کاغذدیواری انتخاب شد');
        } else if (dataState is DataFailed && dataState.error != null) {
          emit(state.copyWith(newPickGalleryImageStatus: WallpaperSelectionPickGalleryImageErrorStatus(dataState.error!)));
        } else {
          emit(state.copyWith(newPickGalleryImageStatus: WallpaperSelectionPickGalleryImageInitialStatus()));
        }
      });
    });
  }
}
