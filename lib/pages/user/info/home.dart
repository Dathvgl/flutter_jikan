import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jikan/components/scaffod.dart';
import 'package:flutter_jikan/firebase/auth/home.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "User Info",
      drawer: null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                AspectRatio(
                  aspectRatio: 0.75,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: auth.info["image"] ?? "",
                    progressIndicatorBuilder: (context, url, progress) {
                      return CircularProgressIndicator(
                        value: progress.progress,
                      );
                    },
                    errorWidget: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                ),
                Column(
                  children: [
                    Text(auth.info["name"] ?? "Unknown"),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: const Text("Edit Profile"),
                      onPressed: () {
                        // context.push("");
                      },
                    ),
                  ],
                ),
              ],
            ),
            Row(),
          ],
        ),
      ),
    );
  }
}
