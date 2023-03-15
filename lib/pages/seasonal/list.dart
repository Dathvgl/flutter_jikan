import 'package:flutter/material.dart';
import 'package:flutter_jikan/components/icon.dart';
import 'package:flutter_jikan/main.dart';
import 'package:flutter_jikan/models/jikan.dart';
import 'package:jikan_api/jikan_api.dart';

class SeasonalList extends StatelessWidget {
  final Anime anime;

  const SeasonalList({
    super.key,
    required this.anime,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.48,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(children: [
              JikanRoot.imageBase(
                url: anime.imageUrl,
              ),
              Positioned(
                bottom: 10,
                left: 0,
                child: Container(
                  color: Colors.black87,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      anime.score == null
                          ? const SizedBox()
                          : RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${anime.score} ",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const WidgetSpan(
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${kDot(anime.members ?? 0)} ",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const WidgetSpan(
                              child: Icon(
                                Icons.people,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: IconContainerDart(
                  iconData: Icons.addchart,
                  onPressed: () {},
                ),
              ),
            ]),
            JikanRoot.titleString(
              title: anime.title,
            ),
            JikanRoot.infoString(
              list: anime.genres,
            ),
          ],
        ),
      ),
    );
  }
}
