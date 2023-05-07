import 'dart:io';
import 'package:flusher/core/utils/constants.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/chat_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/chat_item_settings/chat_item_settings_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/pick_image/chat_pick_image_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/wallpaper_selection/wallpaper_selection_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/profile/edit_profile_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/register/register_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/rooms/drawer/rooms_drawer_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/rooms/rooms_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/rooms/search/search_rooms_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/rooms/visited_rooms/visited_rooms_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/screens/chat_settings_screen.dart';
import 'package:flusher/features/feature_messaging/presentation/screens/edit_profile_screen.dart';
import 'package:flusher/features/feature_messaging/presentation/screens/rooms_screen.dart';
import 'package:flusher/features/feature_messaging/presentation/screens/wallpaper_selection_screen.dart';
import 'package:flusher/locator.dart';
import 'package:flusher/screens/about_me_screen.dart';
import 'package:flusher/screens/coming_soon.dart';
import 'package:flusher/screens/splash/splash_bloc.dart';
import 'package:flusher/screens/splash/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'config/app_theme.dart';
import 'features/feature_messaging/presentation/bloc/login/login_bloc.dart';
import 'features/feature_messaging/presentation/screens/chat_screen.dart';
import 'features/feature_messaging/presentation/screens/login_screen.dart';
import 'features/feature_messaging/presentation/screens/register_screen.dart';
import 'features/feature_messaging/presentation/screens/temp_screen.dart';

/*
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  debugPrint("Handling a background message: ${message.messageId}");
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /*
  /// //////////////// ///
  /// Firebase Section ///
  /// //////////////// ///
  final firebaseApp = await Firebase.initializeApp();
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // debugPrint('Firebase Cloud Messaging - FCM Token: $fcmToken');

  /// handle background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// handle foreground messages
  if (Platform.isAndroid) {

    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('ic_launcher'),
      ),
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification}');

        RemoteNotification notification = message.notification!;
        AndroidNotification? android = message.notification!.android;

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.
        if (android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
                // other properties...
              ),
            ),
          );
        }
      }
    });
  }

  if (Platform.isIOS) {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }
  /// /////////////////////// ///
  /// End of Firebase Section ///
  /// /////////////////////// ///

   */

  await Supabase.initialize(
    url: AppConstant.projectURL,
    anonKey: AppConstant.anonPublicApiKey,
  );

  setup();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SplashBloc>(create: (context) => getIt<SplashBloc>()),
        BlocProvider<RegisterBloc>(create: (context) => getIt<RegisterBloc>()),
        BlocProvider<LoginBloc>(create: (context) => getIt<LoginBloc>()),
        BlocProvider<RoomsBloc>(create: (context) => getIt<RoomsBloc>()),
        BlocProvider<RoomsDrawerBloc>(create: (context) => getIt<RoomsDrawerBloc>()),
        BlocProvider<ChatBloc>(create: (context) => getIt<ChatBloc>()),
        BlocProvider<WallpaperSelectionBloc>(create: (context) => getIt<WallpaperSelectionBloc>()),
        BlocProvider<ChatItemSettingsBloc>(create: (context) => getIt<ChatItemSettingsBloc>()),
        BlocProvider<SearchRoomsBloc>(create: (context) => getIt<SearchRoomsBloc>()),
        BlocProvider<VisitedRoomsBloc>(create: (context) => getIt<VisitedRoomsBloc>()),
        BlocProvider<EditProfileBloc>(create: (context) => getIt<EditProfileBloc>()),
        BlocProvider<ChatPickImageBloc>(create: (context) => getIt<ChatPickImageBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'پیام‌رسان درپیت ⭐',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('fa'), // Farsi
      ],
      locale: const Locale('fa'),
      theme: AppTheme.lightThemeData,
      darkTheme: AppTheme.darkThemeData,
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case SplashScreen.routeName:
            return CupertinoPageRoute(builder: (context) => const SplashScreen());
          case LoginScreen.routeName:
            return CupertinoPageRoute(builder: (context) => const LoginScreen());
          case RegisterScreen.routeName:
            return CupertinoPageRoute(builder: (context) => const RegisterScreen());
          case TempScreen.routeName:
            return CupertinoPageRoute(builder: (context) => const TempScreen());
          case RoomsScreen.routeName:
            return CupertinoPageRoute(builder: (context) => const RoomsScreen());
          case ChatScreen.routeName:
            return CupertinoPageRoute(builder: (context) => const ChatScreen());
          case ChatSettingsScreen.routeName:
            return CupertinoPageRoute(builder: (context) => const ChatSettingsScreen());
          case WallpaperSelectionScreen.routeName:
            return CupertinoPageRoute(builder: (context) => WallpaperSelectionScreen());
          case AboutMeScreen.routeName:
            return CupertinoPageRoute(builder: (context) => const AboutMeScreen());
          case ComingSoonScreen.routeName:
            return CupertinoPageRoute(builder: (context) => const ComingSoonScreen());
          case EditProfileScreen.routeName:
            return CupertinoPageRoute(builder: (context) => const EditProfileScreen());

          default:
            return CupertinoPageRoute(builder: (context) => const HomeScreen());
        }
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
