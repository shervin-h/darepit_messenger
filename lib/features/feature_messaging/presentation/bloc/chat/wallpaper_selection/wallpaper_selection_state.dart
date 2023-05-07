part of 'wallpaper_selection_bloc.dart';

@immutable
class WallpaperSelectionState {
  WallpaperSelectionIndexStatus indexStatus;
  WallpaperSelectionPickGalleryImageStatus pickGalleryImageStatus;
  WallpaperSelectionState({required this.indexStatus, required this.pickGalleryImageStatus});

  WallpaperSelectionState copyWith({
    WallpaperSelectionIndexStatus? newIndexStatus,
    WallpaperSelectionPickGalleryImageStatus? newPickGalleryImageStatus,
  }) {
    return WallpaperSelectionState(
      indexStatus: newIndexStatus ?? indexStatus,
      pickGalleryImageStatus: newPickGalleryImageStatus ?? pickGalleryImageStatus,
    );
  }
}

