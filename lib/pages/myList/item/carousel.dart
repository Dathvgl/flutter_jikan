import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

const _width = 60.0;
const _height = 50.0;

Widget _selected = SizedBox(
  width: double.infinity,
  child: Center(
    child: Container(
      width: _width,
      height: _height,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 3,
          color: Colors.blueAccent,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
);

Widget _carousel({
  bool reverse = false,
  required int defaultIndex,
  required CarouselController controller,
  required List list,
  required void Function({required int index}) carouselIndex,
  required void Function({required int index}) carouselPage,
}) {
  return SizedBox(
    width: double.infinity,
    height: _height,
    child: CarouselSlider(
      carouselController: controller,
      options: CarouselOptions(
        initialPage: defaultIndex,
        aspectRatio: 1,
        reverse: reverse,
        enableInfiniteScroll: false,
        viewportFraction: 0.2,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index, reason) {
          carouselPage(index: index);
        },
      ),
      items: List.generate(list.length, (index) {
        return InkWell(
          onTap: () => carouselIndex(index: index),
          child: Container(
            width: _width,
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(index.toString()),
            ),
          ),
        );
      }),
    ),
  );
}

class MyListItemCarouselEmpty extends StatelessWidget {
  final int defaultIndex;
  final List<int> list;
  final void Function({required int num}) callbackItem;

  const MyListItemCarouselEmpty({
    super.key,
    this.defaultIndex = 0,
    required this.list,
    required this.callbackItem,
  });

  @override
  Widget build(BuildContext context) {
    final controller = CarouselController();

    void carouselIndex({
      required int index,
    }) {
      controller.animateToPage(index);
      callbackItem(num: index);
    }

    void carouselPage({
      required int index,
    }) {
      callbackItem(num: index);
    }

    return Stack(
      children: [
        _selected,
        _carousel(
          defaultIndex: defaultIndex,
          controller: controller,
          list: list,
          carouselIndex: carouselIndex,
          carouselPage: carouselPage,
        )
      ],
    );
  }
}

class MyListItemCarouselString extends StatefulWidget {
  final bool reverse;
  final int defaultIndex;
  final List<String> list;
  final void Function({required int num}) callbackItem;

  const MyListItemCarouselString({
    super.key,
    this.reverse = false,
    this.defaultIndex = 0,
    required this.list,
    required this.callbackItem,
  });

  @override
  State<MyListItemCarouselString> createState() =>
      _MyListItemCarouselStringState();
}

class _MyListItemCarouselStringState extends State<MyListItemCarouselString> {
  final controller = CarouselController();

  String label = "Label";

  @override
  void initState() {
    super.initState();

    setState(() {
      label = widget.list.first.toString();
    });
  }

  void carouselIndex({
    required int index,
  }) {
    controller.animateToPage(index);
    carouselPage(index: index);
  }

  void carouselPage({
    required int index,
  }) {
    widget.callbackItem(num: index);

    setState(() {
      label = widget.list[index].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(label),
        ),
        const SizedBox(
          height: 10,
        ),
        Stack(
          children: [
            _selected,
            _carousel(
              reverse: widget.reverse,
              defaultIndex: widget.defaultIndex,
              controller: controller,
              list: widget.list,
              carouselIndex: carouselIndex,
              carouselPage: carouselPage,
            )
          ],
        ),
      ],
    );
  }
}
