import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jikan/components/scaffod.dart';
import 'package:flutter_jikan/enums/club.dart';
import 'package:flutter_jikan/extension/home.dart';
import 'package:flutter_jikan/firebase/auth/home.dart';
import 'package:flutter_jikan/firebase/database/club.dart';
import 'package:flutter_jikan/firebase/database/comment.dart';
import 'package:flutter_jikan/firebase/database/post.dart';
import 'package:flutter_jikan/firebase/store/club.dart';
import 'package:flutter_jikan/firebase/store/user.dart';
import 'package:flutter_jikan/main.dart';
import 'package:flutter_jikan/models/jsons/club.dart';
import 'package:flutter_jikan/models/jsons/user.dart';
import 'package:flutter_jikan/pages/discussion/club/member.dart';
import 'package:flutter_jikan/pages/discussion/club/tabber.dart';
import 'package:flutter_jikan/pages/discussion/form.dart';
import 'package:intl/intl.dart';

class DiscussionClubPage extends StatefulWidget {
  final ClubModel club;

  const DiscussionClubPage({
    super.key,
    required this.club,
  });

  @override
  State<DiscussionClubPage> createState() => _DiscussionClubPageState();
}

class _DiscussionClubPageState extends State<DiscussionClubPage> {
  List<UserMemberModel> members = [];
  StreamSubscription<DatabaseEvent>? membersListen;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? userListen;

  @override
  void initState() {
    super.initState();

    membersListen =
        ClubReal.getManyMember(widget.club.id ?? "").listen((event) {
      final array = UserMemberModel.init(event.snapshot);

      if (event.type != DatabaseEventType.childChanged) {
        userListen?.cancel();
        userListen = UserStore.listenUser(array.map((item) => item.id))
            .listen((event) async {
          for (final query in event.docChanges) {
            final data = query.doc.data() ?? {};

            final map = {
              "name": data["name"],
              "imageUrl": data["imageUrl"],
            };

            await ClubReal.updateManyMember(
              userId: data["id"],
              clubId: widget.club.id ?? "",
              map: map,
            );

            Map<String, dynamic> mapPost = {};
            final listPost = await PostReal.getIdPosts(
              clubId: widget.club.id ?? "",
              userId: data["id"],
            );

            for (final postId in listPost) {
              map.forEach((key, value) {
                mapPost["$postId/$key"] = value;
              });

              Map<String, dynamic> mapComment = {};
              final listComment = await CommentReal.getIdComments(
                postId: postId,
                userId: data["id"],
              );

              for (final commentId in listComment) {
                map.forEach((key, value) {
                  mapComment["$commentId/$key"] = value;
                });
              }

              if (listComment.isNotEmpty) {
                CommentReal.updateComments(
                  postId: postId,
                  userId: data["id"],
                  map: mapComment,
                );
              }
            }

            if (listPost.isNotEmpty) {
              PostReal.updatePosts(
                clubId: widget.club.id ?? "",
                userId: data["id"],
                map: map,
              );
            }
          }
        });
      }

      setState(() {
        members = array;
      });
    });
  }

  @override
  void dispose() {
    membersListen?.cancel();
    userListen?.cancel();
    super.dispose();
  }

  final sbHeight = const SizedBox(height: 20);

  Widget joinAuth(List<UserMemberModel> list) {
    final user = list.firstWhereOrNull((element) {
      try {
        return element.id == auth.uid;
      } catch (e) {
        return false;
      }
    });

    if (user == null) {
      return ElevatedButton(
        child: const Text("Join"),
        onPressed: () {
          ClubReal.addManyMember(
            userId: auth.uid,
            userName: auth.info["name"],
            userImage: auth.info["imageUrl"],
            clubId: widget.club.id ?? "",
            clubAccess: widget.club.access ?? AccessClubType.public.name,
            clubMembers: members.length,
          );
        },
      );
    } else {
      if (user.role == RoleClubType.none.name) {
        return const ElevatedButton(
          onPressed: null,
          child: Text("Waiting"),
        );
      } else {
        return const ElevatedButton(
          onPressed: null,
          child: Text("Joined"),
        );
      }
    }
  }

  Widget moreOption(List<UserMemberModel> list) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case "edit":
            showDialog(
              context: context,
              builder: (context) {
                return DiscussionFormAlert(club: widget.club);
              },
            );
            break;
          case "join":
            showDialog(
              context: context,
              builder: (context) {
                return DiscussionClubMemberAlert(
                  clubId: widget.club.id ?? "",
                  members: members.length,
                  list: list.where((item) {
                    return item.role == RoleClubType.none.name;
                  }).toList(),
                );
              },
            );
            break;
          case "leave":
            ClubReal.deleteManyMember(
              userId: auth.uid,
              clubId: widget.club.id ?? "",
            ).then((value) {
              ClubStore.updateMembersClub(
                widget.club.id ?? "",
                members.length - 1,
              );
            });
            break;
          // case "delete":
          //   break;
        }
      },
      itemBuilder: (context) {
        final user = list.firstWhereOrNull((element) {
          return element.id == auth.uid;
        });

        final host = (user?.role ?? "") == RoleClubType.host.name;
        final admin = (user?.role ?? "") == RoleClubType.admin.name;
        final member = (user?.role ?? "") == RoleClubType.member.name;

        return [
          if (host) ...[
            const PopupMenuItem(
              value: "edit",
              child: Text("Edit Club"),
            ),
          ],
          if (host || admin) ...[
            const PopupMenuItem(
              value: "join",
              child: Text("Join Notify"),
            ),
          ],
          if (admin || member) ...[
            const PopupMenuItem(
              value: "leave",
              child: Text("Leave Club"),
            ),
          ],
          // if (host) ...[
          //   const PopupMenuItem(
          //     value: "delete",
          //     child: Text("Delete Club"),
          //   ),
          // ],
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(widget.club.dateCreate ?? "");
    return CustomScaffold(
      drawer: null,
      title: "Club detail",
      body: ListView(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: widget.club.imageUrl ?? "",
              progressIndicatorBuilder: (context, url, progress) {
                return Center(
                  child: CircularProgressIndicator(
                    value: progress.progress,
                  ),
                );
              },
              errorWidget: (context, error, stackTrace) {
                return const SizedBox();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        widget.club.name ?? "",
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    authBuild(
                      none: const SizedBox(),
                      done: moreOption(members),
                    ),
                  ],
                ),
                sbHeight,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Access: ${(widget.club.access ?? "").toCapitalized()} club"),
                        Text("Created: ${DateFormat.yMd().format(date)}"),
                      ],
                    ),
                    authBuild(
                      done: joinAuth(members),
                      none: const SizedBox(),
                    ),
                  ],
                ),
                sbHeight,
                Text(widget.club.description ?? ""),
              ],
            ),
          ),
          sbHeight,
          DiscussionClubTabbar(
            clubId: widget.club.id ?? "",
            list: members,
          ),
        ],
      ),
    );
  }
}
