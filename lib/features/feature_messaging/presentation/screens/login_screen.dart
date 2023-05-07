import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flusher/core/widgets/custom_widgets.dart';
import 'package:flusher/features/feature_messaging/presentation/screens/rooms_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/login/login_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/register/register_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/screens/chat_screen.dart';
import 'package:flusher/features/feature_messaging/presentation/screens/register_screen.dart';
import 'package:flusher/features/feature_messaging/presentation/screens/temp_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/widgets/custom_clipper.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String routeName = '/login-screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  late final TextEditingController _emailController;
  late final TextEditingController _passController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passController = TextEditingController();

    BlocProvider.of<LoginBloc>(context).add(LoginStartedEvent());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
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
                  'ورود به پیام‌رسانِ درِپیت 😉',
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
                      height: context.height * 0.3,
                      alignment: Alignment.center,
                      child: Lottie.asset('assets/lottie/chat.json'),
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

                                      customRegistrationTextFormField(
                                        validator: (value) {
                                          if (value != null && value.trim().length < 3) {
                                            return 'لطفاً فیلد نام کاربری را حداقل با سه کاراکتر پر کنید!';
                                          }
                                          return null;
                                        },
                                        context: context,
                                        controller: _emailController,
                                        hintText: 'ایمیل',
                                        keyboardType: TextInputType.emailAddress,
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
                                      ),

                                      const SizedBox(height: 32),

                                      BlocConsumer<LoginBloc, LoginState>(
                                        builder: (context, state) {
                                          if (state is LoginLoadingState) {
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
                                          } else if (state is LoginCompletedState) {
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
                                                child: const Text('ورود موفق'),
                                              ),
                                            );
                                          } else if (state is LoginErrorState) {
                                            return Container(
                                              width: context.width * 0.8,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(16)
                                              ),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  _loginUser(context);
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
                                                  _loginUser(context);
                                                },
                                                style: ButtonStyle(
                                                  elevation: MaterialStateProperty.all<double>(16),
                                                ),
                                                child: const Text('ورود'),
                                              ),
                                            );
                                          }
                                        },
                                        listener: (context, state) {
                                          if (state is LoginCompletedState) {
                                            // Navigator.of(context).pushReplacementNamed(TempScreen.routeName);
                                            Navigator.of(context).pushReplacementNamed(RoomsScreen.routeName);
                                          }
                                          if (state is LoginErrorState) {
                                            showCustomErrorSnackBar(context, state.errorMessage);
                                          }
                                        },
                                      ),

                                      const SizedBox(height: 16),

                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pushReplacementNamed(RegisterScreen.routeName);
                                        },
                                        child: Text(
                                          'ثبت نام نکرده اید؟',
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

  _loginUser(BuildContext context) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      BlocProvider.of<LoginBloc>(context).add(LoginButtonPressedEvent(_emailController.text.trim(), _passController.text.trim()));
    }
  }
}
