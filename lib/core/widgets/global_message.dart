import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flusher/config/app_theme.dart';

import 'inner_shadow_widget.dart';

class Msg {
  static info(String title, String msg) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      msg,
      colorText: Get.theme.colorScheme.onInfoContainer,
      backgroundColor: Get.theme.colorScheme.infoContainer,
      duration: msg.length >= 50 ? 7.seconds : 4.seconds,
      isDismissible: true,
      margin: const EdgeInsets.all(12.0),
      icon: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Image.asset(
          'assets/messages/info.png',
          fit: BoxFit.fitHeight,
          height: Get.context!.isTablet ? 56 : 50,
          width: Get.context!.isTablet ? 56 : 50,
        ),
      ),
      borderColor: Get.theme.colorScheme.onInfoContainer,
      borderWidth: 1.5,
      dismissDirection: DismissDirection.vertical,
      instantInit: true,
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static warning(String title, String msg) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      msg,
      colorText: Get.theme.colorScheme.onWarningContainer,
      backgroundColor: Get.theme.colorScheme.warningContainer,
      barBlur: 15,
      duration: msg.length >= 50 ? 7.seconds : 4.seconds,
      isDismissible: true,
      margin: const EdgeInsets.all(12.0),
      icon: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Image.asset(
          'assets/messages/warning.png',
          fit: BoxFit.fitHeight,
          height: Get.context!.isTablet ? 56 : 50,
          width: Get.context!.isTablet ? 56 : 50,
        ),
      ),
      borderColor: Get.theme.colorScheme.onWarningContainer,
      borderWidth: 1.5,
      dismissDirection: DismissDirection.vertical,
      instantInit: true,
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static success(String title, String msg) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      msg,
      colorText: Get.theme.colorScheme.onSuccessContainer,
      backgroundColor: Get.theme.colorScheme.successContainer,
      duration: msg.length >= 50 ? 7.seconds : 4.seconds,
      isDismissible: true,
      margin: const EdgeInsets.all(12.0),
      icon: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Image.asset(
          'assets/messages/success.png',
          fit: BoxFit.fitHeight,
          height: Get.context!.isTablet ? 56 : 50,
          width: Get.context!.isTablet ? 56 : 50,
        ),
      ),
      borderColor: Get.theme.colorScheme.onSuccessContainer,
      borderWidth: 1.5,
      dismissDirection: DismissDirection.vertical,
      instantInit: true,
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static error(String title, String msg) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      msg,
      colorText: Get.theme.colorScheme.onErrorContainer,
      backgroundColor: Get.theme.colorScheme.errorContainer,
      duration: msg.length >= 50 ? 7.seconds : 4.seconds,
      isDismissible: true,
      margin: const EdgeInsets.all(12.0),
      icon: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Image.asset(
          'assets/messages/error.png',
          fit: BoxFit.fitHeight,
          height: Get.context!.isTablet ? 56 : 50,
          width: Get.context!.isTablet ? 56 : 50,
        ),
      ),
      borderColor: Get.theme.colorScheme.onErrorContainer,
      borderWidth: 1.5,
      dismissDirection: DismissDirection.vertical,
      instantInit: true,
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class MsgDg {
  ///نوشتن [title] و همچنین [msg] برای نمایش دیالوگ ضروری است
  ///
  /// با استفاده از [Kinds] میتوانید نوع نوع دیالوگ رو انتخاب کنید که چه حالت پیغامی به کاربر نمایش داده خواهد شد
  ///
  /// به طور پیشفرض دیالوگ یک دکمه بستن دارد که دیالوگ را می بندد اما اگر می خواید دکمه دیگری برای عملیات جدید داشته باشید کافی است یک متد به [confirmTap] بدهید. دکمه ظاهر شده و عملیات شما رو انجام میدهد
  ///
  /// همچنین شما می توانید متد جدیدی به دکمه "بستن" بدهید فقط با انتساب متد جدید به [cancelTap] که از عملیات شما پیروی می کند
  ///
  /// MsgDg.show('Message title', 'your message', kinds: [Kinds.success], confirmText: 'confirm', cancelText: 'cancel', confirmTap: ()=> foo(), cancelTap: ()=> foo2());
  static show(String title, String msg,
      {Kinds kinds = Kinds.info,
      String? confirmText,
      String? cancelText,
      Function()? cancelTap,
      Function()? confirmTap}) {
    switch (kinds) {
      case Kinds.info:
        Get.dialog(
            CustomDialog(
              title: title,
              msg: msg,
              icon: 'info',
              bcButton: Get.theme.colorScheme.infoContainer,
              fcButton: Get.theme.colorScheme.onInfoContainer,
              cancelTap: cancelTap,
              confirmTap: confirmTap,
              cancelText: cancelText,
              confirmText: confirmText,
            ),
            barrierDismissible: true);
        break;
      case Kinds.error:
        Get.dialog(
            CustomDialog(
              title: title,
              msg: msg,
              icon: 'error',
              bcButton: Get.theme.colorScheme.errorContainer,
              fcButton: Get.theme.colorScheme.onErrorContainer,
              cancelTap: cancelTap,
              confirmTap: confirmTap,
              cancelText: cancelText,
              confirmText: confirmText,
            ),
            barrierDismissible: true);
        break;
      case Kinds.success:
        Get.dialog(
            CustomDialog(
              title: title,
              msg: msg,
              icon: 'success',
              bcButton: Get.theme.colorScheme.successContainer,
              fcButton: Get.theme.colorScheme.onSuccessContainer,
              cancelTap: cancelTap,
              confirmTap: confirmTap,
              cancelText: cancelText,
              confirmText: confirmText,
            ),
            barrierDismissible: true);
        break;
      case Kinds.warning:
        Get.dialog(
            CustomDialog(
              title: title,
              msg: msg,
              icon: 'warning',
              bcButton: Get.theme.colorScheme.warningContainer,
              fcButton: Get.theme.colorScheme.onWarningContainer,
              cancelTap: cancelTap,
              confirmTap: confirmTap,
              cancelText: cancelText,
              confirmText: confirmText,
            ),
            barrierDismissible: true);
        break;
      case Kinds.question:
        Get.dialog(
            CustomDialog(
              title: title,
              msg: msg,
              icon: 'question',
              bcButton: Get.theme.colorScheme.questionContainer,
              fcButton: Get.theme.colorScheme.onQuestionContainer,
              cancelTap: cancelTap,
              confirmTap: confirmTap,
              cancelText: cancelText,
              confirmText: confirmText,
            ),
            barrierDismissible: true);
        break;
    }
  }
}

