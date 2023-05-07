import 'dart:convert';
import 'package:flusher/config/app_settings.dart';
import 'package:flusher/core/widgets/custom_widgets.dart';
import 'package:flusher/features/feature_messaging/domain/entities/user_entity.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/get_count_unseen_messages_use_case.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/rooms/visited_rooms/visited_rooms_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/widgets/update_room_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/resources/data_state.dart';
import '../../domain/entities/room_entity.dart';
import '../../domain/usecases/enter_the_selected_room_use_case.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/rooms/rooms_bloc.dart';
import '../screens/chat_screen.dart';


class RoomItemWidget extends StatefulWidget {
  const RoomItemWidget({required this.room, required this.currentUserEmail, required this.isFromCache, Key? key}) : super(key: key);

  final RoomEntity room;
  final String currentUserEmail;
  final bool isFromCache;

  @override
  State<RoomItemWidget> createState() => _RoomItemWidgetState();
}

class _RoomItemWidgetState extends State<RoomItemWidget> {
  late final TextEditingController _privateRoomUuidController ;

  @override
  void initState() {
    super.initState();
    _privateRoomUuidController = TextEditingController();
  }

  @override
  void dispose() {
    // _privateRoomUuidController.dispose();
    super.dispose();
  }

  /// after test delete
  // var uuid = const Uuid();
  // String _generateUUId(int userId, String email) {
  //   // Generate a v5 (namespace-name-sha1-based) id
  //   return uuid.v5(Uuid.NAMESPACE_URL, 'shervin.hassanzadeh.flusher?user:$userId&email:$email&timestamp:${DateTime.now().microsecondsSinceEpoch.toString().substring(8, 12)}');
  // }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {

