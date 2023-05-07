import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/widgets/custom_widgets.dart';
import '../bloc/rooms/rooms_bloc.dart';
import '../widgets/add_room_widget.dart';
import '../widgets/room_item_widget.dart';

class MyRoomsTabScreen extends StatefulWidget {
  const MyRoomsTabScreen({Key? key}) : super(key: key);

  @override
  State<MyRoomsTabScreen> createState() => _MyRoomsTabScreenState();
}

class _MyRoomsTabScreenState extends State<MyRoomsTabScreen> with AutomaticKeepAliveClientMixin{
  final supabase = Supabase.instance.client;

  late RefreshController _refreshController;
  void _onRefresh() async{
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    BlocProvider.of<RoomsBloc>(context).add(RoomsStartedEvent(supabase.auth.currentUser!.email));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
    // if(mounted) {
    //   setState(() {});
    // }

    // _refreshController.loadComplete();
  }

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showCupertinoDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return const AddRoomDialogWidget();
            },
          );
        },
        child: const Icon(CupertinoIcons.add),
      ),
      body: SmartRefresher(
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: false,
        physics: const BouncingScrollPhysics(),
        header: WaterDropMaterialHeader(
          distance: 60,
          offset: -(AppBar().preferredSize.height * 1.8),
          backgroundColor: context.theme.colorScheme.primary,
          color: context.theme.colorScheme.onPrimary,
        ),
        child: BlocBuilder<RoomsBloc, RoomsState>(
          builder: (context, state) {
            if (state is RoomsLoadingState) {
              return const LoadingWidget(lottieAsset: 'chat4.json');
            } else if (state is RoomsCompletedState) {
              final rooms = state.rooms;
              if (rooms.isEmpty) {
                return Center(
                  child: Container(
                    width: context.width * 0.6,
                    height: context.width * 0.6,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: FittedBox(
                      child: Column(
                        children: [
                          Lottie.asset('assets/lottie/chat3.json'),
                          const SizedBox(height: 16),
                          Text('اتاقی نیست ...', style: context.textTheme.headline3,)
                        ],
                      ),
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                physics: const BouncingScrollPhysics(),
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  return RoomItemWidget(
                    room: rooms[index],
                    currentUserEmail: supabase.auth.currentUser!.email!,
                    isFromCache: false,
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              );
            } else if (state is RoomsErrorState) {
              final errorMessage = state.errorMessage;
              return CustomErrorWidget(
                errorMessage: errorMessage,
                refreshButtonText: 'تلاش دوباره',
                refreshButtonOnTap: () {
                  BlocProvider.of<RoomsBloc>(context).add(RoomsStartedEvent(supabase.auth.currentUser!.email));
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
