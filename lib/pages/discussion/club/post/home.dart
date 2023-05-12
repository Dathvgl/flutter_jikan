import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jikan/components/circle_avatar.dart';
import 'package:flutter_jikan/firebase/auth/home.dart';
import 'package:flutter_jikan/firebase/database/post.dart';
import 'package:flutter_jikan/models/jsons/post.dart';
import 'package:flutter_jikan/models/jsons/user.dart';
import 'package:flutter_jikan/pages/discussion/club/dialog.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../main.dart';

class DiscussionClubPost extends StatefulWidget {
  final String clubId;
  final List<UserMemberModel> members;

  const DiscussionClubPost({
    super.key,
    required this.clubId,
    required this.members,
  });

  @override
  State<DiscussionClubPost> createState() => _DiscussionClubPostState();
}

class _DiscussionClubPostState extends State<DiscussionClubPost> {
  List<PostModel> list = [];
  StreamSubscription<DatabaseEvent>? listen;

  @override
  void initState() {
    super.initState();

    listen = PostReal.getPosts(widget.clubId).listen((event) {
      final array = PostModel.init(event.snapshot);

      setState(() {
        list = array
          ..sort((a, b) {
            final dateOne = DateTime.parse(a.dateCreate ?? "");
            final dateTwo = DateTime.parse(b.dateCreate ?? "");
            return dateOne.compareTo(dateTwo) * -1;
          });
      });
    });
  }

  @override
  void dispose() {
    listen?.cancel();
    super.dispose();
  }

  Widget joinAuth({required Widget child}) {
    final user = widget.members.firstWhereOrNull((element) {
      try {
        return element.id == auth.uid;
      } catch (e) {
        return false;
      }
    });

    if (user == null) {
      return const SizedBox();
    } else {
      return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        authBuild(
          done: joinAuth(
            child: DiscussionClubDialog(
              openText: "Add Post",
              labelText: "Post content",
              submitText: "Create Post",
              onPressed: (text) {
                final item = PostModel(
                  id: const Uuid().v4(),
                  userId: auth.uid,
                  userName: auth.info["name"],
                  userImage: auth.info["imageUrl"],
                  content: text,
                  dateCreate: DateTime.now().toIso8601String(),
                );

                PostReal.setPost(
                  uid: widget.clubId,
                  userId: auth.uid,
                  data: item,
                );
              },
            ),
          ),
          none: const SizedBox(),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Wrap(
            runSpacing: 20,
            children: list.map((item) {
              return DiscussionClubPostItem(
                clubId: widget.clubId,
                post: item,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class DiscussionClubPostItem extends StatelessWidget {
  final String clubId;
  final PostModel post;

  const DiscussionClubPostItem({
    super.key,
    required this.clubId,
    required this.post,
  });

  final sbHeight = const SizedBox(height: 10);

  Widget bodyWidget(BuildContext context) {
    final date = DateTime.parse(post.dateCreate ?? "");
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    CircleAvatarDart(
                      backgroundImage: post.userImage,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.userName ?? "",
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(DateFormat.yMd().format(date)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (auth.isAuthen && post.userId == auth.uid) ...[
                InkWell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      SizedBox(width: 10),
                      Icon(Icons.close),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete Post?"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                  "Delete post and all comments in this post"),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  child: const Text("Yes"),
                                  onPressed: () {
                                    PostReal.deletePost(
                                      context: context,
                                      uid: clubId,
                                      userId: auth.uid,
                                      postId: post.id ?? "",
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ],
          ),
          sbHeight,
          Align(
            alignment: Alignment.topLeft,
            child: Text(post.content ?? ""),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(context).location;
    final routePush = "/discussion/club/$clubId/comment";

    return location == routePush
        ? bodyWidget(context)
        : InkWell(
            onTap: () {
              context.push(
                "/discussion/club/$clubId/comment",
                extra: {"clubId": clubId, "post": post},
              );
            },
            child: bodyWidget(context),
          );
  }
}