        if (widget.isFromCache && widget.room.isPrivate && widget.room.privateKey != null && widget.room.privateKey!.isNotEmpty) {
          // The user has already entered this room and cached the key
          await EnterTheSelectedRoomUseCase()(widget.room, widget.currentUserEmail).then((DataState<UserEntity> dataState) {
            if (dataState is DataSuccess && dataState.data != null) {
              BlocProvider.of<ChatBloc>(context).add(EnterTheChatRoomEvent(roomEntity: widget.room, userEntity: dataState.data!));
              BlocProvider.of<VisitedRoomsBloc>(context).add(VisitedRoomsStartedEvent());
              Navigator.of(context).pushNamed(ChatScreen.routeName);
            }
          });

        } else if (widget.room.isPrivate && AppSettings.userId != widget.room.userId) {
          _functionalityWhenEnteringThePrivateRoom(context);
        } else {
          // The owner of this private group is the current user
          await EnterTheSelectedRoomUseCase()(widget.room, widget.currentUserEmail).then((DataState<UserEntity> dataState) {
            if (dataState is DataSuccess && dataState.data != null) {
              BlocProvider.of<ChatBloc>(context).add(EnterTheChatRoomEvent(roomEntity: widget.room, userEntity: dataState.data!));
              BlocProvider.of<VisitedRoomsBloc>(context).add(VisitedRoomsStartedEvent());
              Navigator.of(context).pushNamed(ChatScreen.routeName);
            }
          });

        }

      },
      onLongPress: () {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return RemoveRoomDialogWidget(room: widget.room, email: widget.currentUserEmail);
          },
        );
      },
      leading: InkWell(
        onTap: widget.room.roomImage.isNotEmpty
            ? () {
                showCupertinoDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) {
                    double radius = 16;
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Container(
                        width: context.width * 0.8,
                        height: context.height * 0.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.memory(
                                base64Decode(widget.room.roomImage),
                                fit: BoxFit.cover,
                                width: context.width * 0.8,
                                height: context.height * 0.6,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.bottomCenter,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(radius),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    context.theme.colorScheme.primary,
                                    Colors.transparent,
                                    Colors.transparent,
                                  ]
                                ),
                              ),
                              child: Text(
                                widget.room.name,
                                style: context.textTheme.headlineSmall!.copyWith(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            : null,
        child: CircleAvatar(
          backgroundImage: (widget.room.roomImage.isNotEmpty)
              ? MemoryImage(base64Decode(widget.room.roomImage))
              : null,
          radius: 30,
          backgroundColor: context.theme.colorScheme.secondary,
          child: (widget.room.roomImage.isNotEmpty)
              ? null
              : Text(
                  widget.room.name.characters.first.toUpperCase(),
                  style: context.textTheme.headline6!.copyWith(
                      color: context.theme.colorScheme.onSecondary
                  ),
                ),
        ),
      ),
      trailing: (widget.room.userId == AppSettings.userId)
          ? IconButton(
        onPressed: () {
          showCupertinoDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return UpdateRoomDialogWidget(roomEntity: widget.room);
            },
          );
        },
        icon: const Icon(CupertinoIcons.pencil_outline),
      )
          : null,
      title: Row(
        children: [
          Text(widget.room.name, maxLines: 1, overflow: TextOverflow.ellipsis,),
          widget.room.isPrivate ? const SizedBox(width: 8) : const SizedBox(),
          widget.room.isPrivate ? const Icon(CupertinoIcons.lock_circle, size: 24,) : const SizedBox(),
          const Expanded(child: SizedBox()),
          _getUnseenMessagesCount(context, widget.room.roomId),
        ],
      ),
      subtitle: (widget.room.description.isNotEmpty)
          ? Text(widget.room.description, maxLines: 2, overflow: TextOverflow.ellipsis,)
          : null,
    );
  }

  _functionalityWhenEnteringThePrivateRoom(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return SafeArea(
          child: CupertinoAlertDialog(
            title: Lottie.asset(
              'assets/lottie/no_permission.json',
              width: context.width * 0.4,
              fit: BoxFit.fitWidth
            ),
            content: Column(
              children: [
                Text(
                  'این اتاق خصوصی است!',
                  style: context.textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Material(
                  // borderRadius: BorderRadius.circular(8),
                  child: ExpansionTile(
                    title: Text(
                      'کلید ورود دارید؟', style: context.textTheme.bodyText1!.copyWith(
                      color: context.theme.colorScheme.onBackground,
                    ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (widget.room.privateKey != null &&
                                    widget.room.privateKey!.trim().isNotEmpty &&
                                    _privateRoomUuidController.text.trim() == widget.room.privateKey!.trim()
                                ) {
                                  await EnterTheSelectedRoomUseCase()(widget.room, widget.currentUserEmail).then((DataState<UserEntity> dataState) {
                                    if (dataState is DataSuccess && dataState.data != null) {
                                      BlocProvider.of<ChatBloc>(context).add(EnterTheChatRoomEvent(roomEntity: widget.room, userEntity: dataState.data!));
                                      BlocProvider.of<VisitedRoomsBloc>(context).add(VisitedRoomsStartedEvent());
                                      _privateRoomUuidController.clear();
                                      Navigator.of(context).popAndPushNamed(ChatScreen.routeName);
                                    }
                                  });
                                } else {
                                  showCustomErrorSnackBar(context, 'کلید اشتباه!');
                                }
                              },
                              child: const Icon(CupertinoIcons.arrow_down_right_square),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: TextField(
                                controller: _privateRoomUuidController,
                                textDirection: TextDirection.ltr,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(color: Colors.grey),
                                    gapPadding: 2,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: context.theme.colorScheme.primary.withOpacity(0.4)),
                                    gapPadding: 2,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: context.theme.colorScheme.primary),
                                    gapPadding: 2,
                                  ),
                                ),
                                minLines: 1,
                                maxLines: 4,
                              )
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('باشه'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getUnseenMessagesCount(BuildContext context, int roomId) {
    return FutureBuilder<DataState<int>>(
      future: GetCountUnSeenMessagesUseCase()(roomId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CupertinoActivityIndicator(
              color: context.theme.colorScheme.primary,
            ),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          if (snapshot.data is DataFailed) {
            return const SizedBox();
          }
          final count = snapshot.data!.data;
          return (count != null && count > 0)
              ? Container(
                padding: const EdgeInsets.all(6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.theme.colorScheme.primary.withOpacity(0.6),
                ),
                child: Text(
                  count.toString(),
                  style: context.textTheme.caption!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
              : const SizedBox();
        }
        return const SizedBox();
      },
    );
  }
}


class RemoveRoomDialogWidget extends StatelessWidget {
  const RemoveRoomDialogWidget({required this.room, required this.email, Key? key}) : super(key: key);

  final RoomEntity room;
  final String email;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.loose,
          children: [
            Material(
              color: Colors.transparent,
              child: Container(
                alignment: Alignment.center,
                width: context.width * 0.8,
                height: context.height * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Lottie.asset('assets/lottie/delete.json', fit: BoxFit.fitWidth)),
                        const SizedBox(height: 16),
                        Text(
                          'آیا از حذف اتاق اطمینان دارید؟',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: context.textTheme.headline6,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    BlocProvider.of<RoomsBloc>(context).add(RemoveRoomEvent(room));
                                  },
                                  child: const Text('بله'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('خیر'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    BlocConsumer<RoomsBloc, RoomsState>(
                      listener: (context, state) {
                        if (state is RoomsCompletedState) {
                          Navigator.of(context).pop();
                        }
                      },
                      builder: (context, state) {
                        if (state is RoomsLoadingState) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const LoadingAnimation(),
                          );
                        } else if (state is RoomsErrorState) {
                          return Container(
                            decoration: BoxDecoration(
                              color: context.theme.colorScheme.error,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Text(
                                    state.errorMessage,
                                    textAlign: TextAlign.center,
                                    style: context.textTheme.bodyText1!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: context.theme.colorScheme.onError,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 40,
                                  right: 40,
                                  bottom: 24,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      BlocProvider.of<RoomsBloc>(context).add(RoomsStartedEvent(email));
                                      Navigator.of(context).pop();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                      elevation: MaterialStateProperty.all<double>(16),
                                    ),
                                    child: Text(
                                      'متوجه شدم',
                                      style: context.textTheme.bodyText1!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: context.theme.colorScheme.error,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }

                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
