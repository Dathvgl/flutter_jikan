import 'package:flutter/material.dart';
import 'package:flutter_jikan/main.dart';
import 'package:flutter_jikan/pages/seasonal/list.dart';
import 'package:jikan_api/jikan_api.dart';

class SeasonalFuture extends StatelessWidget {
  final Future<List<Anime>> list;

  const SeasonalFuture({
    super.key,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: list,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        List<Anime> list = snapshot.data ?? [];
        return httpBuild(
          snapshot: snapshot,
          widget: SingleChildScrollView(
            child: Wrap(
              runSpacing: 30,
              alignment: WrapAlignment.spaceBetween,
              children: list.map((item) {
                return SeasonalList(
                  anime: item,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
