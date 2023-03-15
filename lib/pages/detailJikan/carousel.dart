import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jikan/main.dart';
import 'package:flutter_jikan/models/jikan.dart';
import 'package:jikan_api/jikan_api.dart';

class CarouselDart extends StatelessWidget {
  final Future<List<Picture>> images;

  const CarouselDart({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: FutureBuilder(
        future: images,
        builder: (context, snapshot) {
          List<Picture> images = snapshot.data ?? [];
          return httpBuild(
            snapshot: snapshot,
            widget: CarouselSlider(
              options: CarouselOptions(
                initialPage: 0,
                aspectRatio: 0.9,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
              ),
              items: images.map((item) {
                return JikanRoot.imageBase(
                  url: item.imageUrl,
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
