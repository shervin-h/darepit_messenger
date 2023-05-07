import 'dart:io';

import 'package:flusher/config/app_settings.dart';
import 'package:flusher/core/widgets/custom_widgets.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/rooms/drawer/rooms_drawer_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/rooms/rooms_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/rooms/search/search_rooms_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/rooms/visited_rooms/visited_rooms_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/screens/my_rooms_tab_screen.dart';
import 'package:flusher/features/feature_messaging/presentation/screens/recent_visits_rooms_tab_screen.dart';
import 'package:flusher/screens/coming_soon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../screens/about_me_screen.dart';
import '../../domain/usecases/sign_out_supabase_use_case.dart';
import '../widgets/drawer_header_widget.dart';
import 'chat_settings_screen.dart';
import 'login_screen.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({Key? key}) : super(key: key);

  static const String routeName = '/rooms-screen';

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  late final TextEditingController _searchController;
  late final User? _currentUser;

  final _expansionKey = GlobalKey<CustomSearchTileState>(debugLabel: '_customSearchTileKey');

  final List<Widget> _tabs = const [
    Tab(
      text: 'اتاق های شما',
    ),
    Tab(
      text: 'بازدید های اخیر',
    ),
  ];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController = TextEditingController();
    _currentUser = supabase.auth.currentUser;
    if (_currentUser != null && _currentUser!.email != null && _currentUser!.email!.trim().isNotEmpty) {
      BlocProvider.of<RoomsBloc>(context).add(RoomsStartedEvent(supabase.auth.currentUser!.email));
      BlocProvider.of<VisitedRoomsBloc>(context).add(VisitedRoomsStartedEvent());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _isExpanded() {
    _tabController.animateTo(1);
    _searchController.clear();
    if (_expansionKey.currentState != null) {
      BlocProvider.of<SearchRoomsBloc>(context).add(SearchRoomsCollapsedEvent());
      _expansionKey.currentState!.isVisible(false);
    }
  }

  void _isCollapsed() {
    _tabController.animateTo(1);
    _searchController.clear();
    if (_expansionKey.currentState != null) {
      BlocProvider.of<SearchRoomsBloc>(context).add(SearchRoomsExpandedEvent());
      _expansionKey.currentState!.isVisible(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Lottie.asset('assets/lottie/exit_1.json'),
              content: Text(
                'از پیام‌رسان خارج می شوید؟',
                style: context.textTheme.bodyText1!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    exit(0);
                  },
                  child: Text(
                    'بله',
                    style: context.textTheme.button!.copyWith(
                      color: context.theme.colorScheme.secondary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'خیر',
                    style: context.textTheme.button!.copyWith(
                      color: context.theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            );
          },
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('اتاق ها'),
          centerTitle: true,
          actions: [
            BlocBuilder<SearchRoomsBloc, SearchRoomsState>(
              buildWhen: (previous, current) {
                if (previous.isExpanded == current.isExpanded) {
                  return false;
                }
                return true;
              },
              builder: (context, state) {
                return IconButton(
                  onPressed: state.isExpanded ? _isExpanded : _isCollapsed,
                  icon: state.isExpanded ? const Icon(CupertinoIcons.clear) : const Icon(CupertinoIcons.search),
                );
              },
            ),
          ],
          bottom: TabBar(
            tabs: _tabs,
            controller: _tabController,
            indicatorColor: context.theme.colorScheme.secondary,
          ),
        ),
        drawer: Drawer(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              BlocBuilder<RoomsDrawerBloc, RoomsDrawerState>(
                buildWhen: (previous, current) {
                  if (previous == current) {
                    return false;
                  }
                  return true;
                },
                builder: (context, state) {
                  if (state is RoomsDrawerProfileImageLoadingState) {
                    return DrawerHeaderWidget(
                      pickImageButtonOnPressed: null,
                      editButtonOnPressed: null,
                      pickButtonText: 'در حال پردازش',
                      editButtonText: 'ویرایش پروفایل',
                      username: (AppSettings.username.isNotEmpty) ? AppSettings.username : _currentUser?.email,
                    );
                  } else if (state is RoomsDrawerProfileImageCompletedState) {
                    final encoded = state.encoded;
                    return DrawerHeaderWidget(
                      pickImageButtonOnPressed: () {
                        BlocProvider.of<RoomsDrawerBloc>(context).add(PickProfileImageEvent());
                      },
                      editButtonOnPressed: null,
                      pickButtonText: 'تغییر تصویر نمایه',
                      editButtonText: 'ویرایش پروفایل',
                      encoded: encoded,
                      username: (AppSettings.username.isNotEmpty) ? AppSettings.username : _currentUser?.email,
                    );
                  } else if (state is RoomsDrawerProfileImageErrorState) {
                    return Container(
                    color: Colors.black12,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DrawerHeaderWidget(
                          pickImageButtonOnPressed: () {
                            BlocProvider.of<RoomsDrawerBloc>(context).add(PickProfileImageEvent());
                          },
                          editButtonOnPressed: null,
                          pickButtonText: 'افزودن تصویر نمایه',
                          editButtonText: 'ویرایش پروفایل',
                          username: (AppSettings.username.isNotEmpty) ? AppSettings.username : _currentUser?.email,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          state.errorMessage,
                          style: context.textTheme.button!.copyWith(color: context.theme.colorScheme.error),
                        ),
                      ],
                    ),
                  );
                  } else {
                    return DrawerHeaderWidget(
                    pickImageButtonOnPressed: () {
                      BlocProvider.of<RoomsDrawerBloc>(context).add(PickProfileImageEvent());
                    },
                    editButtonOnPressed: null,
                    pickButtonText: 'افزودن تصویر نمایه',
                    editButtonText: 'ویرایش پروفایل',
                    username: (AppSettings.username.isNotEmpty) ? AppSettings.username : _currentUser?.email,
                    encoded: AppSettings.profileImage,
                  );
                  }
                },
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(ChatSettingsScreen.routeName);
                },
                leading: Lottie.asset('assets/lottie/gear_settings.json',
                    height: context.width * 0.14, width: context.width * 0.14, fit: BoxFit.fitHeight),
                title: const Text('تنظیمات'),
              ),
              ListTile(
                onTap: () {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) {
                      return CustomDialogWidget(
                        message: 'از حساب خود خارج می شوید؟',
                        lottiePath: 'assets/lottie/exit.json',
                        confirmBackgroundColor: context.theme.colorScheme.secondary,
                        cancelBackgroundColor: context.theme.colorScheme.primary,
                        onConfirmed: () {
                          SignOutSupabaseUseCase()().then((DataState<bool> dataState) {
                            if (dataState is DataSuccess) {
                              Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
                            }
                            if (dataState is DataFailed) {
                              showCustomErrorSnackBar(context, dataState.error!);
                            }
                          });
                        },
                        confirmText: 'بله',
                      );
                    },
                  );
                },
                leading: Lottie.asset('assets/lottie/exit.json',
                    height: context.width * 0.14, width: context.width * 0.14, fit: BoxFit.fitHeight),
                title: const Text('خروج'),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(AboutMeScreen.routeName);
                },
                leading: Lottie.asset('assets/lottie/man_on_laptop_browsing.json',
                    height: context.width * 0.14, width: context.width * 0.14, fit: BoxFit.fitHeight),
                title: const Text('درباره من'),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(ComingSoonScreen.routeName);
                },
                leading: Lottie.asset('assets/lottie/coming_soon.json',
                    height: context.width * 0.14, width: context.width * 0.14, fit: BoxFit.fitHeight),
                title: const Text('به زودی ...'),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            physics: const BouncingScrollPhysics(),
            controller: _tabController,
            children: [
              const MyRoomsTabScreen(),
              RecentVisitsRoomsTabScreen(searchController: _searchController, expansionKey: _expansionKey)
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// 💒 📜 📝 📋 🚪 🏡 🏫
