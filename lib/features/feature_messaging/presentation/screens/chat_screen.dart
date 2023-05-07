import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flusher/core/params/chat_params.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/utils/helper.dart';
import 'package:flusher/core/widgets/custom_widgets.dart';
import 'package:flusher/core/widgets/speech_to_text.dart';
import 'package:flusher/features/feature_messaging/domain/entities/room_entity.dart';
import 'package:flusher/features/feature_messaging/domain/entities/user_entity.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/insert_last_seen_chat_use_case.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/send_chat_use_case.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/chat_wallpaper_status.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/enter_the_chat_room_status.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/pick_image/chat_pick_image_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/send_message_status.dart';
import 'package:flusher/features/feature_messaging/presentation/widgets/message_item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bloc/chat/chat_bloc.dart';
import '../bloc/rooms/rooms_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static const String routeName = '/chat-screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with AutomaticKeepAliveClientMixin {

  final supabase = Supabase.instance.client;
  var _stream;

  late TextEditingController _messageController;
  late FocusNode _messageFocusNode;

  late RefreshController _refreshController;
  void _onRefresh(RoomEntity room, UserEntity user) async{
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    BlocProvider.of<ChatBloc>(context).add(EnterTheChatRoomEvent(roomEntity: room, userEntity: user));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
    // if(mounted) {
    //   setState(() {});
    // }

    // _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _messageFocusNode = FocusNode();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  int lastSeenChat = 0;
  int roomId = 0;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return WillPopScope(
      onWillPop: () async {

        // param1: room_id, param2: chat_id
        InsertLastSeenChatUseCase()(roomId, lastSeenChat);
        BlocProvider.of<ChatPickImageBloc>(context).add(ChatPickImageSetToInitialEvent());
        return true;
      },
      child: BlocBuilder<ChatBloc, ChatState>(
        buildWhen: (previous, current) {
          if (previous.enterTheChatRoomStatus == current.enterTheChatRoomStatus) {
            return false;
          }
          return true;
        },
        builder: (context, state) {
          if (state.enterTheChatRoomStatus is EnterTheChatRoomCompletedStatus) {
            final enterTheChatRoomCompletedStatus = (state.enterTheChatRoomStatus as EnterTheChatRoomCompletedStatus);
            final RoomEntity roomData = enterTheChatRoomCompletedStatus.roomData as RoomEntity;
            roomId = roomData.roomId;
            UserEntity userEntity = enterTheChatRoomCompletedStatus.userEntity;

            _stream = supabase.from('chats')
                .stream(primaryKey: ['id', 'room_id'])
                .eq('room_id', roomData.roomId)
                .order('created_at')
                .limit(100);

            return BlocBuilder<ChatBloc, ChatState>(
              buildWhen: (previous, current) {
                if (previous.chatWallpaperStatus == current.chatWallpaperStatus) {
                  return false;
                }
                return true;
              },
              builder: (context, state) {
                if (state.chatWallpaperStatus is ChatWallpaperCompletedStatus) {
                  userEntity = (state.chatWallpaperStatus as ChatWallpaperCompletedStatus).userEntity;
                  final fromAsset = (state.chatWallpaperStatus as ChatWallpaperCompletedStatus).fromAsset;
                  return Scaffold(
                    appBar: AppBar(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (roomData.roomImage.isNotEmpty)
                            CircleAvatar(
                              backgroundImage: MemoryImage(base64Decode(roomData.roomImage)),
                              // radius: 40,
                              backgroundColor: context.theme.colorScheme.secondary,
                            ),
                          if (roomData.roomImage.isNotEmpty)
                            const SizedBox(width: 4),
                          Text(
                            userEntity.room != null && userEntity.room!.isNotEmpty ? userEntity.room! : roomData.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ), //const Text('پیام‌رسانِ درِپیت 😉'),
                      centerTitle: true,
                      leading: IconButton(
                        onPressed: () {
                          // param1: room_id, param2: chat_id
                          InsertLastSeenChatUseCase()(roomId, lastSeenChat);
                          BlocProvider.of<ChatBloc>(context).add(ExitTheChatRoomEvent());
                          BlocProvider.of<ChatPickImageBloc>(context).add(ChatPickImageSetToInitialEvent());
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(CupertinoIcons.back),
                      ),
                      actions: [
                        if (roomData.userId == userEntity.userId && roomData.isPrivate && roomData.privateKey != null && roomData.privateKey!.isNotEmpty)
                          IconButton(
                            onPressed: () async {
                              await Share.share('''سلام من از پیام‌رسانِ درِپیت 😉 استفاده می کنم. \n تو هم نصبش کن و وارد اتاق خصوصی `${userEntity.room ?? roomData.name}` بشو ...\n کلید اتاق: \n ${roomData.privateKey}''');
                            },
                            icon: const FaIcon(FontAwesomeIcons.key),
                          ),

                        IconButton(
                          onPressed: () async {
                            await Share.share('''سلام من از پیام رسان درپیت 😁 استفاده می کنم. \n تو هم نصبش کن و وارد اتاق `${userEntity.room ?? roomData.name}` بشو ...''');
                          },
                          icon: const Icon(Icons.share),
                        )
                      ],
                    ),
                    body: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          width: context.width,
                          height: context.height,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/${(userEntity.assetWallpaper != null && userEntity.assetWallpaper!.isNotEmpty) ? userEntity.assetWallpaper! : 'wallpaper_1.jpg'}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: SafeArea(
                            child: Stack(
                              children: [
                                (!fromAsset && userEntity.wallpaper != null && userEntity.wallpaper!.isNotEmpty)
                                    ? Positioned(
                                  top: 0,
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Image.memory(base64Decode(userEntity.wallpaper!), fit: BoxFit.cover,),
                                )
                                    : const SizedBox(),
                                StreamBuilder<List<Map<String, dynamic>>>(
                                  stream: _stream,

                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const LoadingAnimation();
                                    }
                                    if (snapshot.hasData && snapshot.data != null) {
                                      final messages = snapshot.data!;
                                      if (messages.isEmpty) {
                                        return Center(
                                          child: Container(
                                            width: context.width * 0.6,
                                            height: context.width * 0.6,
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.6),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            alignment: Alignment.center,
                                            child: FittedBox(
                                              child: Column(
                                                children: [
                                                  Lottie.asset('assets/lottie/chat3.json'),
                                                  const SizedBox(height: 16),
                                                  Text('پیامی نیست ...', style: context.textTheme.headline3,)
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      lastSeenChat = messages.first['id']; // get first because order by created_at an recent chat is top of list
                                      return ListView.builder(
                                        padding: EdgeInsets.only(bottom: context.height * 0.1),
                                        physics: const BouncingScrollPhysics(),
                                        reverse: true,
                                        itemCount: messages.length,
                                        itemBuilder: (context, index) {
                                          return MessageItemWidget(data: messages[index], isMe: _isMe(messages[index]['sender']), userEntity: userEntity,);
                                        },
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const ShowPickedImageWidget(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 4,
                                    sigmaY: 4,
                                  ),
                                  child: BlocBuilder<ChatBloc, ChatState>(
                                    buildWhen: (previous, current) {
                                      if (previous.sendMessageStatus == current.sendMessageStatus) {
                                        return false;
                                      }
                                      return true;
                                    },
                                    builder: (context, state) {
                                      if (state.sendMessageStatus is SendMessageCompletedStatus) {
                                        _messageController.clear();
                                        _messageFocusNode.unfocus();
                                        BlocProvider.of<ChatBloc>(context).add(SendMessageInitialEvent());
                                      } else if (state.sendMessageStatus is SendMessageErrorStatus) {
                                        BlocProvider.of<ChatBloc>(context).add(SendMessageInitialEvent());
                                      }

                                      return Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1, color: context.theme.colorScheme.primary),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Row(
                                          children: [
                                            CustomSpeechToText(
                                              controller: _messageController,
                                              // focusNode: _messageFocusNode,
                                            ),
                                            const SizedBox(width: 16,),
                                            Expanded(
                                              child: _messageTextField(),
                                            ),
                                            const SizedBox(width: 4),
                                            const PickImageWidget(),
                                            const SizedBox(width: 4),
                                            BlocBuilder<ChatPickImageBloc, ChatPickImageState>(
                                              buildWhen: (previous, current) {
                                                if (previous == current) {
                                                  return false;
                                                }
                                                return true;
                                              },
                                              builder: (context, pickImageState) {
                                                File? imageFile;
                                                if (pickImageState is ChatPickImageCompletedState) {
                                                  imageFile = pickImageState.imageFile;
                                                }
                                                return IconButton(
                                                  onPressed: (state.sendMessageStatus is SendMessageLoadingStatus)
                                                      ? null
                                                      : () => _sendMessage(context, roomData, imageFile),
                                                  icon: (state.sendMessageStatus is SendMessageLoadingStatus)
                                                      ? const CustomCupertinoProgressWidget()
                                                      : const Icon(Icons.send, color: Colors.white),
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: SizedBox(
                            width: context.width,
                            height: context.height * 0.2,
                            child: SmartRefresher(
                              onRefresh: () {
                                _onRefresh(roomData, userEntity);
                              },
                              onLoading: _onLoading,
                              controller: _refreshController,
                              enablePullDown: true,
                              enablePullUp: false,
                              physics: const BouncingScrollPhysics(),
                              header: WaterDropMaterialHeader(
                                distance: 60,
                                offset: -(AppBar().preferredSize.height * 1.8),
                                backgroundColor: context.theme.colorScheme.primary,
                                color: context.theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Scaffold(
                  appBar: AppBar(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (roomData.roomImage.isNotEmpty)
                          CircleAvatar(
                            backgroundImage: MemoryImage(base64Decode(roomData.roomImage)),
                            // radius: 40,
                            backgroundColor: context.theme.colorScheme.secondary,
                          ),
                        if (roomData.roomImage.isNotEmpty)
                          const SizedBox(width: 4),
                        Text(
                          userEntity.room ?? roomData.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ), //const Text('پیام‌رسانِ درِپیت 😉'),,
                    centerTitle: true,
                    leading: IconButton(
                      onPressed: () {
                        // param1: room_id, param2: chat_id
                        InsertLastSeenChatUseCase()(roomId, lastSeenChat);
                        BlocProvider.of<ChatBloc>(context).add(ExitTheChatRoomEvent());
                        BlocProvider.of<ChatPickImageBloc>(context).add(ChatPickImageSetToInitialEvent());
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(CupertinoIcons.back),
                    ),
                    actions: [
                      if (roomData.userId == userEntity.userId && roomData.isPrivate && roomData.privateKey != null && roomData.privateKey!.isNotEmpty)
                        IconButton(
                          onPressed: () async {
                            await Share.share('''سلام من از پیام‌رسانِ درِپیت 😉 استفاده می کنم. \n تو هم نصبش کن و وارد اتاق خصوصی `${userEntity.room ?? roomData.name}` بشو ...\n کلید اتاق: \n ${roomData.privateKey}''');
                          },
                          icon: const FaIcon(FontAwesomeIcons.key),
                        ),
                      IconButton(
                        onPressed: () async {
                          //TODO: access to room entity
                          await Share.share('''سلام من از پیام رسان درپیت 😁 استفاده می کنم. \n تو هم نصبش کن و وارد اتاق `${userEntity.room ?? roomData.name}` بشو ...''');
                        },
                        icon: const Icon(Icons.share),
                      )
                    ],
                  ),
                  body: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: context.width,
                        height: context.height,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/${userEntity.assetWallpaper != null && userEntity.assetWallpaper!.isNotEmpty ? userEntity.assetWallpaper! : 'wallpaper_1.jpg'}'
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: SafeArea(
                          child: Stack(
                            children: [
                              (userEntity.wallpaper != null && userEntity.wallpaper!.isNotEmpty)
                                  ? Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Image.memory(base64Decode(userEntity.wallpaper!), fit: BoxFit.cover,),
                              )
                                  : const SizedBox(),
                              StreamBuilder<List<Map<String, dynamic>>>(
                                stream: _stream,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const LoadingAnimation();
                                  }
                                  if (snapshot.hasData && snapshot.data != null) {
                                    final messages = snapshot.data!;
                                    if (messages.isEmpty) {
                                      return Center(
                                        child: Container(
                                          width: context.width * 0.6,
                                          height: context.width * 0.6,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.6),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          alignment: Alignment.center,
                                          child: FittedBox(
                                            child: Column(
                                              children: [
                                                Lottie.asset('assets/lottie/chat3.json'),
                                                const SizedBox(height: 16),
                                                Text('پیامی نیست ...', style: context.textTheme.headline3,)
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    lastSeenChat = messages.first['id'];
                                    return ListView.builder(
                                      addAutomaticKeepAlives: true,
                                      padding: EdgeInsets.only(bottom: context.height * 0.1),
                                      physics: const BouncingScrollPhysics(),
                                      reverse: true,
                                      itemCount: messages.length,
                                      itemBuilder: (context, index) {
                                        return MessageItemWidget(data: messages[index], isMe: _isMe(messages[index]['sender']), userEntity: userEntity,);
                                      },
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const ShowPickedImageWidget(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 4,
                                  sigmaY: 4,
                                ),
                                child: BlocBuilder<ChatBloc, ChatState>(
                                  buildWhen: (previous, current) {
                                    if (previous.sendMessageStatus == current.sendMessageStatus) {
                                      return false;
                                    }
                                    return true;
                                  },
                                  builder: (context, state) {
                                    if (state.sendMessageStatus is SendMessageCompletedStatus) {
                                      _messageController.clear();
                                      _messageFocusNode.unfocus();
                                      BlocProvider.of<ChatBloc>(context).add(SendMessageInitialEvent());
                                    } else if (state.sendMessageStatus is SendMessageErrorStatus) {
                                      BlocProvider.of<ChatBloc>(context).add(SendMessageInitialEvent());
                                    }

                                    return Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1, color: context.theme.colorScheme.primary),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          CustomSpeechToText(
                                            controller: _messageController,
                                            // focusNode: _messageFocusNode,
                                          ),
                                          const SizedBox(width: 16,),
                                          Expanded(
                                            child: _messageTextField(),
                                          ),
                                          const SizedBox(width: 4),
                                          const PickImageWidget(),
                                          const SizedBox(width: 4),
                                          BlocBuilder<ChatPickImageBloc, ChatPickImageState>(
                                            buildWhen: (previous, current) {
                                              if (previous == current) {
                                                return false;
                                              }
                                              return true;
                                            },
                                            builder: (context, pickImageState) {
                                              File? imageFile;
                                              if (pickImageState is ChatPickImageCompletedState) {
                                                imageFile = pickImageState.imageFile;
                                              }
                                              return IconButton(
                                                onPressed: (state.sendMessageStatus is SendMessageLoadingStatus)
                                                    ? null
                                                    : () => _sendMessage(context, roomData, imageFile),
                                                icon: (state.sendMessageStatus is SendMessageLoadingStatus)
                                                    ? const CustomCupertinoProgressWidget()
                                                    : const Icon(Icons.send, color:Colors.white),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          width: context.width,
                          height: context.height * 0.2,
                          child: SmartRefresher(
                            onRefresh: () {
                              _onRefresh(roomData, userEntity);
                            },
                            onLoading: _onLoading,
                            controller: _refreshController,
                            enablePullDown: true,
                            enablePullUp: false,
                            physics: const BouncingScrollPhysics(),
                            header: WaterDropMaterialHeader(
                              distance: 60,
                              offset: -(AppBar().preferredSize.height * 1.8),
                              backgroundColor: context.theme.colorScheme.primary,
                              color: context.theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _messageTextField() {
    return TextField(
      controller: _messageController,
      style: const TextStyle(
        color: Colors.white,
      ),
      minLines: 1,
      maxLines: 4,
      decoration: const InputDecoration(
        hintText: 'پیام خود را بنویسید ...',
        contentPadding: EdgeInsets.all(4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(width: 1, color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(width: 1, color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(width: 1, color: Colors.transparent),
        ),
      ),
    );
  }

  void _sendMessage(BuildContext context, RoomEntity room, File? imageFile) async {
    if (imageFile == null) {
      if (_messageController.text.trim().isNotEmpty) {
        BlocProvider.of<ChatBloc>(context).add(
          SendMessageEvent(
            ChatParams(
              body: _messageController.text.trim(),
              roomId: room.roomId,
            ),
          ),
        );
      } else {
        showCustomErrorSnackBar(context, 'لطفاً پیام خود را بنویسید!');
      }
    } else {
      BlocProvider.of<ChatBloc>(context).add(
        SendMessageEvent(
          ChatParams(
            body: _messageController.text.trim(),
            roomId: room.roomId,
            file: imageFile,
          ),
        ),
      );
    }
    BlocProvider.of<ChatPickImageBloc>(context).add(ChatPickImageSetToInitialEvent());
  }

  bool _isMe(String sender) {
    final currentUser = supabase.auth.currentUser;
    if (currentUser != null && currentUser.email != null && currentUser.email!.isNotEmpty) {
      if (currentUser.email! == sender/*AppSettings.userId == messages[index]['user_id]*/) {
        return true;
      }
    }
    return false;
  }

  @override
  bool get wantKeepAlive => true;
}

class PickImageWidget extends StatelessWidget {
  const PickImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatPickImageBloc, ChatPickImageState>(
      buildWhen: (previous, current) {
        if (previous == current) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        if (state is ChatPickImageLoadingState) {
          return Container(
            padding: const EdgeInsets.all(4),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  CupertinoIcons.photo,
                  color: Colors.white.withOpacity(0.5),
                ),
                Center(
                  child: CupertinoActivityIndicator(
                    color: context.theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          );
        }
        return InkWell(
          onTap: () {
            BlocProvider.of<ChatPickImageBloc>(context).add(ChatPickImageStartedEvent());
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            child: const Icon(
              CupertinoIcons.photo,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

class ShowPickedImageWidget extends StatelessWidget {
  const ShowPickedImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double radius = 16;
    return BlocBuilder<ChatPickImageBloc, ChatPickImageState>(
      buildWhen: (previous, current) {
        if (previous == current) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        if (state is ChatPickImageCompletedState) {
          File imageFile = state.imageFile;
          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: context.theme.colorScheme.primary, width: 1),
                  borderRadius: BorderRadius.circular(radius),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.cover,
                    height: context.height * 0.4,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.error.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      BlocProvider.of<ChatPickImageBloc>(context).add(ChatPickImageSetToInitialEvent());
                    },
                    color: Colors.white,
                    icon: Icon(
                      CupertinoIcons.clear,
                      color: context.theme.colorScheme.onError,
                    ),
                  ),
                ),
              )
            ],
          );
        }
        return const SizedBox();
      }
    );
  }
}


