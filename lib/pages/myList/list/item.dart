import 'package:flutter/material.dart';
import 'package:flutter_jikan/components/icon.dart';
import 'package:flutter_jikan/firebase/auth/home.dart';
import 'package:flutter_jikan/firebase/database/my_list.dart';
import 'package:flutter_jikan/main.dart';
import 'package:flutter_jikan/models/jikan.dart';
import 'package:flutter_jikan/models/jsons/my_list.dart';
import 'package:flutter_jikan/pages/myList/list/slidable.dart';
import 'package:go_router_flow/go_router_flow.dart';

class MyListListItem extends StatelessWidget {
  final MyListModel? item;

  const MyListListItem({
    super.key,
    required this.item,
  });

  final pdBase = 10.0;
  final sbHeight = const SizedBox(height: 10);

  Future<void> progressAlt({
    required String? id,
    required int? progress,
    required int? totalProgress,
    required int num,
  }) async {
    final result = progress! + num;
    if (result >= 0 && result <= totalProgress!) {
      await MyListReal.updateUserList(
        uid: auth.uid,
        id: id!,
        map: {
          "progress": result,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      final anime = item!;

      return MyListListSlidable(
        list: [
          SlidableItem(
            label: "Go to",
            icon: Icons.explore,
            map: {"malId": anime.malId},
            backgroundColor: Colors.green,
            onPressed: (map) {
              int malId = map["malId"] as int;
              context.push("/detail-jikan/$malId");
            },
          ),
          SlidableItem(
            label: "Note",
            icon: Icons.text_snippet_outlined,
            map: {"id": anime.id},
            backgroundColor: Colors.blue,
            onPressed: (map) {
              // String id = map["id"] as String;
              // context.go("/detail-jikan/$malId");
            },
          ),
        ],
        child: InkWell(
          onTap: () async {
            await context.push<String>(
              "/mylist/${anime.malId}",
              extra: anime,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: JikanRoot.imageBase(
                  url: anime.imageUrl ?? "",
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(pdBase),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      JikanRoot.titleString(
                        title: "${anime.title}\n",
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(anime.type.toString()),
                                  anime.season != null && anime.year != null
                                      ? Text(", ${anime.season} ${anime.year}")
                                      : anime.season == null &&
                                              anime.year == null
                                          ? const SizedBox()
                                          : Text(
                                              ", ${anime.season ?? ""}${anime.year ?? ""}"),
                                ],
                              ),
                              Text(anime.status.toString()),
                            ],
                          ),
                          sbHeight,
                          LinearProgressIndicator(
                            value: (anime.progress ?? 0) /
                                (anime.totalProgress ?? 1),
                            minHeight: 15,
                          ),
                          sbHeight,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const WidgetSpan(
                                      child: Icon(
                                        Icons.star,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " ${anime.score}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                  "${kDot(anime.progress ?? 0)} / ${kDot(anime.totalProgress ?? 0)}"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: pdBase,
                  bottom: pdBase,
                  right: pdBase,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconContainerDart(
                      iconData: Icons.addchart,
                      onPressed: () {},
                    ),
                    sbHeight,
                    IconContainerDart(
                      iconData: Icons.add,
                      onPressed: () async {
                        await progressAlt(
                          id: anime.id,
                          progress: anime.progress,
                          totalProgress: anime.totalProgress,
                          num: 1,
                        );
                      },
                    ),
                    sbHeight,
                    IconContainerDart(
                      iconData: Icons.remove,
                      onPressed: () async {
                        await progressAlt(
                          id: anime.id,
                          progress: anime.progress,
                          totalProgress: anime.totalProgress,
                          num: -1,
                        );
                      },
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
}
