import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jikan/firebase/store/club.dart';
import 'package:flutter_jikan/models/jsons/club.dart';
import 'package:flutter_jikan/pages/discussion/tile.dart';
import 'package:go_router_flow/go_router_flow.dart';

class DiscussionPage extends StatefulWidget {
  const DiscussionPage({super.key});

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  List<ClubModel> listChange = [];
  List<ClubModel> listReal = [];

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? listenClub;

  @override
  void initState() {
    super.initState();

    listenClub = ClubStore.listenClub().listen((event) {
      List<ClubModel> list = [];

      for (final query in event.docs) {
        final data = query.data();
        list.add(ClubModel.fromJson(data));
      }

      list.sort((a, b) {
        final dateOne = DateTime.parse(a.dateCreate ?? "");
        final dateTwo = DateTime.parse(b.dateCreate ?? "");
        return dateOne.compareTo(dateTwo) * -1;
      });

      setState(() {
        listChange = list;
        listReal = list.where((element) {
          return element.name
                  ?.toLowerCase()
                  .contains(textController.text.toLowerCase()) ??
              true;
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    listenClub?.cancel();
    textController.dispose();
    super.dispose();
  }

  final textController = TextEditingController(text: "");
  final sbWidth = const SizedBox(width: 10);
  final sbHeight = const SizedBox(height: 10);

  void updateList(String value) {
    setState(() {
      listReal = listChange.where((element) {
        return element.name?.toLowerCase().contains(value.toLowerCase()) ??
            true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  controller: textController,
                  onChanged: (value) => updateList(value),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: "Search",
                  ),
                ),
              ),
              sbWidth,
              const Icon(Icons.search),
            ],
          ),
        ),
        sbHeight,
        DiscussionHeroTile(
          subtitle: "Tab here to view",
          onTap: () => context.push(
            "/discussion/myClub",
            extra: listReal,
          ),
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return const Divider(
                color: Colors.lime,
                height: 5,
                thickness: 3,
              );
            },
            itemCount: listReal.length,
            itemBuilder: (context, index) {
              final club = listReal[index];
              return DiscussionItemTile(club: club);
            },
          ),
        ),
      ],
    );
  }
}
