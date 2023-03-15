import 'package:flutter/material.dart';
import 'package:flutter_jikan/models/jikan.dart';

class UserInfoListView extends StatelessWidget {
  const UserInfoListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
      itemCount: 0,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  JikanRoot.imageBase(
                    url: "url",
                  ),
                  Column(
                    children: const [
                      Text("Name"),
                      Text("Info"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
