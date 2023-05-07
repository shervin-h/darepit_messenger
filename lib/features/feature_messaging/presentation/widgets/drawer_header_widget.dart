import 'dart:convert';

import 'package:flusher/features/feature_messaging/presentation/screens/edit_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_circular_text/circular_text.dart';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({
    required this.pickImageButtonOnPressed,
    required this.editButtonOnPressed,
    required this.pickButtonText,
    required this.editButtonText,
    this.username,
    this.encoded,
    Key? key,
  }) : super(key: key);

  final void Function()? pickImageButtonOnPressed;
  final void Function()? editButtonOnPressed;
  final String pickButtonText;
  final String editButtonText;
  final String? encoded;
  final String? username;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height * 0.3,
      decoration: BoxDecoration(
        // color: Colors.black38,
        color: context.theme.colorScheme.secondary.withOpacity(0.4),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.white.withOpacity(0.2),
                    highlightColor: Colors.white,
                    period: const Duration(seconds: 4),
                    child: CircularText(
                      children: [
                        TextItem(
                          text: Text(
                            (username != null && username!.trim().isNotEmpty)
                                ? username!.toUpperCase()
                                : '',
                            style: context.textTheme.headline4!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.theme.colorScheme.primary,
                            ),
                          ),
                          space: 14,
                          startAngle: -90,
                          startAngleAlignment: StartAngleAlignment.center,
                          direction: CircularTextDirection.clockwise,
                        ),
                        // TextItem(
                        //   text: Text(
                        //     "Hassanzadeh".toUpperCase(),
                        //     style: context.textTheme.headline4!.copyWith(
                        //       fontWeight: FontWeight.bold,
                        //       color: context.theme.colorScheme.primary,
                        //     ),
                        //   ),
                        //   space: 12,
                        //   startAngle: 90,
                        //   startAngleAlignment: StartAngleAlignment.center,
                        //   direction: CircularTextDirection.anticlockwise,
                        // ),
                      ],
                      radius: context.width * 0.4,
                      position: CircularTextPosition.inside,
                      backgroundPaint: Paint()..color = Colors.transparent,
                    ),
                  ),

                  Container(
                    width: context.width * 0.34,
                    height: context.width * 0.34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.theme.colorScheme.secondary,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Shimmer.fromColors(
                      baseColor: context.theme.colorScheme.onSecondary.withOpacity(0.4),
                      highlightColor: context.theme.colorScheme.onSecondary,
                      child: Icon(
                        CupertinoIcons.person_add,
                        color: context.theme.colorScheme.onSecondary,
                        size: context.width * 0.16,
                      ),
                    ),
                  ),
                  Container(
                    width: context.width * 0.34,
                    height: context.width * 0.34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      image: encoded != null && encoded!.isNotEmpty
                          ? DecorationImage(
                              image: MemoryImage(base64Decode(encoded!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 8),
            FittedBox(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: pickImageButtonOnPressed,
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                          )
                      ),
                      child: Row(
                        children: [
                          Text(
                            pickButtonText,
                            style: context.textTheme.button!.copyWith(
                              color: context.theme.colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            CupertinoIcons.photo_camera,
                            color: context.theme.colorScheme.onPrimary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      // onPressed: editButtonOnPressed,
                      onPressed: () {
                        Navigator.of(context).pushNamed(EditProfileScreen.routeName);
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                          )
                      ),
                      child: Row(
                        children: [
                          Text(
                            editButtonText,
                            style: context.textTheme.button!.copyWith(
                              color: context.theme.colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(CupertinoIcons.profile_circled,
                            color: context.theme.colorScheme.onPrimary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
