import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleAvatarDart extends StatelessWidget {
  final Widget? child;
  final String? backgroundImage;

  const CircleAvatarDart({
    super.key,
    this.child = const Icon(Icons.person),
    this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    bool check = false;

    if (backgroundImage != null) {
      check = true;
    }

    return CircleAvatar(
      backgroundImage: backgroundImage == null
          ? null
          : CachedNetworkImageProvider(
              backgroundImage!,
            ),
      child: check ? null : child,
    );
  }
}
