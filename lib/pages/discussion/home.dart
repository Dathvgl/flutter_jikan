import 'package:flutter/material.dart';
import 'package:flutter_jikan/firebase/store/club.dart';
import 'package:flutter_jikan/main.dart';
import 'package:flutter_jikan/models/jsons/club.dart';
import 'package:flutter_jikan/pages/discussion/tile.dart';
import 'package:go_router_flow/go_router_flow.dart';

class DiscussionPage extends StatelessWidget {
  const DiscussionPage({super.key});

  final sbWidth = const SizedBox(width: 10);
  final sbHeight = const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: "Search",
                  ),
                ),
              ),
              sbWidth,
              const Icon(Icons.search),
            ],
          ),
        ),
        sbHeight,
        DiscussionHeroTile(
          subtitle: "Tab here to view",
          onTap: () => context.push("/discussion/myClub"),
        ),
        FutureBuilder(
          future: ClubStore.getClubList(),
          builder: (context, snapshot) {
            final list = snapshot.data?.docs ?? [];
            return httpBuild(
              snapshot: snapshot,
              widget: Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10);
                  },
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final map = list[index].data();
                    final club = ClubModel.fromJson(map);
                    return DiscussionItemTile(club: club);
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