enum Kinds {
  info,
  error,
  success,
  warning,
  question,
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key? key,
    required this.title,
    required this.msg,
    required this.bcButton,
    required this.fcButton,
    required this.icon,
    this.confirmTap,
    this.cancelTap,
    this.cancelText,
    this.confirmText,
  }) : super(key: key);
  final String msg;
  final String title;
  final String? cancelText;
  final String? confirmText;
  final Function()? confirmTap;
  final Function()? cancelTap;
  final Color bcButton;
  final Color fcButton;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: Get.width * .09),
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      child: SizedBox(
        height: Get.height * .3,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: InnerShadow(
                shadows: [
                  Shadow(
                    color: Get.isDarkMode ? Colors.white24 : Colors.black26,
                    blurRadius: 9,
                    offset: const Offset(0, 7),
                  ),
                ],
                child: Container(
                  margin: EdgeInsets.only(top: Get.height * .05),
                  decoration:
                      BoxDecoration(color: Get.theme.colorScheme.background, borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints.expand(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 50.0, bottom: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: Get.textTheme.headline3
                              ?.copyWith(fontWeight: FontWeight.bold, color: Get.theme.colorScheme.onBackground),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              msg,
                              style: Get.textTheme.subtitle2?.copyWith(color: Get.theme.colorScheme.onBackground),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: OutlinedButton(
                                  onPressed: cancelTap ?? () => Get.back(),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: bcButton,
                                    // Get.theme.colorScheme.infoContainer,
                                    foregroundColor: fcButton,
                                    //Get.theme.colorScheme.onInfoContainer,
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    side: BorderSide(
                                      width: 2,
                                      strokeAlign: 2,
                                      color: fcButton,
                                    ),
                                  ),
                                  child: Text(cancelText ?? 'بستن'),
                                ),
                              ),
                            ),
                            if (confirmTap != null)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: OutlinedButton(
                                    onPressed: confirmTap,
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: fcButton, //Get.theme.colorScheme.onInfoContainer,
                                      foregroundColor: bcButton, //Get.theme.colorScheme.infoContainer,
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    child: Text(confirmText ?? 'تایید'),
                                  ),
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/messages/$icon.png',
                height: context.isTablet ? 100 : 94,
                fit: BoxFit.fitHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
