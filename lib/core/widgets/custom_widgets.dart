import 'package:flusher/features/feature_messaging/presentation/bloc/chat/chat_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/delete_message_status.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/rooms/search/search_rooms_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class LoadingWidget extends StatelessWidget {
  const LoadingWidget({this.lottieAsset, Key? key}) : super(key: key);

  final String? lottieAsset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/lottie/${lottieAsset ?? 'chat3.json'}',
        width: context.width * 0.4,
        height: context.height * 0.4,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({this.size, this.color1, this.color2, this.color3, Key? key}) : super(key: key);

  final double? size;
  final Color? color1;
  final Color? color2;
  final Color? color3;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.discreteCircle(
        color: color1 ?? context.theme.colorScheme.primary,
        secondRingColor: color2 ?? context.theme.colorScheme.secondary,
        thirdRingColor: color3 ?? Colors.white,
        size: size ?? context.width * 0.16,
      ),
    );
  }
}

class CustomCupertinoProgressWidget extends StatelessWidget {
  const CustomCupertinoProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(
        color: context.theme.colorScheme.primary,
      ),
    );
  }
}

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    required this.errorMessage,
    this.refreshButtonOnTap,
    this.refreshButtonText,
    Key? key,
  }) : super(key: key);

  final String errorMessage;
  final void Function()? refreshButtonOnTap;
  final String? refreshButtonText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Lottie.asset(
              'assets/lottie/error.json',
              width: context.width * 0.4,
              height: context.height * 0.4,
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: context.textTheme.bodyText1!.copyWith(
              color: context.theme.colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          (refreshButtonOnTap != null && refreshButtonText != null)
              ? ElevatedButton(
                  onPressed: refreshButtonOnTap,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(context.theme.colorScheme.secondary)
                  ),
                  child: Text(refreshButtonText!),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class CustomDialogWidget extends StatelessWidget {
  const CustomDialogWidget({
    this.title,
    required this.message,
    required this.lottiePath,
    required this.onConfirmed,
    required this.confirmText,
    this.confirmBackgroundColor,
    this.confirmForegroundColor,
    this.cancelBackgroundColor,
    this.cancelForegroundColor,
    this.cancelText,
    Key? key,
  }) : super(key: key);

  final String? title;
  final String message;
  final String lottiePath;
  final String confirmText;
  final String? cancelText;
  final void Function()? onConfirmed;
  final Color? confirmBackgroundColor;
  final Color? confirmForegroundColor;
  final Color? cancelBackgroundColor;
  final Color? cancelForegroundColor;

  @override
  Widget build(BuildContext context) {
    double radius = 16;
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: context.width * 0.8,
            height: context.height * 0.4,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(radius)),
            child: Column(
              children: [
                if (title != null)
                    Text(title!, style: context.textTheme.headline6),
                Expanded(child: Lottie.asset(lottiePath, /*fit: BoxFit.fitWidth*/)),
                const SizedBox(height: 16),
                Text(message, style: context.textTheme.subtitle1),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onConfirmed,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              confirmBackgroundColor ?? context.theme.colorScheme.primary),
                          foregroundColor: MaterialStateProperty.all<Color?>(confirmForegroundColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius))),
                        ),
                        child: Text(
                          confirmText,
                          style: context.textTheme.bodyText1!.copyWith(color: context.theme.colorScheme.onPrimary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(cancelBackgroundColor ?? context.theme.colorScheme.primary),
                          foregroundColor: MaterialStateProperty.all<Color?>(cancelForegroundColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius))),
                        ),
                        child: Text(
                          cancelText ?? 'منصرف شدم',
                          style: context.textTheme.bodyText1!.copyWith(color: context.theme.colorScheme.onPrimary),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

          BlocConsumer<ChatBloc, ChatState>(
            listenWhen: (previous, current) {
              if (previous.deleteMessageStatus == current.deleteMessageStatus) {
                return false;
              }
              return true;
            },
            listener: (context, state) {
              if (state.deleteMessageStatus is DeleteMessageCompletedStatus) {
                showCustomSuccessSnackBar(context, 'با موفقیت حذف شد');
                Navigator.of(context).pop();
              }
              if (state.deleteMessageStatus is DeleteMessageErrorStatus) {
                showCustomErrorSnackBar(context, (state.deleteMessageStatus as DeleteMessageErrorStatus).errorMessage);
                Navigator.of(context).pop();
              }

            },
            buildWhen: (previous, current) {
              if (previous.deleteMessageStatus == current.deleteMessageStatus) {
                return false;
              }
              return true;
            },
            builder: (context, state) {
              if (state.deleteMessageStatus is DeleteMessageLoadingStatus) {
                return Container(
                  width: context.width * 0.8,
                  height: context.height * 0.4,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  child: const LoadingAnimation(),
                );
              }
              return Container();
            }
          )
        ],
      ),
    );
  }
}

