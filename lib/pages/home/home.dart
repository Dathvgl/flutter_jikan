import 'package:flutter/material.dart';
import 'package:flutter_jikan/main.dart';
import 'package:flutter_jikan/models/jikan.dart';
import 'package:flutter_jikan/pages/home/list.dart';
import 'package:jikan_api/jikan_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Anime>> topAnime;

  @override
  void initState() {
    super.initState();
    topAnime = JikanAnime.getTopAnime();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: topAnime,
        builder: (context, snapshot) {
          List<Anime> list = snapshot.data ?? [];
          return httpBuild(
            snapshot: snapshot,
            widget: HomeList(
              list: list,
            ),
          );
        },
      ),
    );
  }
}
