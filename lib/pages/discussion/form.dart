import 'package:flutter/material.dart';
import 'package:flutter_jikan/components/scaffod.dart';
import 'package:flutter_jikan/enums/club.dart';
import 'package:flutter_jikan/extension/home.dart';
import 'package:flutter_jikan/firebase/auth/home.dart';
import 'package:flutter_jikan/firebase/database/club.dart';
import 'package:flutter_jikan/firebase/store/club.dart';
import 'package:flutter_jikan/models/jsons/club.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:uuid/uuid.dart';

class DiscussionFormPage extends StatefulWidget {
  const DiscussionFormPage({super.key});

  @override
  State<DiscussionFormPage> createState() => _DiscussionFormPageState();
}

class _DiscussionFormPageState extends State<DiscussionFormPage> {
  AccessClubType? access = AccessClubType.public;

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }

  final sbHeight = const SizedBox(height: 20);
  final formKey = GlobalKey<FormState>();
  final club = ClubModel();

  InputDecoration decoration(String text) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      label: Text(text),
      floatingLabelStyle: const TextStyle(),
    );
  }

  List<DropdownMenuItem<int>> categoryType() {
    List<DropdownMenuItem<int>> array = [];

    final n = CategoryClubType.values.length;
    for (var i = 0; i < n; i++) {
      final item = CategoryClubType.values[i].name;
      array.add(DropdownMenuItem(
        value: i,
        child: Text(item.toTitleCase()),
      ));
    }

    return array;
  }

  List<Widget> accessRadio() {
    List<Widget> array = [];

    final n = AccessClubType.values.length;
    for (var i = 0; i < n; i++) {
      final item = AccessClubType.values[i];
      array.add(RadioListTile<AccessClubType>(
        title: Text(item.name.toCapitalized()),
        subtitle: Text(item.subtitle),
        value: item,
        groupValue: access,
        onChanged: (value) {
          setState(() {
            access = value;
          });
        },
      ));
    }

    return array;
  }

  Future<void> onSubmit() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();

      final uuid = const Uuid().v4();

      club.id = uuid;
      club.dateCreate = DateTime.now().toIso8601String();
      club.userId = auth.uid;
      club.access = AccessClubType.values[access?.index ?? 0].name;

      await ClubStore.addClub(club).then((value) async {
        await ClubReal.addManyHost(
          userId: auth.uid,
          userName: auth.info["name"],
          userImage: auth.info["imageUrl"],
          clubId: uuid,
        );

        if (mounted) {
          context.pop();
        }
      }, onError: (error) => debugPrint("Error: $error"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      drawer: null,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                sbHeight,
                TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: decoration("Club name"),
                  validator: (value) {
                    if (value is String) {
                      if (value.isEmpty || value == "") {
                        return "Please enter club name";
                      }
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    club.name = newValue;
                  },
                ),
                sbHeight,
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  decoration: decoration("Club description"),
                  validator: (value) {
                    if (value is String) {
                      if (value.isEmpty || value == "") {
                        return "Please enter club description";
                      }
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    club.description = newValue;
                  },
                ),
                sbHeight,
                DropdownButtonHideUnderline(
                  child: DropdownButtonFormField(
                    decoration: decoration("Club category"),
                    value: 0,
                    items: categoryType(),
                    onChanged: (value) {},
                    onSaved: (newValue) {
                      final index = newValue ?? 0;
                      club.category = CategoryClubType.values[index].name;
                    },
                  ),
                ),
                sbHeight,
                ...accessRadio(),
                sbHeight,
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: onSubmit,
                    child: const Text("Create club"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DiscussionFormAlert extends StatefulWidget {
  final ClubModel club;

  const DiscussionFormAlert({
    super.key,
    required this.club,
  });

  @override
  State<DiscussionFormAlert> createState() => _DiscussionFormAlertState();
}

class _DiscussionFormAlertState extends State<DiscussionFormAlert> {
  AccessClubType? access = AccessClubType.public;

  @override
  void initState() {
    super.initState();

    access = AccessClubType.values[AccessClubType.values.indexWhere((element) {
      return element.name == widget.club.access;
    })];
  }

  final sbHeight = const SizedBox(height: 20);
  final formKey = GlobalKey<FormState>();
  final club = ClubModel();

  InputDecoration decoration(String text) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      label: Text(text),
      floatingLabelStyle: const TextStyle(),
    );
  }

  List<DropdownMenuItem<int>> categoryType() {
    List<DropdownMenuItem<int>> array = [];

    final n = CategoryClubType.values.length;
    for (var i = 0; i < n; i++) {
      final item = CategoryClubType.values[i].name;
      array.add(DropdownMenuItem(
        value: i,
        child: Text(item.toTitleCase()),
      ));
    }

    return array;
  }

  List<Widget> accessRadio() {
    List<Widget> array = [];

    final n = AccessClubType.values.length;
    for (var i = 0; i < n; i++) {
      final item = AccessClubType.values[i];
      array.add(RadioListTile<AccessClubType>(
        title: Text(item.name.toCapitalized()),
        subtitle: Text(item.subtitle),
        value: item,
        groupValue: access,
        onChanged: (value) {
          setState(() {
            access = value;
          });
        },
      ));
    }

    return array;
  }

  Future<void> onSubmit() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();

      club.id = widget.club.id;
      club.dateCreate = widget.club.dateCreate;
      club.userId = widget.club.userId;
      club.access = AccessClubType.values[access?.index ?? 0].name;

      await ClubStore.updateClub(club).then((value) async {
        if (mounted) {
          context.pop();
        }
      }, onError: (error) => debugPrint("Error: $error"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text("Edit Club Form!"),
      ),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              sbHeight,
              TextFormField(
                initialValue: widget.club.name,
                keyboardType: TextInputType.name,
                decoration: decoration("Club name"),
                validator: (value) {
                  if (value is String) {
                    if (value.isEmpty || value == "") {
                      return "Please enter club name";
                    }
                  }

                  return null;
                },
                onSaved: (newValue) {
                  club.name = newValue;
                },
              ),
              sbHeight,
              TextFormField(
                initialValue: widget.club.description,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                decoration: decoration("Club description"),
                validator: (value) {
                  if (value is String) {
                    if (value.isEmpty || value == "") {
                      return "Please enter club description";
                    }
                  }

                  return null;
                },
                onSaved: (newValue) {
                  club.description = newValue;
                },
              ),
              sbHeight,
              DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  decoration: decoration("Club category"),
                  value: CategoryClubType.values.indexWhere((element) {
                    return element.name == widget.club.category;
                  }),
                  items: categoryType(),
                  onChanged: (value) {},
                  onSaved: (newValue) {
                    final index = newValue ?? 0;
                    club.category = CategoryClubType.values[index].name;
                  },
                ),
              ),
              sbHeight,
              ...accessRadio(),
              sbHeight,
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: onSubmit,
                  child: const Text("Edit club"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
