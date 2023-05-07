import 'dart:convert';
import 'dart:ui';

import 'package:flusher/config/app_settings.dart';
import 'package:flusher/core/utils/helper.dart';
import 'package:flusher/core/widgets/custom_widgets.dart';
import 'package:flusher/features/feature_messaging/domain/entities/user_entity.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/delete_chat_use_case.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/get_user_profile_image_public_url.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/chat_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/chat_item_settings/chat_item_settings_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/utils/date_time_helper.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/get_user_from_db_use_case.dart';
import 'package:cached_network_image/cached_network_image.dart';


class MessageItemWidget extends StatefulWidget {
  const MessageItemWidget({
    Key? key,
    required this.data,
    required this.isMe,
    required this.userEntity,
  }) : super(key: key);

  final Map<String, dynamic> data;
  final bool isMe;
  final UserEntity userEntity;

  @override
  State<MessageItemWidget> createState() => _MessageItemWidgetState();
}

class _MessageItemWidgetState extends State<MessageItemWidget> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    const double radius = 16;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Directionality(
        textDirection: widget.isMe ? TextDirection.rtl : TextDirection.ltr,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
              onTap: () => _expandUserImage(context),
              child: Container(
                width: context.width * 0.1,
                height: context.width * 0.1,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.secondary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: widget.isMe
                    ? (widget.userEntity.profileImage != null && widget.userEntity.profileImage!.isNotEmpty)
                      ? ClipOval(
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(48),
                            child: Image.memory(
                              base64Decode(widget.userEntity.profileImage!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(CupertinoIcons.person_alt, color: context.theme.colorScheme.onSecondary,);
                              },
                            ),
                          ),
                        )
                      : Text(
                          AppSettings.username.trim().isNotEmpty
                              ? AppSettings.username.trim().characters.first.toUpperCase()
                              : _getSenderUsername().characters.first.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ) ,
                        )
                    : FutureBuilder<DataState<String>>(
                        future: GetUserProfileImagePublicUrl()(widget.data['sender']),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            final dataState = snapshot.data!;
                            if (dataState is DataSuccess && dataState.data != null) {
                              return SizedBox.fromSize(
                                size: const Size.fromRadius(48),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: dataState.data!,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, error, stackTrace) {
                                      return Center(
                                        child: Text(
                                          _getSenderUsername().characters.first.toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ) ,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }
                          }
                          return Text(
                            _getSenderUsername().characters.first.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ) ,
                          );
                        },
                      )

              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                    child: Text(
                      parseStringToFormattedJalali(widget.data['created_at']),
                      textDirection: TextDirection.ltr,
                      style: context.textTheme.caption!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.8),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onLongPress: widget.isMe
                        ? () {
                            // param1: chat_id, param2: user_id
                            showCupertinoDialog(

                              barrierDismissible: true,
                              context: context,
                              builder: (context) {
                                return CustomDialogWidget(
                                  message: 'پیام برای همیشه حذف می شود، ادامه می دهید؟',
                                  lottiePath: 'assets/lottie/delete.json',
                                  confirmBackgroundColor: context.theme.colorScheme.secondary,
                                  cancelBackgroundColor: context.theme.colorScheme.primary,
                                  onConfirmed: () async {
                                    BlocProvider.of<ChatBloc>(context).add(DeleteMessageEvent(widget.data['id'], widget.data['user_id']));
                                  },
                                  confirmText: 'حذف',
                                );
                              },
                            );
                          }
                        : null,
                    child: Container(
                      margin: widget.isMe
                          ? EdgeInsets.fromLTRB(context.width * 0.16, 2, 8, 8)
                          : EdgeInsets.fromLTRB(8, 2, context.width * 0.16, 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(radius),
                          topRight: const Radius.circular(radius),
                          bottomLeft: widget.isMe ? const Radius.circular(radius) : Radius.zero,
                          bottomRight: widget.isMe ? Radius.zero : const Radius.circular(radius),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 4,
                            sigmaY: 4,
                          ),
                          child: BlocBuilder<ChatItemSettingsBloc, ChatItemSettingsState>(
                            buildWhen: (previous, current) {
                              if (previous == current) {
                                return false;
                              }
                              return true;
                            },
                            builder: (context, state) {
                              if (state is ChatItemSettingsCompletedState) {
                                final bubbleColor = convertNameToColor(state.bubbleColor);
                                final fontSize = state.fontSize;
                                return Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: widget.isMe
                                        ? bubbleColor.withOpacity(0.6) ?? Colors.white.withOpacity(0.6)
                                        : context.theme.colorScheme.primary.withOpacity(0.6),

                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(radius),
                                      topRight: const Radius.circular(radius),
                                      bottomLeft: widget.isMe ? const Radius.circular(radius) : Radius.zero,
                                      bottomRight: widget.isMe ? Radius.zero : const Radius.circular(radius),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.isMe
                                            ? AppSettings.username.trim().isNotEmpty ? AppSettings.username.trim() : _getSenderUsername()
                                            : _getSenderUsername(),
                                        style: context.textTheme.caption!.copyWith(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          color: widget.isMe ? Colors.grey.shade800 : Colors.white70,
                                          shadows: [Shadow(color: context.theme.colorScheme.secondary.withOpacity(0.5), blurRadius: 8)]
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      if (widget.data['contain_asset'] && (widget.data['asset_url'] as String).isNotEmpty)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: Image.network(
                                            widget.data['asset_url'],
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Center(
                                                child: Icon(
                                                  CupertinoIcons.photo,
                                                  color: context.theme.colorScheme.error,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      const SizedBox(height: 2),
                                      Text(
                                        widget.data['text'],
                                        textDirection: TextDirection.rtl,
                                        maxLines: 16,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.textTheme.bodyText2!.copyWith(
                                          fontSize: fontSize,
                                          color: widget.isMe ? Colors.grey.shade900 : Colors.white,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              color: widget.isMe ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.3),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: widget.isMe
                                      ? (widget.userEntity.bubbleColor != null)
                                        ? convertNameToColor(widget.userEntity.bubbleColor!).withOpacity(0.6)
                                        : Colors.white.withOpacity(0.6)
                                      : context.theme.colorScheme.primary.withOpacity(0.6),

                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(radius),
                                    topRight: const Radius.circular(radius),
                                    bottomLeft: widget.isMe ? const Radius.circular(radius) : Radius.zero,
                                    bottomRight: widget.isMe ? Radius.zero : const Radius.circular(radius),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      widget.isMe
                                          ? AppSettings.username.trim().isNotEmpty ? AppSettings.username.trim() : _getSenderUsername()
                                          : _getSenderUsername(),
                                      style: context.textTheme.caption!.copyWith(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          color: widget.isMe ? Colors.grey.shade800 : Colors.white70,
                                          shadows: [Shadow(color: context.theme.colorScheme.secondary.withOpacity(0.5), blurRadius: 8)]
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    if (widget.data['contain_asset'] && (widget.data['asset_url'] as String).isNotEmpty)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Image.network(
                                          widget.data['asset_url'],
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Center(
                                              child: Icon(
                                                CupertinoIcons.photo,
                                                color: context.theme.colorScheme.error,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    const SizedBox(height: 2),
                                    // ReadMoreTextWidget(
                                    //   data: widget.data['text'],
                                    //   fontSize: (widget.userEntity.fontSize != null) ? widget.userEntity.fontSize!.toDouble() : 14,
                                    //   isMe: widget.isMe,
                                    // ),
                                    Text(
                                      widget.data['text'],
                                      textDirection: TextDirection.rtl,
                                      maxLines: 16,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.textTheme.bodyText2!.copyWith(
                                        fontSize: (widget.userEntity.fontSize != null) ? widget.userEntity.fontSize!.toDouble() : 14,
                                        color: widget.isMe ? Colors.grey.shade900 : Colors.white,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color: widget.isMe ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.3),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),

                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSenderUsername() {
    if (widget.data['username'] != null &&
        widget.data['username'] is String &&
        (widget.data['username'] as String).trim().isNotEmpty) {
      return (widget.data['username'] as String).trim();
    } else {
      return widget.data['sender'];
    }
  }

  void _expandUserImage(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return SafeArea(
          child: Dialog(
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.all(8),
              width: context.width * 0.7,
              height: context.width * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.theme.colorScheme.secondary,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  widget.isMe
                      ? (widget.userEntity.profileImage != null && widget.userEntity.profileImage!.isNotEmpty)
                        ? ClipOval(
                    child: Image.memory(
                      base64Decode(widget.userEntity.profileImage!),
                      fit: BoxFit.cover,
                      width: context.width * 0.7,
                      height: context.height * 0.7,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(CupertinoIcons.person_alt, color: context.theme.colorScheme.onSecondary,);
                      },
                    ),
                  )
                        : Text(
                    AppSettings.username.trim().isNotEmpty
                        ? AppSettings.username.trim().characters.first.toUpperCase()
                        : _getSenderUsername().characters.first.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 4,
                        ),
                      ],
                    ) ,
                  )
                      : FutureBuilder<DataState<String>>(
                    future: GetUserProfileImagePublicUrl()(widget.data['sender']),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        final dataState = snapshot.data!;
                        if (dataState is DataSuccess && dataState.data != null) {
                          return ClipOval(
                            child: Image.network(
                              dataState.data!,
                              fit: BoxFit.cover,
                              width: context.width * 0.7,
                              height: context.height * 0.7,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    _getSenderUsername().characters.first.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ) ,
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }
                      return Text(
                        _getSenderUsername().characters.first.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              blurRadius: 4,
                            ),
                          ],
                        ) ,
                      );
                    },
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 20,
                    child: Text(
                      widget.isMe
                          ? AppSettings.username.trim().isNotEmpty
                          ? AppSettings.username.trim()
                          : _getSenderUsername()
                          : _getSenderUsername(),
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                            color: Colors.black45,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}


class ReadMoreTextWidget extends StatefulWidget {
  const ReadMoreTextWidget({
    required this.data,
    required this.fontSize,
    required this.isMe,
    Key? key,
  }) : super(key: key);

  final String data;
  final double fontSize;
  final bool isMe;

  @override
  State<ReadMoreTextWidget> createState() => _ReadMoreTextWidgetState();
}

class _ReadMoreTextWidgetState extends State<ReadMoreTextWidget> {
  bool _isReadMore = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.data,
          textDirection: TextDirection.rtl,
          maxLines: _isReadMore ? null : 10,
          overflow: _isReadMore ? TextOverflow.visible : TextOverflow.ellipsis,
          style: context.textTheme.bodyText2!.copyWith(
            fontSize: widget.fontSize,
            color: widget.isMe ? Colors.grey.shade900 : Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: widget.isMe ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.3),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              _isReadMore = !_isReadMore;
            });
          },
          child: Text(
            _isReadMore ? 'بستن' : 'ادامه پیام',
            style: context.textTheme.caption!.copyWith(
              color: context.theme.colorScheme.onPrimary,
              shadows: [
                const Shadow(
                  color: Colors.black87,
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

