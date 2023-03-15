import 'package:flutter/material.dart';
import 'package:flutter_jikan/components/tabbar.dart';
import 'package:flutter_jikan/models/jikan.dart';
import 'package:flutter_jikan/pages/seasonal/archive.dart';
import 'package:flutter_jikan/pages/seasonal/future.dart';
import 'package:jikan_api/jikan_api.dart';

class SeasonalPage extends StatefulWidget {
  const SeasonalPage({super.key});

  @override
  State<SeasonalPage> createState() => _SeasonalPageState();
}

class _SeasonalPageState extends State<SeasonalPage>
    with TickerProviderStateMixin {
  late int year;
  late int index;

  late Future<List> listSeason;

  final seasons = ["winter", "spring", "summer", "fall"];

  final tabs = const [
    Text("Last"),
    Text("Now"),
    Text("Next"),
    Text("Archive"),
  ];

  @override
  void initState() {
    super.initState();
    listSeason = JikanAnime.getSeasonsList();

    final date = DateTime.now();
    final monthDate = date.month;

    String seasonal = "winter";
    year = date.year;
    switch (monthDate) {
      case DateTime.january:
      case DateTime.february:
      case DateTime.march:
        seasonal = "winter";
        break;
      case DateTime.april:
      case DateTime.may:
      case DateTime.june:
        seasonal = "spring";
        break;
      case DateTime.july:
      case DateTime.august:
      case DateTime.september:
        seasonal = "summer";
        break;
      case DateTime.october:
      case DateTime.november:
      case DateTime.december:
        seasonal = "fall";
        break;
    }

    index = seasons.indexOf(seasonal);
  }

  @override
  Widget build(BuildContext context) {
    final controller = TabController(
      length: tabs.length,
      vsync: this,
    );

    final children = [
      SeasonalFuture(
        list: JikanAnime.getSeason(
          year: index == 0 ? year - 1 : year,
          season:
              SeasonType.values[index == 0 ? seasons.length - 1 : index - 1],
        ),
      ),
      SeasonalFuture(
        list: JikanAnime.getSeason(
          year: year,
          season: SeasonType.values[index],
        ),
      ),
      SeasonalFuture(
        list: JikanAnime.getSeason(
          year: index == seasons.length - 1 ? year + 1 : year,
          season:
              SeasonType.values[index == seasons.length - 1 ? 0 : index + 1],
        ),
      ),
      SeasonalArchive(
        listSeason: JikanAnime.getSeasonsList(),
      ),
    ];

    return TabBarDart(
      controller: controller,
      tabs: tabs,
      children: children,
    );
  }
}
