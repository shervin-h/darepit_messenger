import 'package:flusher/features/feature_messaging/presentation/bloc/rooms/search/search_rooms_bloc.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/rooms/visited_rooms/visited_rooms_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/widgets/custom_widgets.dart';
import '../../domain/entities/room_entity.dart';
import '../widgets/room_item_widget.dart';


class RecentVisitsRoomsTabScreen extends StatefulWidget {
   const RecentVisitsRoomsTabScreen({
     required this.searchController,
     required this.expansionKey,
     Key? key,
   }) : super(key: key);

  final TextEditingController searchController;
  final GlobalKey<CustomSearchTileState> expansionKey;

  static const String routeName = '/recent-visits-rooms-tab-screen';

  @override
  State<RecentVisitsRoomsTabScreen> createState() => _RecentVisitsRoomsTabScreenState();
}

class _RecentVisitsRoomsTabScreenState extends State<RecentVisitsRoomsTabScreen>
    with AutomaticKeepAliveClientMixin {

  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomSearchTile(
              key: widget.expansionKey,
              controller: widget.searchController,
              hintText: 'جستجوی اتاق ..',
            ),
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                        [
                          BlocConsumer<SearchRoomsBloc, SearchRoomsState>(
                            listener: (context, state) {},
                            buildWhen: (previous, current) {
                              if (previous == current) {
                                return false;
                              }
                              return true;
                            },
                            builder: (context, state) {
                              if (state is SearchRoomsLoadingState) {
                                return const LoadingWidget(lottieAsset: 'search.json');
                              } else if (state is SearchRoomsCompletedState) {
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
                                            Lottie.asset(
                                              'assets/lottie/not_found.json',
                                            ),
                                            const SizedBox(height: 16),
                                            Text('اتاقی نیست ...', style: context.textTheme.headline3,)
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Column(
                                  children: [
                                    Container(
                                      width: context.width,
                                      decoration: BoxDecoration(
                                        color: context.theme.colorScheme.onBackground.withOpacity(0.2),
                                      ),
                                      child: Column(
                                        children: [
                                          Divider(height: 2, color: context.theme.colorScheme.onBackground),
                                          const SizedBox(height: 2),
                                          Text(
                                            'نتایج',
                                            style: context.textTheme.bodyText2!.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Divider(height: 2, color: context.theme.colorScheme.onBackground),
                                        ],
                                      ),
                                    ),
                                    ...mapListOfRoomEntitiesToItemWidget(rooms, supabase, false),
                                  ],
                                );
                              } else if (state is SearchRoomsErrorState) {
                                return CustomErrorWidget(errorMessage: state.errorMessage);
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ]
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                        [
                          Container(
                            width: context.width,
                            decoration: BoxDecoration(
                              color: context.theme.colorScheme.onBackground.withOpacity(0.2),
                            ),
                            child: Column(
                              children: [
                                Divider(height: 2, color: context.theme.colorScheme.onBackground),
                                const SizedBox(height: 2),
                                Text(
                                  'اتاق های بازدید شده',
                                  style: context.textTheme.bodyText2!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Divider(height: 2, color: context.theme.colorScheme.onBackground),
                              ],
                            ),
                          ),
                          BlocConsumer<VisitedRoomsBloc, VisitedRoomsState>(
                            listener: (previous, current) {},
                            buildWhen: (previous, current) {
                              if (previous is VisitedRoomsCompletedState &&
                                  current is VisitedRoomsCompletedState &&
                                  previous.rooms == current.rooms) {
                                return false;
                              }
                              return true;
                            },
                            builder: (context, state) {
                              if (state is VisitedRoomsCompletedState) {
                                final visitedRooms = state.rooms;
                                if (visitedRooms.isEmpty) {
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
                                            Lottie.asset(
                                              'assets/lottie/list_icon.json',
                                              width: context.width * 0.8,
                                              fit: BoxFit.fitWidth,
                                            ),
                                            const SizedBox(height: 16),
                                            Text('اتاقی نیست ...', style: context.textTheme.headline3,)
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Column(
                                  children: [
                                    ...mapListOfRoomEntitiesToItemWidget(visitedRooms, supabase, true),
                                  ],
                                );
                              }
                              return Container();
                            },
                          ),
                        ]
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

List<Widget> mapListOfRoomEntitiesToItemWidget(List<RoomEntity> rooms, SupabaseClient supabaseClient, bool isFromCache) {
  return rooms.map(
    (roomEntity) => Column(
      children: [
        RoomItemWidget(
          room: roomEntity,
          currentUserEmail: supabaseClient.auth.currentUser!.email!,
          isFromCache: isFromCache,
        ),
        if (rooms.isNotEmpty && roomEntity != rooms.last)
          const Divider(),
      ],
    )
  ).toList();
}
