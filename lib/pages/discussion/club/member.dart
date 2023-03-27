import 'package:flutter/material.dart';
import 'package:flutter_jikan/enums/club.dart';
import 'package:flutter_jikan/extension/home.dart';
import 'package:flutter_jikan/firebase/auth/home.dart';
import 'package:flutter_jikan/firebase/database/club.dart';
import 'package:flutter_jikan/firebase/store/club.dart';
import 'package:flutter_jikan/main.dart';
import 'package:flutter_jikan/models/jsons/user.dart';
import 'package:flutter_jikan/models/providers/theme.dart';

class DiscussionClubMember extends StatelessWidget {
  final String clubId;
  final List<UserMemberModel> list;

  const DiscussionClubMember({
    super.key,
    required this.clubId,
    required this.list,
  });

  Widget listTile(UserMemberModel item) {
    bool theme = DarkThemeProvider().darkTheme;
    return ListTile(
      shape: Border.symmetric(
        horizontal: BorderSide(
          color: theme ? Colors.black : Colors.cyan,
        ),
      ),
      title: Text(item.name ?? ""),
      trailing: Text((item.role ?? "").toCapitalized()),
    );
  }

  Widget wrapTile(bool check) {
    return Wrap(
      runSpacing: 20,
      children: list.map((item) {
        if (!check) {
          return listTile(item);
        } else {
          return PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case "user":
                  break;
                case "host":
                  ClubReal.updateRoleMember(
                    clubId: clubId,
                    userId: item.id ?? "",
                    role: RoleClubType.host.name,
                  );
                  break;
                case "admin":
                  ClubReal.updateRoleMember(
                    clubId: clubId,
                    userId: item.id ?? "",
                    role: RoleClubType.admin.name,
                  );
                  break;
                case "member":
                  ClubReal.updateRoleMember(
                    clubId: clubId,
                    userId: item.id ?? "",
                    role: RoleClubType.member.name,
                  );
                  break;
                case "leave":
                  ClubReal.deleteManyMember(
                    clubId: clubId,
                    userId: item.id ?? "",
                  ).then((value) {
                    ClubStore.updateMembersClub(
                      clubId,
                      list.length - 1,
                    );
                  });
                  break;
              }
            },
            itemBuilder: (context) {
              final user = list.firstWhere((element) {
                return element.id == auth.uid;
              });

              final host = (user.role ?? "") == RoleClubType.host.name;
              final admin = (user.role ?? "") == RoleClubType.admin.name;

              return [
                const PopupMenuItem(
                  value: "user",
                  child: Text("User Page"),
                ),
                if (host && item.id != user.id) ...[
                  if (item.role == RoleClubType.admin.name) ...[
                    const PopupMenuItem(
                      value: "host",
                      child: Text("Host Role"),
                    ),
                  ],
                  if (item.role != RoleClubType.admin.name) ...[
                    const PopupMenuItem(
                      value: "admin",
                      child: Text("Admin Role"),
                    ),
                  ],
                  if (item.role != RoleClubType.member.name) ...[
                    const PopupMenuItem(
                      value: "member",
                      child: Text("Member Role"),
                    ),
                  ],
                ],
                if ((host || admin) &&
                    item.role != RoleClubType.host.name &&
                    item.role != RoleClubType.admin.name &&
                    item.id != user.id) ...[
                  const PopupMenuItem(
                    value: "leave",
                    child: Text("Leave Club"),
                  ),
                ],
              ];
            },
            child: listTile(item),
          );
        }
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return authBuild(
      none: wrapTile(false),
      done: wrapTile(true),
    );
  }
}

class DiscussionClubMemberAlert extends StatelessWidget {
  final String clubId;
  final int members;
  final List<UserMemberModel> list;

  const DiscussionClubMemberAlert({
    super.key,
    required this.clubId,
    required this.members,
    required this.list,
  });

  final sbWidth = const SizedBox(width: 10);

  Widget rowBtn({
    required void Function()? onClose,
    required void Function()? onCheck,
  }) {
    return Row(
      children: [
        sbWidth,
        InkWell(
          onTap: onClose,
          child: const Icon(
            Icons.close,
            color: Colors.red,
          ),
        ),
        sbWidth,
        InkWell(
          onTap: onCheck,
          child: const Icon(
            Icons.check,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text("Waiting to Accept"),
      ),
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("List User"),
              rowBtn(
                onClose: () {
                  for (final element in list) {
                    ClubReal.deleteManyMember(
                      clubId: clubId,
                      userId: element.id ?? "",
                    );
                  }
                },
                onCheck: () {
                  for (final element in list) {
                    ClubReal.updateRoleMember(
                      clubId: clubId,
                      userId: element.id ?? "",
                      role: RoleClubType.member.name,
                    ).then((value) {
                      ClubStore.updateMembersClub(
                        clubId,
                        members + 1,
                      );
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Flexible(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const CircleAvatar(),
                          sbWidth,
                          Flexible(
                            child: Text(item.name ?? ""),
                          ),
                        ],
                      ),
                    ),
                    rowBtn(
                      onClose: () {
                        ClubReal.deleteManyMember(
                          clubId: clubId,
                          userId: item.id ?? "",
                        );
                      },
                      onCheck: () {
                        ClubReal.updateRoleMember(
                          clubId: clubId,
                          userId: item.id ?? "",
                          role: RoleClubType.member.name,
                        ).then((value) {
                          ClubStore.updateMembersClub(
                            clubId,
                            members + 1,
                          );
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
