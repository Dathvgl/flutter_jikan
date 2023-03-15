import 'package:flutter/material.dart';
import 'package:flutter_jikan/components/scaffod.dart';
import 'package:flutter_jikan/main.dart';
import 'package:flutter_jikan/models/jikan.dart';
import 'package:flutter_jikan/pages/detailJikan/buildlist.dart';
import 'package:flutter_jikan/pages/detailJikan/carousel.dart';
import 'package:flutter_jikan/pages/detailJikan/character.dart';
import 'package:flutter_jikan/pages/detailJikan/chart.dart';
import 'package:flutter_jikan/pages/detailJikan/expand.dart';
import 'package:flutter_jikan/pages/detailJikan/relation.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jikan_api/jikan_api.dart';

class DetailJikanPage extends StatefulWidget {
  final Future<Anime> jikan;

  const DetailJikanPage({
    super.key,
    required this.jikan,
  });

  @override
  State<DetailJikanPage> createState() => _DetailJikanPageState();
}

class _DetailJikanPageState extends State<DetailJikanPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      drawer: null,
      body: FutureBuilder(
        future: widget.jikan,
        builder: (context, snapshot) {
          Anime? anime = snapshot.data;
          if (anime == null) {
            return const Center(
              child: Text("Loading..."),
            );
          } else {
            return DetailJikanHome(
              anime: anime,
              snapshot: snapshot,
            );
          }
        },
      ),
      floatingActionButton: CircleAvatar(
        backgroundColor: Colors.black54,
        child: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.addchart,
            color: Colors.white,
          ),
        ),
      ),
    );
    // return Scaffold(
    //   floatingActionButton: CircleAvatar(
    //     backgroundColor: Colors.black54,
    //     child: IconButton(
    //       onPressed: () {},
    //       icon: const Icon(
    //         Icons.addchart,
    //         color: Colors.white,
    //       ),
    //     ),
    //   ),
    //   body: FutureBuilder(
    //     future: widget.jikan,
    //     builder: (context, snapshot) {
    //       Anime? anime = snapshot.data;
    //       if (anime == null) {
    //         return const Center(
    //           child: Text("Loading..."),
    //         );
    //       } else {
    //         return DetailJikanHome(
    //           anime: anime,
    //           snapshot: snapshot,
    //         );
    //       }
    //     },
    //   ),
    // );
  }
}

class DetailJikanHome extends StatefulWidget {
  final Anime anime;
  final AsyncSnapshot<Anime> snapshot;

  const DetailJikanHome({
    super.key,
    required this.anime,
    required this.snapshot,
  });

  @override
  State<DetailJikanHome> createState() => _DetailJikanHomeState();
}

class _DetailJikanHomeState extends State<DetailJikanHome> {
  Future<Stats> statistic = Future(() => Stats());

  final keys = [
    'images',
    'characters',
    'staffs',
    // 'reviews',
    'recommendations',
  ];

  final obj = <String, Future<List<Object>>?>{
    'images': null,
    'characters': null,
    'staffs': null,
    // 'reviews': null,
    'recommendations': null,
  };

  @override
  void initState() {
    super.initState();
    futures();
  }

  futures() async {
    final fns = [
      JikanAnime.getAnimePictures,
      JikanAnime.getAnimeCharacters,
      JikanAnime.getAnimeStaff,
      // JikanAnime.getAnimeReviews,
      JikanAnime.getAnimeRecommendations,
    ];

    int count = 0;
    final delay = Future.delayed(const Duration(seconds: 2));

    final n = fns.length;
    final id = widget.anime.malId;

    for (var i = 0; i < n; i++) {
      final last = i == n - 1;
      count++;

      setState(() {
        obj[keys[i]] = fns[i](id: id);
      });

      if (count == 3 && !last) {
        count = 0;
        await delay;
      }

      if (last) {
        if (count == 3) {
          count = 0;
          await delay;
        }

        setState(() {
          statistic = JikanAnime.getAnimeStatistics(id: id);
        });
      }
    }
  }

