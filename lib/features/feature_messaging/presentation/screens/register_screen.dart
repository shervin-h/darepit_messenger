import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flusher/core/widgets/custom_widgets.dart';
import 'package:flusher/features/feature_messaging/presentation/screens/rooms_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/register/register_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/screens/login_screen.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/widgets/custom_clipper.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const String routeName = '/register-screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  late final TextEditingController _emailController;
  late final TextEditingController _passController;
  late final TextEditingController _rePassController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passController = TextEditingController();
    _rePassController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _rePassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'به پیام‌رسانِ درِپیت 😉 خوش آمدید',
                  textAlign: TextAlign.center,
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  speed: const Duration(milliseconds: 200),
                ),
              ],

              totalRepeatCount: 4,
              pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white,
                            Colors.white,
                            Colors.white,
                            Colors.lightBlueAccent,
                          ],
                        )
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: EdgeInsets.only(top: context.height * 0.04),
                      width: context.width,
                      height: context.height * 0.4,
                      child: Lottie.asset('assets/lottie/chat_animation.json'),
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: 2,
                    child: ClipPath(
                      clipper: CurveClipper3(),
                      child: RotatedBox(
                        quarterTurns: 2,
                        child: Shimmer.fromColors(
                          baseColor: context.theme.colorScheme.secondary.withOpacity(0.2),
                          highlightColor: context.theme.colorScheme.secondary,
                          period: const Duration(seconds: 3),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            alignment: Alignment.center,
                            width: context.width,
                            height: context.height * 0.603,
                            color: context.theme.colorScheme.secondary.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: 2,
                    child: ClipPath(
                      clipper: CurveClipper3(),
                      child: RotatedBox(
                        quarterTurns: 2,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaY: 4,
                            sigmaX: 4,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            alignment: Alignment.topCenter,
                            width: context.width,
                            height: context.height * 0.6,
                            color: Colors.cyan,
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Theme(
                                data: context.theme.copyWith(errorColor: Colors.white),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: context.height * 0.1),
                                      // Align(
                                      //   alignment: Alignment.centerRight,
                                      //   child: Container(
                                      //     margin: EdgeInsets.only(top: context.width * 0.04, bottom: context.width * 0.02),
                                      //     width: context.width * 0.2,
                                      //     height: context.width * 0.2,
                                      //     decoration: BoxDecoration(
                                      //       shape: BoxShape.circle,
                                      //       boxShadow: [
                                      //         BoxShadow(
                                      //           color: Colors.black.withOpacity(0.4),
                                      //           blurRadius: 4,
                                      //         ),
                                      //       ],
                                      //     ),
                                      //     child: InkWell(
                                      //       onTap: () async {
                                      //         XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);
                                      //       },
                                      //       child: CircleAvatar(
                                      //         backgroundColor: context.theme.colorScheme.secondary,
                                      //         child: const Icon(CupertinoIcons.photo_camera),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      customRegistrationTextFormField(
                                        validator: (value) {
                                          if (value != null && value.trim().length < 14 || !value!.contains('@')) {
                                            return 'لطفاً فیلد ایمیل را صحیح و حداقل با 14 کاراکتر پر کنید!';
                                          }
                                          return null;
                                        },
                                        context: context,
                                        controller: _emailController,
                                        hintText: 'ایمیل',
                                        keyboardType: TextInputType.emailAddress,
                                        maxLength: 50,
                                      ),
                                      const SizedBox(height: 16),
                                      customRegistrationTextFormField(
                                        validator: (value) {
                                          if (value != null && value.trim().length < 6) {
                                            return 'لطفاً فیلد رمز عبور را حداقل با شش کاراکتر پر کنید!';
                                          }
                                          return null;
                                        },
                                        context: context,
                                        controller: _passController,
                                        hintText: 'رمز عبور',
                                        obscureText: true,
                                        maxLength: 50,
                                      ),
                                      const SizedBox(height: 16),
                                      customRegistrationTextFormField(
                                        validator: (value) {
                                          if (value != null && value.trim().length < 6) {
                                            return 'لطفاً فیلد تکرار رمز عبور را حداقل با شش کاراکتر پر کنید!';
                                          }
                                          return null;
                                        },
                                        context: context,
                                        controller: _rePassController,
                                        hintText: 'تکرار رمز عبور',
                                        obscureText: true,
                                        maxLength: 50,
                                      ),
                                      const SizedBox(height: 32),

                                      BlocConsumer<RegisterBloc, RegisterState>(
                                        builder: (context, state) {
                                          if (state is RegisterLoadingState) {
                                            return Container(
                                              width: context.width * 0.8,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(16)
                                              ),
                                              child: ElevatedButton(
                                                onPressed: null,
                                                style: ButtonStyle(
                                                  elevation: MaterialStateProperty.all<double>(16),
                                                ),
                                                child: Center(
                                                  child: CupertinoActivityIndicator(
                                                    color: context.theme.colorScheme.onPrimary,
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else if (state is RegisterCompletedState) {
                                            return Container(
                                              width: context.width * 0.8,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(16)
                                              ),
                                              child: ElevatedButton(
                                                onPressed: null,
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                                  elevation: MaterialStateProperty.all<double>(16),
                                                ),
                                                child: const Text('ثبت نام موفق'),
                                              ),
                                            );
                                          } else if (state is RegisterErrorState) {
                                            if (state.errorMessage.contains('email-already-in-use') ||
                                                state.errorMessage.contains('User already registered') ||
                                                state.errorMessage.contains('already')) {
                                              return Container(
                                                width: context.width * 0.8,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(16)
                                                ),
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    _authUser();
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all<Color>(context.theme.colorScheme.primary),
                                                    elevation: MaterialStateProperty.all<double>(16),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text('ایمیل از قبل وجود دارد!', style: context.textTheme.button!.copyWith(color: context.theme.colorScheme.onPrimary),),
                                                      const SizedBox(width: 8),
                                                      Icon(CupertinoIcons.arrow_2_circlepath, color: context.theme.colorScheme.onError,),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                            return Container(
                                              width: context.width * 0.8,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(16)
                                              ),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  _authUser();
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.all<Color>(context.theme.colorScheme.error),
                                                  elevation: MaterialStateProperty.all<double>(16),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('تلاش دوباره', style: context.textTheme.button!.copyWith(color: context.theme.colorScheme.onError),),
                                                    const SizedBox(width: 8),
                                                    Icon(CupertinoIcons.refresh, color: context.theme.colorScheme.onError,),
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              width: context.width * 0.8,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(16)
                                              ),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  _authUser();
                                                },
                                                style: ButtonStyle(
                                                  elevation: MaterialStateProperty.all<double>(16),
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0))
                                                  ),
                                                ),
                                                child: const Text('ثبت نام'),
                                              ),
                                            );
                                          }
                                        },
                                        listener: (context, state) {
                                          if (state is RegisterCompletedState) {
                                            // Navigator.of(context).pushReplacementNamed(TempScreen.routeName);
                                            Navigator.of(context).pushReplacementNamed(RoomsScreen.routeName);
                                          }
                                          if (state is RegisterErrorState) {
                                            showCustomErrorSnackBar(context, state.errorMessage);
                                          }
                                        },
                                      ),

                                      const SizedBox(height: 16),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                                        },
                                        child: Text(
                                          'قبلاً ثبت نام کرده اید؟',
                                          style: context.textTheme.bodyText2!.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
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

  _authUser() async {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate()) {
      if (_passController.text.trim() == _rePassController.text.trim()) {
        BlocProvider.of<RegisterBloc>(context).add(
          RegisterButtonPressedEvent(
            _emailController.text.trim(),
            _passController.text.trim(),
          ),
        );
      } else {
        showCustomErrorSnackBar(context, 'رمز عبور با تکرار آن مطابقت ندارد!');
      }
    }
  }
}

InputDecoration registerTextFieldDecoration({
  required BuildContext context,
  required String hintText,
  double? radius,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      fontFamily: 'Vazir',
      color: Colors.grey.shade500,
      // fontWeight: FontWeight.bold,
    ),
    contentPadding: const EdgeInsets.all(8),
    counterText: "",
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(radius ?? 16)),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: context.theme.colorScheme.primary, width: 2), borderRadius: BorderRadius.circular(radius ?? 16)),
    enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(radius ?? 16)),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: context.theme.colorScheme.secondary, width: 2), borderRadius: BorderRadius.circular(radius ?? 16)),
  );
}

Widget customRegistrationTextFormField({
  required BuildContext context,
  required TextEditingController controller,
  required String hintText,
  double? radius,
  String? Function(String?)? validator,
  bool? obscureText,
  TextInputType? keyboardType,
  int? maxLength,
}) {
  return Material(
    elevation: 6,
    color: Colors.cyan,
    borderRadius: BorderRadius.circular(radius ?? 16),
    child: TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      style: TextStyle(
        color: Colors.grey.shade800,
        // fontWeight: FontWeight.bold,
      ),
      maxLength: maxLength,
      decoration: registerTextFieldDecoration(context: context, hintText: hintText),
    ),
  );
}
