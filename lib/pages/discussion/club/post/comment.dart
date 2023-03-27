import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jikan/components/circle_avatar.dart';
import 'package:flutter_jikan/components/scaffod.dart';
import 'package:flutter_jikan/firebase/auth/home.dart';
import 'package:flutter_jikan/firebase/database/comment.dart';
import 'package:flutter_jikan/models/jsons/comment.dart';
import 'package:flutter_jikan/models/jsons/post.dart';
import 'package:flutter_jikan/pages/discussion/club/dialog.dart';
import 'package:flutter_jikan/pages/discussion/club/post/home.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class DiscussionClubPostComment extends StatefulWidget {
  final String clubId;
  final PostModel post;

  const DiscussionClubPostComment({
    super.key,
    required this.clubId,
    required this.post,
  });

  @override
  State<DiscussionClubPostComment> createState() =>
      _DiscussionClubPostCommentState();
}

class _DiscussionClubPostCommentState extends State<DiscussionClubPostComment> {
  List<CommentModel> list = [];
  StreamSubscription<DatabaseEvent>? listen;

  @override
  void initState() {
    super.initState();

    listen = CommentReal.getComments(widget.post.id ?? "").listen((event) {
      final array = CommentModel.init(event.snapshot);

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

  final sbHeight = const SizedBox(height: 20);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      drawer: null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DiscussionClubPostItem(clubId: widget.clubId, post: widget.post),
            sbHeight,
            DiscussionClubDialog(
              openText: "Add comment",
              labelText: "Comment content",
              submitText: "Add comment",
              onPressed: (text) {
                final item = CommentModel(
                  id: const Uuid().v4(),
                  userId: auth.uid,
                  userName: auth.info["name"],
                  content: text,
                  dateCreate: DateTime.now().toIso8601String(),
                );

                CommentReal.setComment(
                  uid: widget.post.id ?? "",
                  userId: auth.uid,
                  data: item,
                );
              },
            ),
            sbHeight,
            ListView.separated(
              shrinkWrap: true,
              primary: false,
              separatorBuilder: (context, index) {
                return const Divider(
                  indent: 0,
                  height: 5,
                  thickness: 3,
                );
              },
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                final date = DateTime.parse(item.dateCreate!);
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatarDart(
                          backgroundImage: item.userImage,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                textAlign: TextAlign.justify,
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: item.userName ?? "",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const WidgetSpan(
                                        child: SizedBox(width: 10)),
                                    TextSpan(
                                      text: DateFormat.yMd().format(date),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                item.content ?? "",
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
