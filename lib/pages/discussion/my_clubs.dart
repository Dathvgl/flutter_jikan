import 'package:flutter/material.dart';
import 'package:flutter_jikan/firebase/auth/home.dart';
import 'package:flutter_jikan/firebase/database/club.dart';
import 'package:flutter_jikan/main.dart';
import 'package:flutter_jikan/models/jsons/club.dart';
import 'package:flutter_jikan/pages/discussion/tile.dart';
import 'package:go_router_flow/go_router_flow.dart';

class DiscussionMyClubsPage extends StatelessWidget {
  final List<ClubModel> list;

  const DiscussionMyClubsPage({
    super.key,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DiscussionHeroTile(
          subtitle: "Tab here to return",
          onTap: () => context.pop(),
        ),
        authBuild(
          none: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: const Center(
              child: Text("No user!"),
            ),
          ),
          done: FutureBuilder(
            future: ClubReal.getManyClub(auth.uid),
            builder: (context, snapshot) {
              final data = snapshot.data;
              if (data == null) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: const Center(
                    child: Text("No data!"),
                  ),
                );
              } else {
                List<String> ids = [];
          
                Map<String, Object>.from(data.value as Map)
                    .forEach((key, value) {
                  ids.add(key);
                });
          
                return httpBuild(
                  snapshot: snapshot,
                  widget: Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: Colors.lime,
                          height: 5,
                          thickness: 3,
                        );
                      },
                      itemCount: ids.length,
                      itemBuilder: (context, index) {
                        final item = list.firstWhere((element) {
                          return element.id == ids[index];
                        });
                            
                        return DiscussionItemTile(club: item);
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
