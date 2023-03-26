import 'package:flutter/material.dart';
import 'package:flutter_jikan/main.dart';
import 'package:flutter_jikan/models/jikan.dart';
import 'package:flutter_jikan/pages/detailJikan/buildlist.dart';
import 'package:jikan_api/jikan_api.dart';

class CharacterDart extends StatelessWidget {
  final Future<List<CharacterMeta>> characters;

  const CharacterDart({
    super.key,
    required this.characters,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: characters,
      builder: (context, snapshot) {
        List<CharacterMeta> list = snapshot.data?.take(10).toList() ?? [];
        return httpBuild(
          snapshot: snapshot,
          widget: scrollableWin(
            context: context,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (list.isNotEmpty) ...[
                  const Text(
                    "Character & Voice Actor",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 10,
                    children: list.map((item) {
                      if (item.voiceActors == null) {
                        return const SizedBox();
                      } else {
                        final voice = item.voiceActors!.toList();

                        if (voice.isEmpty) {
                          return const SizedBox();
                        } else {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    JikanRoot.imageBase(
                                      url: item.imageUrl,
                                    ),
                                    BuildListItem(
                                      name: item.name,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    JikanRoot.imageBase(
                                      url: voice.first.imageUrl,
                                    ),
                                    BuildListItem(
                                      name: voice.first.name,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }
                      }
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
