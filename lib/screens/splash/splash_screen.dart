import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flusher/core/widgets/custom_widgets.dart';
import 'package:flusher/features/feature_messaging/presentation/screens/login_screen.dart';
import 'package:flusher/features/feature_messaging/presentation/screens/rooms_screen.dart';
import 'package:flusher/screens/splash/splash_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/resources/data_state.dart';
import '../../core/widgets/custom_clipper.dart';
import '../../features/feature_messaging/domain/usecases/get_user_from_db_use_case.dart';
import '../../features/feature_messaging/presentation/screens/register_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = '/splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SplashBloc>(context).add(SplashStartedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'به پیام‌رسانِ درِپیت 😉 خوش آمدید',
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  speed: const Duration(milliseconds: 150),
                ),
              ],

              totalRepeatCount: 4,
              pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
            Expanded(
              child: BlocConsumer<SplashBloc, SplashState>(
                builder: (context, state) {
                  if (state is SplashLoadingState) {
                    return const LoadingWidget(lottieAsset: 'chat4.json');
                  } else if (state is SplashCompletedState) {
                    return const LoadingWidget(lottieAsset: 'chat4.json');
                  } else if (state is SplashErrorState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/lottie/error.json',
                            width: context.width * 0.4,
                            height: context.width * 0.4,
                            fit: BoxFit.fitWidth,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.errorMessage,
                            style: context.textTheme.bodyText2!.copyWith(
                              color: context.theme.colorScheme.error,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<SplashBloc>(context).add(SplashStartedEvent());
                            },
                            child: const Icon(CupertinoIcons.refresh),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
                listener: (context, state) {
                  if (state is SplashCompletedState) {
                    Future.delayed(
                      const Duration(seconds: 1, milliseconds: 500),
                        () async {
                          GetUserFromDbUseCase()().then((DataState<Map<String, dynamic>> dataState) {
                            if (dataState is DataSuccess) {
                              if (dataState.data != null && (dataState.data as Map<String, dynamic>)['logout']) {
                                // logout is true
                                Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                              } else {
                                // logout is false
                                Navigator.of(context).pushReplacementNamed(RoomsScreen.routeName);
                              }
                            } else if (dataState is DataFailed) {
                              Navigator.of(context).pushReplacementNamed(RegisterScreen.routeName);
                            } else {
                              Navigator.of(context).pushReplacementNamed(RegisterScreen.routeName);
                            }
                          });
                        },
                    );
                  }
                },
              ),
            ),
            RotatedBox(
              quarterTurns: 2,
              child: ClipPath(
                clipper: CurveClipper5(),
                child: Container(
                  width: context.width,
                  height: context.height * 0.1,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                  ),
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: Column(
                      children: [
                        SizedBox(height:  1/5 * (context.height * 0.1) ),
                        Text(
                          'by Shervin Hassanzadeh',
                          style: context.textTheme.bodyText1!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        FutureBuilder<PackageInfo>(
                          future: PackageInfo.fromPlatform(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              final packageInfo = snapshot.data!;
                              return Text(
                                'version ${packageInfo.version}',
                                style: context.textTheme.caption!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade400,
                                ),
                              );
                            } else {
                              return Text(
                                'version 1.0.0',
                                style: context.textTheme.caption!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade400,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
