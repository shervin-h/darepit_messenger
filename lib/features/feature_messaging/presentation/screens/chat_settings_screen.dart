import 'dart:convert';

import 'package:flusher/config/app_settings.dart';
import 'package:flusher/core/widgets/custom_widgets.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/chat_item_settings/chat_item_settings_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/wallpaper_selection/wallpaper_selection_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/wallpaper_selection/wallpaper_selection_index_status.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/wallpaper_selection/wallpaper_selection_pick_gallery_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:flusher/features/feature_messaging/presentation/screens/wallpaper_selection_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ChatSettingsScreen extends StatelessWidget {
  const ChatSettingsScreen({Key? key}) : super(key: key);

  static const String routeName = '/chat-settings-screen';

  @override
  Widget build(BuildContext context) {
    double expandedHeight = context.height * 0.3;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              // pinned: true,
              backgroundColor: context.theme.colorScheme.background,
              foregroundColor: context.theme.colorScheme.onBackground,
              expandedHeight: expandedHeight,
              flexibleSpace: SizedBox(
                height: expandedHeight,
                child: Lottie.asset('assets/lottie/settings2.json'),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(CupertinoIcons.back),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pushNamed(WallpaperSelectionScreen.routeName);
                    },
                    trailing: BlocBuilder<WallpaperSelectionBloc, WallpaperSelectionState>(
                      builder: (context, state) {
                        if (state.indexStatus is WallpaperSelectionIndexCompletedStatus) {
                          int index = (state.indexStatus as WallpaperSelectionIndexCompletedStatus).selectedIndex;
                          return Container(
                            margin: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              backgroundImage: AssetImage('assets/images/wallpaper_${index + 1}.jpg'),
                              backgroundColor: context.theme.colorScheme.background,
                              radius: 40,
                            ),
                          );
                        }
                        if (state.pickGalleryImageStatus is WallpaperSelectionPickGalleryImageCompletedStatus) {
                          String encodedWallpaper = (state.pickGalleryImageStatus as WallpaperSelectionPickGalleryImageCompletedStatus).encodedWallpaper;
                          return Container(
                            margin: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              backgroundImage: MemoryImage(base64Decode(encodedWallpaper)),
                              backgroundColor: context.theme.colorScheme.background,
                              radius: 40,
                            ),
                          );
                        }
                        return Container(
                          margin: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: (AppSettings.wallpaper.isNotEmpty)
                              ? CircleAvatar(
                                  backgroundImage: MemoryImage(base64Decode(AppSettings.wallpaper)),
                                  backgroundColor: context.theme.colorScheme.background,
                                  radius: 40,
                                )
                              : CircleAvatar(
                                  backgroundImage: (AppSettings.assetWallpaperName.isNotEmpty)
                                      ? AssetImage('assets/images/${AppSettings.assetWallpaperName}')
                                      : const AssetImage('assets/images/wallpaper_1.jpg'),
                                  backgroundColor: context.theme.colorScheme.background,
                                  radius: 40,
                                )
                          ,
                        );
                      },
                    ),
                    title: const Text('انتخاب تصویر پس زمیه اتاق چت'),
                  ),
                  const Divider(),
                  const ListTile(
                    title: Text('اندازه فونت پیام های اتاق چت'),
                    subtitle: FontSizeLinearGauge(),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('تغییر رنگ حباب چت های شما'),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          CircleColorWidget(color: Colors.white, colorName: 'white',),
                          CircleColorWidget(color: Colors.lightBlue, colorName: 'light_blue',),
                          CircleColorWidget(color: Colors.blue, colorName: 'blue',),
                          CircleColorWidget(color: Colors.red, colorName: 'red',),
                          CircleColorWidget(color: Colors.orange, colorName: 'orange',),
                          CircleColorWidget(color: Colors.yellow, colorName: 'yellow',),
                          CircleColorWidget(color: Colors.grey, colorName: 'grey',),
                          CircleColorWidget(color: Colors.purple, colorName: 'purple',),
                          CircleColorWidget(color: Colors.pink, colorName: 'pink',),
                          CircleColorWidget(color: Colors.green, colorName: 'green',),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                ]
              ),
            )
          ],
        ),
      ),
    );
  }
}


/// Syncfusion Linear Gauge
class FontSizeLinearGauge extends StatefulWidget {
  const FontSizeLinearGauge({Key? key}) : super(key: key);

  @override
  State<FontSizeLinearGauge> createState() => _FontSizeLinearGaugeState();
}

class _FontSizeLinearGaugeState extends State<FontSizeLinearGauge> {

  double _value = 14;

  @override
  void initState() {
    super.initState();
    _value = AppSettings.fontSize;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: SfLinearGauge(
        minimum: 14,
        maximum: 34,
        interval: 2,
        orientation: LinearGaugeOrientation.horizontal,
        majorTickStyle: const LinearTickStyle(length: 10),
        minorTickStyle: const LinearTickStyle(length: 5),
        axisLabelStyle: TextStyle(fontSize: 12.0, color: context.theme.colorScheme.onBackground),
        axisTrackStyle: LinearAxisTrackStyle(
          color: context.theme.colorScheme.primary,
          edgeStyle: LinearEdgeStyle.bothFlat,
          thickness: 16.0,
          borderColor: Colors.grey,
        ),
        markerPointers: [
          LinearShapePointer(
            value: _value,
            color: context.theme.colorScheme.secondary,
            onChanged: (value) {
              setState(() {_value = value;});
            },
            onChangeEnd: (value) {
              BlocProvider.of<ChatItemSettingsBloc>(context).add(ChangedChatItemSettingsEvent(fontSize: value));
              showCustomSuccessSnackBar(context, 'انداز متن پیام های اتاق چت به ${value.toInt().toString()} تغییر کید');
            },
          )
        ],
      ),

    );
  }
}
/// End of Linear Gauge


class CircleColorWidget extends StatelessWidget {
  const CircleColorWidget({required this.color, required this.colorName, Key? key}) : super(key: key);

  final Color color;
  final String colorName;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          BlocProvider.of<ChatItemSettingsBloc>(context).add(ChangedChatItemSettingsEvent(bubbleColor: colorName));
          showCustomAmazingSnackBar(
            context: context,
            message: 'رنگ حباب چت ها با موفقیت $colorName شد :)',
            backgroundColor: color,
            onBackgroundColor: (colorName == 'white' || colorName == 'yellow') ? context.theme.colorScheme.onBackground : Colors.white,
          );
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          width: context.width * 0.08,
          height: context.width * 0.08,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                color: context.theme.colorScheme.onBackground.withOpacity(0.3),
                blurRadius: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

