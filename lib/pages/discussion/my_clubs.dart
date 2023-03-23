import 'package:flutter/material.dart';
import 'package:flutter_jikan/pages/discussion/tile.dart';
import 'package:go_router_flow/go_router_flow.dart';

class DiscussionMyClubsPage extends StatelessWidget {
  const DiscussionMyClubsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DiscussionHeroTile(
          subtitle: "Tab here to return",
          onTap: () => context.pop(),
        ),
      ],
    );
  }
}
