import 'package:flutter/material.dart';
import 'package:flutter_jikan/components/scaffod.dart';
import 'package:flutter_jikan/models/jikan.dart';
import 'package:flutter_jikan/pages/seasonal/future.dart';
import 'package:jikan_api/jikan_api.dart';

class SeasonalArchiveItem extends StatelessWidget {
  final int year;
  final String element;
  final SeasonType season;

  const SeasonalArchiveItem({
    super.key,
    required this.year,
    required this.element,
    required this.season,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      drawer: null,
      title: "$year - $element",
      body: SizedBox(
        width: double.infinity,
        child: SeasonalFuture(
          list: JikanAnime.getSeason(
            year: year,
            season: season,
          ),
        ),
      ),
    );
  }
}
