abstract class WallpaperSelectionIndexStatus {}

class WallpaperSelectionIndexInitialStatus extends WallpaperSelectionIndexStatus {}

class WallpaperSelectionIndexCompletedStatus extends WallpaperSelectionIndexStatus {
  final int selectedIndex;
  WallpaperSelectionIndexCompletedStatus(this.selectedIndex);
}