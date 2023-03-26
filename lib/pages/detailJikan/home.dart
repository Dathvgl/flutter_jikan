import 'package:flutter/material.dart';
import 'package:flutter_jikan/components/scaffod.dart';
import 'package:flutter_jikan/firebase/auth/home.dart';
import 'package:flutter_jikan/firebase/database/my_list.dart';
import 'package:flutter_jikan/main.dart';
import 'package:flutter_jikan/models/jikan.dart';
import 'package:flutter_jikan/models/providers/my_list.dart';
import 'package:flutter_jikan/pages/detailJikan/buildlist.dart';
import 'package:flutter_jikan/pages/detailJikan/carousel.dart';
import 'package:flutter_jikan/pages/detailJikan/character.dart';
import 'package:flutter_jikan/pages/detailJikan/chart.dart';
import 'package:flutter_jikan/pages/detailJikan/expand.dart';
import 'package:flutter_jikan/pages/detailJikan/relation.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:provider/provider.dart';

class DetailJikanPage extends StatelessWidget {
  final Future<Anime> jikan;

  const DetailJikanPage({
    super.key,
    required this.jikan,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: jikan,
      builder: (context, snapshot) {
        Anime? anime = snapshot.data;
        if (anime == null) {
          return const CustomScaffold(
            drawer: null,
            body: Center(
              child: Text("Loading..."),
            ),
          );
        } else {
          return CustomScaffold(
            drawer: null,
            body: DetailJikanHome(
              anime: anime,
              snapshot: snapshot,
            ),
            floatingActionButton: CircleAvatar(
              backgroundColor: Colors.black54,
              child: Consumer<MyListProvider>(
                builder: (context, value, child) {
                  final check = value.userMalId.contains(anime.malId);

                  return IconButton(
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
                    icon: Icon(
                      check ? Icons.close : Icons.addchart,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
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
  late Future<Stats> statistic;

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

  final sbHeight = const SizedBox(height: 30);

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

    final n = fns.length;
    final id = widget.anime.malId;

    statistic = JikanAnime.getAnimeStatistics(id: id);

    for (var i = 0; i < n; i++) {
      await Future.delayed(const Duration(seconds: 1)).then((value) {
        setState(() {
          obj[keys[i]] = fns[i](id: id);
        });
      });
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

  Widget infoBase(String name, int? num) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(kDot(num ?? 0)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Anime anime = widget.anime;
    return httpBuild(
      snapshot: widget.snapshot,
      widget: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.blue,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Score",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("${anime.score}"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 80,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CarouselDart(
                        backgroundColor: Colors.white,
                        images: infoFList<Picture>(
                          list: obj["images"],
                        ),
                      ),
                      Wrap(
                        direction: Axis.vertical,
                        spacing: 5,
                        runAlignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.end,
                        children: [
                          const SizedBox(height: 35),
                          infoBase("Rank", anime.rank),
                          infoBase("Popularity", anime.popularity),
                          infoBase("Members", anime.members),
                          infoBase("Favorites", anime.favorites),
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
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //     onPressed: () {},
                  //     child: const Text("More infomation"),
                  //   ),
                  // ),
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
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //     onPressed: () {},
                  //     child: const Text("More Cast"),
                  //   ),
                  // ),
                  sbHeight,
                  BuiltStaffDart(
                    staffs: infoFList<PersonMeta>(
                      list: obj["staffs"],
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //     onPressed: () {},
                  //     child: const Text("More staff"),
                  //   ),
                  // ),
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
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //     onPressed: () {},
                  //     child: const Text("More recommend"),
                  //   ),
                  // ),
                  sbHeight,
                  StatisticsDart(
                    stats: statistic,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
