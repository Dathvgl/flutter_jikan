import 'package:flutter/material.dart';
import 'package:flutter_jikan/main.dart';
import 'package:flutter_jikan/models/jikan.dart';
import 'package:jikan_api/jikan_api.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  Future<List<Anime>> favAnime = Future(() => []);
  Future<List<Anime>> airAnime = Future(() => []);
  Future<List<Anime>> upAnime = Future(() => []);

  final sbHeight = const SizedBox(height: 30);

  @override
  void initState() {
    super.initState();

    delayed("favorite");
    delayed("airing");
    delayed("upcoming");
  }

  delayed(String filter) {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        switch (filter) {
          case "favorite":
            favAnime = JikanAnime.getTopAnime(subtype: TopSubtype.favorite);
            break;
          case "airing":
            airAnime = JikanAnime.getTopAnime(subtype: TopSubtype.airing);
            break;
          case "upcoming":
            upAnime = JikanAnime.getTopAnime(subtype: TopSubtype.upcoming);
            break;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DiscoverFuture(
              title: "Top Favorite",
              futureAnime: favAnime,
            ),
            sbHeight,
            DiscoverFuture(
              title: "Top Airing",
              futureAnime: airAnime,
            ),
            sbHeight,
            DiscoverFuture(
              title: "Top Upcoming",
              futureAnime: upAnime,
            ),
            sbHeight,
          ],
        ),
      ),
    );
  }
}

class DiscoverFuture extends StatelessWidget {
  final String title;
  final Future<List<Anime>> futureAnime;

  const DiscoverFuture({
    super.key,
    required this.title,
    required this.futureAnime,
  });

  @override
  Widget build(BuildContext context) {
    const sbHeight = SizedBox(height: 10);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        sbHeight,
        FutureBuilder(
          future: futureAnime,
          builder: (context, snapshot) {
            List<Anime> list = snapshot.data ?? [];
            return httpBuild(
              snapshot: snapshot,
              widget: scrollableWin(
                context: context,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 10,
                    children: list.map((item) {
                      return InkWell(
                        onTap: () => JikanRoot.onClick(
                          context: context,
                          id: item.malId,
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                JikanRoot.imageBase(
                                  url: item.imageUrl,
                                ),
                                JikanRoot.titleString(
                                  title: item.title,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
