import 'package:flutter/material.dart';
import 'package:flutter_jikan/components/navigation/home.dart';
import 'package:flutter_jikan/models/jikan.dart';
import 'package:flutter_jikan/models/jsons/club.dart';
import 'package:flutter_jikan/models/jsons/my_list.dart';
import 'package:flutter_jikan/models/jsons/post.dart';
import 'package:flutter_jikan/pages/detailJikan/home.dart';
import 'package:flutter_jikan/pages/discover.dart';
import 'package:flutter_jikan/pages/discussion/club/home.dart';
import 'package:flutter_jikan/pages/discussion/club/post/comment.dart';
import 'package:flutter_jikan/pages/discussion/form.dart';
import 'package:flutter_jikan/pages/discussion/home.dart';
import 'package:flutter_jikan/pages/discussion/my_clubs.dart';
import 'package:flutter_jikan/pages/home/home.dart';
import 'package:flutter_jikan/pages/myList/home.dart';
import 'package:flutter_jikan/pages/myList/item/home.dart';
import 'package:flutter_jikan/pages/seasonal/home.dart';
import 'package:flutter_jikan/pages/seasonal/item/home.dart';
import 'package:flutter_jikan/pages/user/home.dart';
import 'package:flutter_jikan/pages/user/info/home.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:jikan_api/jikan_api.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

abstract class GoRouterDart {
  static final router = GoRouter(
    initialLocation: "/home",
    navigatorKey: _rootNavigatorKey,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return NavigationBottom(child: child);
        },
        routes: [
          GoRoute(
            path: "/home",
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: "/discussion",
            builder: (context, state) => const DiscussionPage(),
            routes: [
              GoRoute(
                parentNavigatorKey: _rootNavigatorKey,
                path: "club/:id",
                builder: (context, state) {
                  final extra = state.extra as ClubModel;
                  return DiscussionClubPage(club: extra);
                },
                routes: [
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: "comment",
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>;
                      return DiscussionClubPostComment(
                        clubId: extra["clubId"] as String,
                        post: extra["post"] as PostModel,
                      );
                    },
                  ),
                ],
              ),
              GoRoute(
                path: "myClub",
                builder: (context, state) {
                  final extra = state.extra as List<ClubModel>;
                  return DiscussionMyClubsPage(list: extra);
                },
              ),
              GoRoute(
                parentNavigatorKey: _rootNavigatorKey,
                path: "formClub",
                builder: (context, state) => const DiscussionFormPage(),
              ),
            ],
          ),
          GoRoute(
            path: "/discover",
            builder: (context, state) => const DiscoverPage(),
          ),
          GoRoute(
            path: "/seasonal",
            builder: (context, state) => const SeasonalPage(),
            routes: [
              GoRoute(
                parentNavigatorKey: _rootNavigatorKey,
                path: "archive",
                builder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>;
                  return SeasonalArchiveItem(
                    year: extra["year"],
                    element: extra["element"],
                    season: extra["season"] as SeasonType,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: "/mylist",
            builder: (context, state) => const MyListPage(),
            routes: [
              GoRoute(
                parentNavigatorKey: _rootNavigatorKey,
                path: ":id",
                builder: (context, state) {
                  return MyListItem(
                    myItem: state.extra as MyListModel,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: "/detail-jikan/:id",
        builder: (context, state) {
          final id = int.parse(state.params["id"]!);
          Future<Anime> anime = JikanAnime.getAnime(id: id);
          return DetailJikanPage(
            jikan: anime,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: "/user/screen",
        builder: (context, state) => const UserPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: "/user/info",
        builder: (context, state) => const UserInfo(),
      ),
    ],
  );
}
