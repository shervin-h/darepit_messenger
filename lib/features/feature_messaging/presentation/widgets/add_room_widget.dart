import 'dart:convert';

import 'package:flusher/config/app_settings.dart';
import 'package:flusher/core/params/add_room_params.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/rooms/rooms_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/helper.dart';
import '../../../../core/widgets/custom_widgets.dart';

class AddRoomDialogWidget extends StatefulWidget {
  const AddRoomDialogWidget({Key? key}) : super(key: key);

  @override
  State<AddRoomDialogWidget> createState() => _AddRoomDialogWidgetState();
}

class _AddRoomDialogWidgetState extends State<AddRoomDialogWidget> {
  late final TextEditingController _roomNameController;
  late final TextEditingController _roomDescriptionController;

  String? encodedRoomImage;


  bool _isPrivate = false;

  var uuid = const Uuid();
  String _generateUUId() {
    // Generate a v5 (namespace-name-sha1-based) id
    return uuid.v5(Uuid.NAMESPACE_URL, 'shervin.hassanzadeh.flusher?user:${AppSettings.userId}&email:${Supabase.instance.client.auth.currentUser?.email}&timestamp:${DateTime.now().microsecondsSinceEpoch.toString().substring(8, 12)}');
  }

  @override
  void initState() {
    super.initState();
    _roomNameController = TextEditingController();
    _roomDescriptionController = TextEditingController();
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
                  alignment: Alignment.center,
                  children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              encodedRoomImage =
                              await pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512, quality: 70);
                              setState(() {});
                            },
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              width: context.width * 0.36,
                              height: context.width * 0.36,
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
                                    width: context.width * 0.36,
                                    height: context.height * 0.36,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: (encodedRoomImage != null)
                                          ? DecorationImage(
                                        image: MemoryImage(base64Decode(encodedRoomImage!)),
                                        fit: BoxFit.cover,
                                      )
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          NeumorphicTextField(
                            controller: _roomNameController,
                            backgroundColor: backgroundColor,
                            textDirection: TextDirection.rtl,
                            hintText: 'نام اتاق',
                          ),
                          const SizedBox(height: 16),
                          NeumorphicTextField(
                            controller: _roomDescriptionController,
                            backgroundColor: backgroundColor,
                            textDirection: TextDirection.rtl,
                            hintText: 'توضیحات اتاق (اختیاری)',
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16 ,8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'اتاق خصوصی ایجاد می کنید؟',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.textTheme.bodyText1!.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                NeumorphicSwitch(
                                  style: NeumorphicSwitchStyle(
                                    // trackDepth: 8,
                                    inactiveTrackColor: backgroundColor,
                                    activeTrackColor: context.theme.colorScheme.primary,
                                    inactiveThumbColor: Colors.grey.shade400,
                                    activeThumbColor: Colors.grey.shade400,

                                  ),
                                  value: _isPrivate,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _isPrivate = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_roomNameController.text.trim().isNotEmpty) {
                                        BlocProvider.of<RoomsBloc>(context).add(
                                          AddRoomEvent(
                                            AddRoomParams(
                                              userId: AppSettings.userId,
                                              name: _roomNameController.text.trim(),
                                              description: _roomDescriptionController.text.trim(),
                                              image: encodedRoomImage ?? '',
                                              isPrivate: _isPrivate,
                                              privateKey: _generateUUId(),
                                            ),
                                          ),
                                        );
                                        // Navigator.of(context).pop();
                                      } else {
                                        showCustomErrorSnackBar(context, 'لطفاً نام اتاق را وارد نمایید !');
                                      }
                                    },
                                    child: const Text('ایجاد اتاق'),
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


