import 'package:flutter/material.dart';
import 'package:flutter_jikan/models/jikan.dart';
import 'package:flutter_jikan/pages/home/consumer.dart';
import 'package:jikan_api/jikan_api.dart';

class HomeList extends StatelessWidget {
  final List<Anime> list;

  const HomeList({
    super.key,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        Anime anime = list[index];
        return InkWell(
          onTap: () => JikanRoot.onClick(
            context: context,
            id: anime.malId,
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: JikanRoot.imageBase(
                    url: anime.imageUrl,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            JikanRoot.titleString(
                              title: anime.title,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              anime.background ?? "",
                              maxLines: 3,
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            HomeListConsumer(anime: anime),
                            Text("Score: ${anime.score}"),
                          ],
                        ),
                      ],
                    ),
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
