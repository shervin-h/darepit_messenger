part of 'wallpaper_selection_bloc.dart';

@immutable
abstract class WallpaperSelectionEvent {}

class WallpaperChangedEvent extends WallpaperSelectionEvent {
  final int selectedIndex;
  WallpaperChangedEvent(this.selectedIndex);
}

class PickWallpaperFromGalleryEvent extends WallpaperSelectionEvent {
  final int selectedIndex;
  final BuildContext context;
  PickWallpaperFromGalleryEvent(this.selectedIndex, this.context);
}
