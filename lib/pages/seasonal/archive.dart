import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jikan/extension/home.dart';
import 'package:flutter_jikan/main.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:jikan_api/jikan_api.dart';

class SeasonalArchive extends StatelessWidget {
  final Future<List<Archive>> listSeason;

  const SeasonalArchive({
    super.key,
    required this.listSeason,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: listSeason,
      builder: (context, snapshot) {
        List<Archive> list = snapshot.data ?? [];
        return httpBuild(
          snapshot: snapshot,
          widget: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              height: 20,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              Archive season = list[index];
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      season.year.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      children: season.seasons.mapIndexed((index, element) {
                        return ElevatedButton(
                          onPressed: () {
                            context.push(
                              "/seasonal/archive",
                              extra: {
                                "year": season.year,
                                "element": element,
                                "season": SeasonType.values[index],
                              },
                            );
                          },
                          child: Text(element.toCapitalized()),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
