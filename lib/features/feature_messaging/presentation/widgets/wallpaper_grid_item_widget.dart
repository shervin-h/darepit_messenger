import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/constants.dart';

class WallpaperGridItemWidget extends StatelessWidget {
  const WallpaperGridItemWidget({required this.index, this.wallpaper, required this.isSelected, Key? key}) : super(key: key);

  final int index;
  final String? wallpaper;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.concave,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        depth: 8,
        lightSource: LightSource.topLeft,
        color: Colors.grey
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? context.theme.colorScheme.primary : Colors.white,
            width: 3,
          ),
          image: (index < AppConstant.wallpaperNames.length)
            ? DecorationImage(
                image: AssetImage('assets/images/${AppConstant.wallpaperNames[index]}'),
                fit: BoxFit.cover,
              )
            : null,
          ),
          child: wallpaper != null
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.memory(base64Decode(wallpaper!), fit: BoxFit.cover,),
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Shimmer.fromColors(
                        baseColor: context.theme.colorScheme.primary.withOpacity(0.4),
                        highlightColor: context.theme.colorScheme.primary,
                        child: Icon(
                          CupertinoIcons.plus_circle,
                          size: context.width * 0.16,
                          color: context.theme.colorScheme.onBackground,
                        ),
                      ),
                    )
                  ],
                )
              : (index < AppConstant.wallpaperNames.length)
                ? null
                : Icon(
                    CupertinoIcons.plus_circle,
                    size: context.width * 0.16,
                    color: context.theme.colorScheme.onBackground,
                  ),
      ),
    );
  }
}