class NeumorphicTextField extends StatelessWidget {
  const NeumorphicTextField({
    required this.controller,
    required this.hintText,
    required this.backgroundColor,
    this.textDirection,
    this.keyboardType,
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final Color backgroundColor;
  final TextDirection? textDirection;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.concave, // concave: مقعر  -  convex: محدب
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
        depth: -4,
        lightSource: LightSource.topLeft,
        color: backgroundColor,
        shadowDarkColor: Colors.black.withOpacity(0.6),
        shadowLightColor: Colors.black.withOpacity(0.6),
      ),
      child: SizedBox(
        width: context.width * 0.7,
        child: TextField(
          controller: controller,
          textDirection: textDirection,
          keyboardType: keyboardType,
          cursorColor: context.theme.colorScheme.secondary,
          style: context.textTheme.bodyText1!.copyWith(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

/// Show custom SnackBars
void showCustomErrorSnackBar(BuildContext context, String errorMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: context.theme.colorScheme.error,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Text(
        errorMessage,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: context.textTheme.bodyText2!.copyWith(
          color: context.theme.colorScheme.onError,
          fontWeight: FontWeight.bold,
        ),
      ),
    )
  );
}

void showCustomInfoSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.lightBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          message,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: context.textTheme.bodyText2!.copyWith(
            color: context.theme.colorScheme.onError,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
  );
}

void showCustomSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          message,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: context.textTheme.bodyText2!.copyWith(
            color: context.theme.colorScheme.onError,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
  );
}

showCustomAmazingSnackBar({
  required BuildContext context,
  required String message,
  required Color backgroundColor,
  required Color onBackgroundColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          message,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: context.textTheme.bodyText2!.copyWith(
            color: onBackgroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
  );
}
/// End of custom SnackBars


/// Custom Expansion Tile StatefulWidget
class CustomSearchTile extends StatefulWidget {
  const CustomSearchTile({required this.controller, this.hintText, Key? key}) : super(key: key);

  final TextEditingController controller;
  final String? hintText;

  @override
  State<CustomSearchTile> createState() => CustomSearchTileState();
}

class CustomSearchTileState extends State<CustomSearchTile> {
  bool _isVisible = false;

  void onVisibilityChanged() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void isVisible(bool b) {
    setState(() {
      _isVisible = b;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isVisible,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: context.textTheme.bodyText1!.copyWith(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            if (widget.controller.text.trim().isNotEmpty) {
              BlocProvider.of<SearchRoomsBloc>(context).add(SearchRoomsByNameEvent(widget.controller.text.trim()));
            } else {
              showCustomErrorSnackBar(context, 'لطفاً نام اتاق را صحیح وارد کنید !');
            }
          },
          padding: const EdgeInsets.all(16),
          icon: Icon(CupertinoIcons.search, color: context.theme.colorScheme.primary,),
        ),
      ),
    );
  }
}
/// End of Custom Expansion Tile StatefulWidget