  Future<List<T>> infoFList<T>({
    required Future<List<Object>>? list,
  }) {
    return list != null ? list as Future<List<T>> : Future(() => <T>[]);
  }

  Widget infoColumn({
    required String title,
    String? text,
    BuiltList<Meta>? metas,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        text != null ? Text(text) : const SizedBox(),
        metas != null
            ? Wrap(
                spacing: 20,
                children: metas
                    .map(
                      (item) => TextButton(
                        onPressed: () {
                          debugPrint(item.url);
                        },
                        child: Text(item.name),
                      ),
                    )
                    .toList(),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget infoList({required List<Widget> list}) {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 30,
      children: list,
    );
  }

  final sbHeight = const SizedBox(height: 30);

  @override
  Widget build(BuildContext context) {
    Anime anime = widget.anime;
    return httpBuild(
      snapshot: widget.snapshot,
      widget: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: 80,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CarouselDart(
                    images: infoFList<Picture>(
                      list: obj["images"],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("Score"),
                      Text("${anime.score}"),
                      const Text("Rank"),
                      Text(kDot(anime.rank ?? 0)),
                      const Text("Popularity"),
                      Text(kDot(anime.popularity ?? 0)),
                      const Text("Members"),
                      Text(kDot(anime.members ?? 0)),
                      const Text("Favorites"),
                      Text(kDot(anime.favorites ?? 0)),
                    ],
                  ),
                ],
              ),
              sbHeight,
              JikanRoot.titleString(
                title: anime.title,
              ),
              sbHeight,
              Row(
                children: [
                  Text("${anime.type}"),
                  Text("${anime.year}"),
                ],
              ),
              sbHeight,
              Center(
                child: Wrap(
                  spacing: 20,
                  alignment: WrapAlignment.center,
                  children: anime.genres
                      .map(
                        (item) => TextButton(
                          onPressed: () {},
                          child: Text(item.name),
                        ),
                      )
                      .toList(),
                ),
              ),
              sbHeight,
              ExpandDart(
                less: Text(
                  "${anime.synopsis}",
                  maxLines: 4,
                  softWrap: true,
                  textAlign: TextAlign.justify,
                ),
                more: Text(
                  "${anime.synopsis}",
                  softWrap: true,
                  textAlign: TextAlign.justify,
                ),
                lessText: "Less Sysnopsis",
                moreText: "More Sysnopsis",
              ),
              sbHeight,
              infoColumn(
                title: "English",
                text: anime.titleEnglish.toString(),
              ),
              sbHeight,
              Flexible(
                child: infoList(
                  list: [
                    infoColumn(
                      title: "Source",
                      text: anime.source.toString(),
                    ),
                    infoColumn(
                      title: "Season",
                      text: anime.season.toString(),
                    ),
                    infoColumn(
                      title: "Studio",
                      metas: anime.studios,
                    ),
                    infoColumn(
                      title: "Aired",
                      text: anime.aired.toString(),
                    ),
                    infoColumn(
                      title: "Rating",
                      text: anime.rating.toString(),
                    ),
                    infoColumn(
                      title: "Licensor",
                      metas: anime.licensors,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("More infomation"),
                ),
              ),
              sbHeight,
              RelationDart(
                relations: anime.relations,
              ),
              sbHeight,
              CharacterDart(
                characters: infoFList<CharacterMeta>(
                  list: obj["characters"],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("More Cast"),
                ),
              ),
              sbHeight,
              BuiltStaffDart(
                staffs: infoFList<PersonMeta>(
                  list: obj["staffs"],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("More staff"),
                ),
              ),
              // sbHeight,
              // BuildReviewDart(
              //   reviews: infoFList<Review>(
              //     list: obj["reviews"],
              //   ),
              // ),
              sbHeight,
              BuiltRecommendDart(
                recommends: infoFList<Recommendation>(
                  list: obj["recommendations"],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("More recommend"),
                ),
              ),
              sbHeight,
              StatisticsDart(
                stats: statistic,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
