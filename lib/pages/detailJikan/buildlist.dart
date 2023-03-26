import 'package:flutter/material.dart';
import 'package:flutter_jikan/main.dart';
import 'package:flutter_jikan/models/jikan.dart';
import 'package:intl/intl.dart';
import 'package:jikan_api/jikan_api.dart';

class BuiltStaffDart extends StatelessWidget {
  final Future<List<PersonMeta>> staffs;

  const BuiltStaffDart({
    super.key,
    required this.staffs,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: staffs,
      builder: (context, snapshot) {
        List<PersonMeta> list = snapshot.data?.take(10).toList() ?? [];
        return httpBuild(
          snapshot: snapshot,
          widget: scrollableWin(
            context: context,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (list.isNotEmpty) ...[
                  const Text(
                    "Some Staff",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 20,
                    children: list.map((item) {
                      return BuildListDart(
                        url: item.imageUrl,
                        name: item.name,
                        list: item.positions?.asList(),
                      );
                    }).toList(),
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

class BuiltRecommendDart extends StatelessWidget {
  final Future<List<Recommendation>> recommends;

  const BuiltRecommendDart({
    super.key,
    required this.recommends,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: recommends,
      builder: (context, snapshot) {
        List<Recommendation> list = snapshot.data?.take(10).toList() ?? [];
        return httpBuild(
          snapshot: snapshot,
          widget: scrollableWin(
            context: context,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (list.isNotEmpty) ...[
                  const Text(
                    "Recommend Anime",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 20,
                    children: list.map((item) {
                      return BuildListDart(
                        url: item.entry.imageUrl,
                        name: item.entry.title,
                        list: ["${item.votes} Members"],
                      );
                    }).toList(),
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

class BuildReviewDart extends StatelessWidget {
  final Future<List<Review>> reviews;

  const BuildReviewDart({
    super.key,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: reviews,
      builder: (context, snapshot) {
        List<Review> list = snapshot.data?.take(2).toList() ?? [];
        return httpBuild(
          snapshot: snapshot,
          widget: scrollableWin(
            context: context,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 20,
                children: list.map((item) {
                  final date =
                      DateFormat.yMMMMd().format(DateTime.parse(item.date));
                  return Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star),
                          Text("${item.score} by ${item.user.username}"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Text("${item} votes"),
                          Text(date),
                        ],
                      ),
                      Text(
                        item.review,
                        maxLines: 2,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class BuildListDart extends StatelessWidget {
  final String url;
  final String name;
  final List<String>? list;

  const BuildListDart({
    super.key,
    required this.url,
    required this.name,
    this.list,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              JikanRoot.imageBase(
                url: url,
              ),
              BuildListItem(
                name: name,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            list?.join(", ") ?? "",
            maxLines: 2,
            textAlign: TextAlign.justify,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class BuildListItem extends StatelessWidget {
  final String name;

  const BuildListItem({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.width * 0.2,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black87,
            ],
          ),
        ),
        child: Text(
          name,
          maxLines: 2,
          textAlign: TextAlign.justify,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
