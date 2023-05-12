import 'package:flutter/material.dart';
import 'package:flutter_jikan/enums/club.dart';
import 'package:flutter_jikan/models/jsons/user.dart';
import 'package:flutter_jikan/pages/discussion/club/member.dart';
import 'package:flutter_jikan/pages/discussion/club/post/home.dart';

class DiscussionClubTabbar extends StatefulWidget {
  final String clubId;
  final List<UserMemberModel> list;

  const DiscussionClubTabbar({
    super.key,
    required this.clubId,
    required this.list,
  });

  @override
  State<DiscussionClubTabbar> createState() => _DiscussionClubTabbarState();
}

class _DiscussionClubTabbarState extends State<DiscussionClubTabbar>
    with TickerProviderStateMixin {
  int tabIndex = 0;

  late TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(
      length: tabs.length,
      vsync: this,
    )..addListener(() {
        setState(() {
          tabIndex = controller.index;
        });
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final tabs = [
    const Text("Posts"),
    const Text("Members"),
  ];

  final sbHeight = const SizedBox(height: 20);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Colors.blue,
            child: TabBar(
              controller: controller,
              tabs: tabs,
              labelPadding: const EdgeInsets.all(10),
              indicator: const BoxDecoration(
                color: Colors.green,
              ),
            ),
          ),
        ),
        sbHeight,
        [
          DiscussionClubPost(
            clubId: widget.clubId,
            members: widget.list,
          ),
          DiscussionClubMember(
            clubId: widget.clubId,
            list: widget.list.where((item) {
              return item.role != RoleClubType.none.name;
            }).toList(),
          ),
        ][tabIndex],
      ],
    );
  }
}
