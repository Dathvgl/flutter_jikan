import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jikan/components/scaffod.dart';
import 'package:flutter_jikan/components/wrap.dart';
import 'package:flutter_jikan/enums/item.dart';
import 'package:flutter_jikan/firebase/auth/home.dart';
import 'package:flutter_jikan/firebase/database/my_list.dart';
import 'package:flutter_jikan/main.dart';
import 'package:flutter_jikan/models/jsons/my_list.dart';
import 'package:flutter_jikan/models/providers/theme.dart';
import 'package:flutter_jikan/pages/myList/item/carousel.dart';
import 'package:flutter_jikan/pages/myList/item/date.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class MyListItem extends StatefulWidget {
  final MyListModel myItem;

  const MyListItem({
    super.key,
    required this.myItem,
  });

  @override
  State<MyListItem> createState() => _MyListItemState();
}

class _MyListItemState extends State<MyListItem> {
  Map<String, dynamic> map = {
    "state": "",
    "progress": 0,
    "score": 0,
    "dateStart": "",
    "dateEnd": "",
  };

  @override
  void initState() {
    super.initState();

    map["state"] = widget.myItem.state;
    map["progress"] = widget.myItem.progress;
    map["score"] = widget.myItem.score;
    map["dateStart"] = widget.myItem.dateStart;
    map["dateEnd"] = widget.myItem.dateEnd;
  }

  final pdAll = 10.0;
  final btnHeight = 50.0;

  final sbHeight = const SizedBox(height: 30);

  void callbackMap({required String key, required dynamic value}) {
    switch (value.runtimeType) {
      case String:
        if (key == "state") {
          setState(() {
            map[key] = value as String;
          });
        } else {
          map[key] = value as String;
        }
        break;
      case int:
        map[key] = value as int;
        break;
      case bool:
        map[key] = value as bool;
        break;
      default:
        map[key] = value;
    }
  }

  final List<String> myState = ItemStateType.values.map((item) {
    return item.name;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      actions: [
        TextButton(
          child: const Text("Save"),
          onPressed: () async {
            final base = {
              "state": widget.myItem.state,
              "progress": widget.myItem.progress,
              "score": widget.myItem.score,
              "dateStart": widget.myItem.dateStart,
              "dateEnd": widget.myItem.dateEnd,
            };

            Map<String, dynamic> result = {};

            base.forEach((key, value) {
              if (map[key] != value) {
                result[key] = map[key];
              }
            });

            await MyListReal.updateUserList(
              uid: auth.uid,
              id: widget.myItem.id!,
              map: result,
            );

            if (mounted) {
              context.pop();
            }
          },
        ),
      ],
      drawer: null,
      body: Padding(
        padding: EdgeInsets.only(
          top: pdAll,
          left: pdAll,
          right: pdAll,
          bottom: pdAll * 2 + btnHeight,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.myItem.title ?? "Name title",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              sbHeight,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Status"),
                  Text(widget.myItem.status ?? "Unknown"),
                ],
              ),
              sbHeight,
              SizedBox(
                width: double.infinity,
                child: WrapDart(
                  columnCount: 3,
                  runSpacing: 20,
                  extraWidth: 40,
                  children: myState.mapIndexed((index, element) {
                    final globalKey = GlobalKey();
                    final widget = InkWell(
                      key: globalKey,
                      onTap: () => callbackMap(
                        key: "state",
                        value: element,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        width: MediaQuery.of(context).size.width * 0.28,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: context.watch<DarkThemeProvider>().darkTheme
                                ? Colors.black
                                : Colors.white,
                          ),
                          color: map["state"] == element
                              ? ItemStateType.values[index].color
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(element),
                        ),
                      ),
                    );
                    return Tuple2(globalKey, widget);
                  }).toList(),
                ),
              ),
              sbHeight,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Progress"),
                  Text(kDot(widget.myItem.totalProgress ?? 0)),
                ],
              ),
              MyListItemCarouselEmpty(
                defaultIndex: map["progress"],
                list: List.generate(
                  (widget.myItem.totalProgress ?? 0) + 1,
                  (index) => index,
                ).toList(),
                callbackItem: ({required int num}) {
                  callbackMap(
                    key: "progress",
                    value: num,
                  );
                },
              ),
              sbHeight,
              const Text("Score"),
              MyListItemCarouselString(
                defaultIndex: map["score"],
                reverse: true,
                list: const [
                  "No Score",
                  "Appalling",
                  "Horrible",
                  "Very Bad",
                  "Bad",
                  "Average",
                  "Fine",
                  "Good",
                  "Very Good",
                  "Great",
                  "Masterpiece",
                ],
                callbackItem: ({required int num}) {
                  callbackMap(
                    key: "score",
                    value: num,
                  );
                },
              ),
              sbHeight,
              const Text("Date"),
              MyListItemDate(
                keyMap: "dateStart",
                dateTime: map["dateStart"],
                callback: callbackMap,
              ),
              MyListItemDate(
                keyMap: "dateEnd",
                dateTime: map["dateEnd"],
                callback: callbackMap,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: InkWell(
        onTap: () async {
          if (mounted) {
            context.pop<String>("reload");
          }

          await MyListReal.deleteUserList(
            uid: auth.uid,
            id: widget.myItem.id!,
          );
        },
        child: Container(
          height: btnHeight,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
              top: BorderSide(
                color: context.watch<DarkThemeProvider>().darkTheme
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "Remove from list",
              style: TextStyle(
                color: Colors.red.shade800,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
