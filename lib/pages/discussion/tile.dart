import 'package:flutter/material.dart';
import 'package:flutter_jikan/components/circle_avatar.dart';
import 'package:flutter_jikan/extension/home.dart';
import 'package:flutter_jikan/main.dart';
import 'package:flutter_jikan/models/jsons/club.dart';
import 'package:go_router_flow/go_router_flow.dart';

class DiscussionHeroTile extends StatelessWidget {
  final Color titleColor;
  final String subtitle;
  final VoidCallback onTap;

  const DiscussionHeroTile({
    super.key,
    this.titleColor = Colors.cyan,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "myClubs",
      child: ListTile(
        tileColor: titleColor.withOpacity(0.5),
        title: const Text("My clubs"),
        subtitle: Text(subtitle),
        trailing: InkWell(
          onTap: () => context.push("/discussion/formClub"),
          child: const Icon(Icons.add_box_outlined),
        ),
        onTap: onTap,
      ),
    );
  }
}

class DiscussionItemTile extends StatelessWidget {
  final ClubModel club;

  const DiscussionItemTile({
    super.key,
    required this.club,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(
        "/discussion/club/${club.id}",
        extra: club,
      ),
      child: ListTile(
        leading: CircleAvatarDart(
          backgroundImage: club.icon,
          child: const Icon(Icons.house),
        ),
        title: Text(
          club.name ?? "",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          "${(club.category ?? "").toCapitalized()}${"\n"}Club",
          textDirection: TextDirection.rtl,
        ),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.people),
            const SizedBox(width: 10),
            Text(
              kDot(club.members ?? 0),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
