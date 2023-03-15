import 'package:flutter/material.dart';
import 'package:flutter_jikan/firebase/auth/home.dart';
import 'package:flutter_jikan/firebase/database/my_list.dart';
import 'package:flutter_jikan/models/providers/my_list.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:provider/provider.dart';

class HomeListConsumer extends StatelessWidget {
  final Anime anime;

  const HomeListConsumer({
    super.key,
    required this.anime,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MyListProvider>(
      builder: (context, value, child) {
        final check = value.userMalId.contains(anime.malId);

        return ElevatedButton(
          onPressed: () async {
            if (auth.isAuthen) {
              if (check) {
                await MyListReal.deleteUserList(
                  uid: auth.uid,
                  id: value.userMyList.firstWhere((element) {
                    return element.malId == anime.malId;
                  }).id!,
                );
              } else {
                await MyListReal.setUserList(
                  uid: auth.uid,
                  anime: anime,
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: check ? Colors.red.shade800 : Colors.blue,
          ),
          child: Text(
            check ? "Unfollow" : "Follow",
          ),
        );
      },
    );
  }
}
