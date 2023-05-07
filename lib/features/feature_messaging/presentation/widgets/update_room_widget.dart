import 'dart:convert';

import 'package:flusher/core/params/add_room_params.dart';
import 'package:flusher/features/feature_messaging/domain/entities/room_entity.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/rooms/rooms_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/params/update_room_params.dart';
import '../../../../core/utils/helper.dart';
import '../../../../core/widgets/custom_widgets.dart';

class UpdateRoomDialogWidget extends StatefulWidget {
  const UpdateRoomDialogWidget({required this.roomEntity, Key? key}) : super(key: key);

  final RoomEntity roomEntity;

  @override
  State<UpdateRoomDialogWidget> createState() => _UpdateRoomDialogWidgetState();
}

class _UpdateRoomDialogWidgetState extends State<UpdateRoomDialogWidget> {
  late final TextEditingController _roomNameController;
  late final TextEditingController _roomDescriptionController;

  String? encodedRoomImage;

  @override
  void initState() {
    super.initState();
    _roomNameController = TextEditingController();
    _roomNameController.text = widget.roomEntity.name;
    _roomDescriptionController = TextEditingController();
    _roomDescriptionController.text = widget.roomEntity.description;
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    _roomDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.grey;
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
                  color: backgroundColor,
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            encodedRoomImage =
                            await pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512, quality: 70);
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.all(24),
                            width: context.width * 0.4,
                            height: context.width * 0.4,
                            decoration: BoxDecoration(
                              color: context.theme.colorScheme.secondary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: encodedRoomImage != null
                                      ? context.theme.colorScheme.secondary.withOpacity(0.4)
                                      : Colors.black.withOpacity(0.4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.photo,
                                      color: context.theme.colorScheme.onSecondary,
                                      size: context.width * 0.1,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'اضافه کردن عکس',
                                      style: context.textTheme.bodyMedium!.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: context.width * 0.4,
                                  height: context.height * 0.4,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: (encodedRoomImage != null)
                                        ? DecorationImage(
                                            image: MemoryImage(base64Decode(encodedRoomImage!)),
                                            fit: BoxFit.cover,
                                          )
                                        : widget.roomEntity.roomImage.isNotEmpty
                                            ? DecorationImage(
                                                image: MemoryImage(base64Decode(widget.roomEntity.roomImage)),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        NeumorphicTextField(
                          controller: _roomNameController,
                          backgroundColor: backgroundColor,
                          textDirection: TextDirection.rtl,
                          hintText: 'نام اتاق',
                        ),
                        NeumorphicTextField(
                          controller: _roomDescriptionController,
                          backgroundColor: backgroundColor,
                          textDirection: TextDirection.rtl,
                          hintText: 'توضیحات اتاق (اختیاری)',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    BlocProvider.of<RoomsBloc>(context).add(
                                      UpdateRoomEvent(
                                        UpdateRoomParams(
                                          roomId: widget.roomEntity.roomId,
                                          name: _roomNameController.text.trim().isEmpty ? widget.roomEntity.name : _roomNameController.text.trim(),
                                          description: _roomDescriptionController.text.trim().isEmpty ? widget.roomEntity.description : _roomDescriptionController.text.trim(),
                                          image: encodedRoomImage ?? widget.roomEntity.roomImage,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('به روز رسانی'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('بازگشت'),
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
                        }
                        return Container();
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


