import 'package:flusher/config/app_settings.dart';
import 'package:flusher/core/widgets/custom_widgets.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/wallpaper_changed_use_case.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/wallpaper_selection/wallpaper_selection_index_status.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/wallpaper_selection/wallpaper_selection_pick_gallery_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flusher/core/utils/constants.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/chat_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/wallpaper_selection/wallpaper_selection_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/widgets/wallpaper_grid_item_widget.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/resources/data_state.dart';


class WallpaperSelectionScreen extends StatelessWidget {
   WallpaperSelectionScreen({Key? key}) : super(key: key);
  
  static const String routeName = '/wallpaper-selection-screen';

  final supabaseClient = Supabase.instance.client;

  bool _isSelected(int index) {
    try {
      if (AppConstant.wallpaperNames[index] == AppSettings.assetWallpaperName) {
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('انتخاب کاغذدیواری'),
        centerTitle: true,
        backgroundColor: context.theme.colorScheme.background,
        foregroundColor: context.theme.colorScheme.onBackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(CupertinoIcons.back),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<WallpaperSelectionBloc, WallpaperSelectionState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.pickGalleryImageStatus is WallpaperSelectionPickGalleryImageCompletedStatus) {
              final encodedWallpaper = (state.pickGalleryImageStatus as WallpaperSelectionPickGalleryImageCompletedStatus).encodedWallpaper;
              final selectedIndex = (state.pickGalleryImageStatus as WallpaperSelectionPickGalleryImageCompletedStatus).selectedIndex;
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                itemCount: AppConstant.wallpaperNames.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 2/3,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (index == AppConstant.wallpaperNames.length)
                        ? () async {
                            BlocProvider.of<WallpaperSelectionBloc>(context).add(PickWallpaperFromGalleryEvent(index, context));
                          }
                        : () {
                            BlocProvider.of<WallpaperSelectionBloc>(context).add(WallpaperChangedEvent(index));
                            BlocProvider.of<ChatBloc>(context).add(LoadChatWallpaperEvent(AppConstant.wallpaperNames[index]));
                            showCustomSuccessSnackBar(context, 'کاغذدیواری انتخاب شد');
                          },
                    child: WallpaperGridItemWidget(
                      index: index,
                      wallpaper: (index == AppConstant.wallpaperNames.length) ? encodedWallpaper : null,
                      isSelected: index == selectedIndex,
                    ),
                  );
                },
              );
            }

            if (state.indexStatus is WallpaperSelectionIndexCompletedStatus) {
              final selectedIndex = (state.indexStatus as WallpaperSelectionIndexCompletedStatus).selectedIndex;
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                itemCount: AppConstant.wallpaperNames.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 2/3,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (index == AppConstant.wallpaperNames.length)
                        ? () async {
                              BlocProvider.of<WallpaperSelectionBloc>(context).add(PickWallpaperFromGalleryEvent(index, context));
                            }
                        : () {
                            BlocProvider.of<WallpaperSelectionBloc>(context).add(WallpaperChangedEvent(index));
                            BlocProvider.of<ChatBloc>(context).add(LoadChatWallpaperEvent(AppConstant.wallpaperNames[index]));
                            showCustomSuccessSnackBar(context, 'کاغذدیواری انتخاب شد');
                          },
                    child: WallpaperGridItemWidget(
                      index: index,
                      wallpaper: null,
                      isSelected: index == selectedIndex,
                    ),
                  );
                },
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: AppConstant.wallpaperNames.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2/3,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (index == AppConstant.wallpaperNames.length)
                      ? () async {
                            BlocProvider.of<WallpaperSelectionBloc>(context).add(PickWallpaperFromGalleryEvent(index, context));
                            // await WallpaperChangedUseCase()().then((DataState<String> dataState) {
                            //   if (dataState is DataSuccess && dataState.data != null) {
                            //     BlocProvider.of<ChatBloc>(context).add(LoadChatWallpaperEvent());
                            //     showCustomSuccessSnackBar(context, 'کاغذدیواری انتخاب شد');
                            //   } if (dataState is DataFailed && dataState.error != null) {
                            //     showCustomErrorSnackBar(context, dataState.error!);
                            //   }
                            // });
                          }
                      : () {
                          BlocProvider.of<WallpaperSelectionBloc>(context).add(WallpaperChangedEvent(index));
                          BlocProvider.of<ChatBloc>(context).add(LoadChatWallpaperEvent(AppConstant.wallpaperNames[index]));
                          showCustomSuccessSnackBar(context, 'کاغذدیواری انتخاب شد');
                        },
                  child: WallpaperGridItemWidget(
                    index: index,
                    wallpaper: null,
                    isSelected: false,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
