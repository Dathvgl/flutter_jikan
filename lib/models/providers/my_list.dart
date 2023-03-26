import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jikan/firebase/auth/home.dart';
import 'package:flutter_jikan/firebase/database/my_list.dart';
import 'package:flutter_jikan/models/jsons/my_list.dart';

class MyListProvider with ChangeNotifier {
  List<int> _userMalId = [];

  List<int> get userMalId => _userMalId;

  List<MyListModel> _userMyList = [];

  List<MyListModel> get userMyList => _userMyList;

  StreamSubscription<DatabaseEvent>? listen;

  set userMyList(List<MyListModel> list) {
    _userMalId = list.map((item) => item.malId ?? 0).toList();
    _userMyList = list;
    notifyListeners();
  }

  MyListModel getItem(int index) => _userMyList[index];

  MyListModel getItemState(int index, String state) {
    return _userMyList.where((element) {
      return element.state == state;
    }).toList()[index];
  }

  void setItem(int index, MyListModel value) {
    _userMyList[index] = value;
    notifyListeners();
  }

  void init() {
    if (auth.isAuthen) {
      final stream = MyListReal.getUserList(uid: auth.uid);
      listen = stream.listen((event) {
        if (!event.snapshot.exists) {
          userMyList = [];
        }

        List<MyListModel> list = [];
        final data = event.snapshot.value;

        if (data != null) {
          Map<String, Object>.from(data as Map).forEach((key, value) {
            final map = value as Map;
            Map<String, dynamic> myListItem = {};

            myListItem["id"] = key;
            map.forEach((key, value) {
              myListItem[key.toString()] = value;
            });

            list.add(MyListModel.fromJson(myListItem));
          });

          if (userMyList.length != list.length) {
            userMyList = list;
          } else {
            final result = IterableZip([userMyList, list])
                .mapIndexed((index, element) {
                  return element[0] == element[1] ? null : index;
                })
                .whereNotNull()
                .toList();

            for (final item in result) {
              setItem(item, list[item]);
            }
          }
        }
      });
      // stream.listen((event) {
      //   List<MyListModel> list = [];
      //   final data = event.snapshot.value;

      //   if (data != null) {
      //     Map<String, Object>.from(data as Map).forEach((key, value) {
      //       final map = value as Map;
      //       Map<String, dynamic> myListItem = {};

      //       myListItem["id"] = key;
      //       map.forEach((key, value) {
      //         myListItem[key.toString()] = value;
      //       });

      //       list.add(MyListModel.fromJson(myListItem));
      //     });

      //     if (userMyList.length != list.length) {
      //       userMyList = list;
      //     } else {
      //       final result = IterableZip([userMyList, list])
      //           .mapIndexed((index, element) {
      //             return element[0] == element[1] ? null : index;
      //           })
      //           .whereNotNull()
      //           .toList();

      //       for (final item in result) {
      //         setItem(item, list[item]);
      //       }
      //     }
      //   }
      // });
    }
  }

  void clear() {
    userMyList = [];
  }
}
