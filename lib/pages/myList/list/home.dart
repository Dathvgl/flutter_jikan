import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jikan/firebase/auth/home.dart';
import 'package:flutter_jikan/firebase/database/my_list.dart';
import 'package:flutter_jikan/main.dart';
import 'package:flutter_jikan/models/jsons/my_list.dart';
import 'package:flutter_jikan/models/providers/my_list.dart';
import 'package:flutter_jikan/pages/myList/list/item.dart';
import 'package:provider/provider.dart';

class MyListList extends StatefulWidget {
  final List<MyListModel> myList;
  final String state;

  const MyListList({
    super.key,
    required this.myList,
    required this.state,
  });

  @override
  State<MyListList> createState() => _MyListListState();
}

class _MyListListState extends State<MyListList> {
  int count = 0;
  String type = "All";
  String sort = "all";
  List<MyListModel> myList = [];

  @override
  void initState() {
    super.initState();
    count = widget.myList.length;
    myList = widget.myList;
  }

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

  List<DropdownMenuItem<String>> animeType() {
    final data = ["All", "TV", "OVA", "ONA", "Movie", "Special"];

    List<DropdownMenuItem<String>> array = data.map((item) {
      return DropdownMenuItem(
        value: item,
        child: Text(item),
      );
    }).toList();

    return array;
  }

  List<DropdownMenuItem<String>> sortType() {
    final data = {
      "all": "Not sorted",
      "name": "Alphabetical",
      "score": "Score",
      "progress": "Watched Progress",
    };

    List<DropdownMenuItem<String>> array = [];

    data.forEach((key, value) {
      array.add(DropdownMenuItem(
        value: key,
        child: Text(value),
      ));
    });

    return array;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                menuItemStyleData: MenuItemStyleData(
                  selectedMenuItemBuilder: (context, child) {
                    return Container(
                      color: Colors.blue,
                      child: child,
                    );
                  },
                ),
                value: type,
                items: animeType(),
                onChanged: (value) {
                  if (value is String) {
                    List<MyListModel> list = [];

                    if (value == "All") {
                      list = widget.myList;
                    } else {
                      list = widget.myList.where((item) {
                        return item.type == value;
                      }).toList();
                    }

                    list.sort((a, b) {
                      switch (sort) {
                        case "name":
                          return a.title!
                              .toLowerCase()
                              .compareTo(b.title!.toLowerCase());
                        case "score":
                          return a.score! - b.score!;
                        case "progress":
                          return a.progress! - b.progress!;
                        default:
                          return 0;
                      }
                    });

                    setState(() {
                      type = value;
                      myList = list;
                    });
                  }
                },
              ),
            ),
            Text("${kDot(count)} Entries"),
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                menuItemStyleData: MenuItemStyleData(
                  selectedMenuItemBuilder: (context, child) {
                    return Container(
                      color: Colors.blue,
                      child: child,
                    );
                  },
                ),
                customButton: const Icon(
                  Icons.list,
                  size: 46,
                ),
                value: sort,
                items: sortType(),
                onChanged: (value) {
                  if (value is String) {
                    List<MyListModel> list = [];

                    if (type == "All") {
                      list = widget.myList;
                    } else {
                      list = widget.myList.where((item) {
                        return item.type == type;
                      }).toList();
                    }

                    list.sort((a, b) {
                      switch (value) {
                        case "name":
                          return a.title!
                              .toLowerCase()
                              .compareTo(b.title!.toLowerCase());
                        case "score":
                          return a.score! - b.score!;
                        case "progress":
                          return a.progress! - b.progress!;
                        default:
                          return 0;
                      }
                    });

                    setState(() {
                      sort = value;
                      myList = list;
                    });
                  }
                },
                dropdownStyleData: DropdownStyleData(
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  offset: const Offset(0, 8),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return sbHeight;
            },
            itemCount: myList.length,
            itemBuilder: (context, index) {
              return Builder(builder: (context) {
                return MyListListItem(
                  item: context.select((MyListProvider value) {
                    if (widget.myList.length !=
                        value.userMyList.where((element) {
                          if (widget.state == "All") {
                            return true;
                          } else {
                            return element.state == widget.state;
                          }
                        }).length) {
                      return null;
                    }
                    if (widget.myList.length != myList.length) {
                      return value
                          .getItem(value.userMyList.indexWhere((element) {
                        return element.id == myList[index].id;
                      }));
                    } else {
                      if (widget.state == "All") {
                        return value.getItem(index);
                      } else {
                        return value.getItemState(index, widget.state);
                      }
                    }
                  }),
                );
              });
            },
          ),
        ),
      ],
    );
  }
}
