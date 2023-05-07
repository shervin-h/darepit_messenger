import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:flusher/core/utils/constants.dart';
import 'package:flusher/features/feature_messaging/domain/entities/user_entity.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/enter_the_chat_room_use_case.dart';
import 'package:flusher/features/feature_messaging/presentation/screens/chat_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/resources/data_state.dart';

class TempScreen extends StatefulWidget {
  const TempScreen({Key? key}) : super(key: key);

  static const String routeName = '/temp-screen';

  @override
  State<TempScreen> createState() => _TempScreenState();
}

class _TempScreenState extends State<TempScreen> {

  late TextEditingController _roomController;

  @override
  void initState() {
    super.initState();
    _roomController = TextEditingController();
  }

  @override
  void dispose() {
    _roomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.grey,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'نام اتاق را وارد کنید :)',
                style: context.textTheme.bodyText1!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: context.height * 0.2),
              Neumorphic(
                style: NeumorphicStyle(
                  shape: NeumorphicShape.concave, // concave: مقعر  -  convex: محدب
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
                  depth: -4,
                  lightSource: LightSource.topLeft,
                  color: Colors.grey,
                  shadowDarkColor: Colors.black.withOpacity(0.6),
                  shadowLightColor: Colors.black.withOpacity(0.6),
                ),
                child: SizedBox(
                  width: context.width * 0.7,
                  child: TextField(
                    controller: _roomController,
                    textDirection: TextDirection.ltr,
                    cursorColor: context.theme.colorScheme.secondary,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.height * 0.1),
              SizedBox(
                width: context.width * 0.6,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_roomController.text.trim().isNotEmpty &&
                        AppConstant.availableRooms.contains(_roomController.text.trim())) {
                      await EnterTheChatRoomUseCase()(_roomController.text.trim()).then((DataState<User> dataState) {
                        if (dataState is DataSuccess && dataState.data != null) {
                          // Navigator.of(context).pushReplacementNamed(ChatScreen.routeName, arguments: dataState.data!);
                          Navigator.of(context).pushReplacementNamed(ChatScreen.routeName, arguments: 1);
                        }
                        if (dataState is DataFailed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                elevation: 4,
                                backgroundColor: context.theme.colorScheme.error,
                                content: Text(
                                  dataState.error!,
                                  style: context.textTheme.bodyText2!.copyWith(
                                    color: context.theme.colorScheme.onError,
                                  ),
                                ),
                              )
                          );
                          // Navigator.of(context).pushReplacementNamed(ChatScreen.routeName);
                        }
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            elevation: 4,
                            backgroundColor: context.theme.colorScheme.error,
                            content: Text(
                              'لطفاً نام اتاق را صحیح وارد کنید !',
                              style: context.textTheme.bodyText2!.copyWith(
                                color: context.theme.colorScheme.onError,
                              ),
                            ),
                          )
                      );
                    }

                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                      )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ورود به اتاق',
                        style: context.textTheme.button!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(CupertinoIcons.arrow_down_left_square)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
