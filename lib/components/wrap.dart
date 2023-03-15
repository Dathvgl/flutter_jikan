import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class WrapDart extends StatefulWidget {
  final double? width;
  final double? extraWidth;
  final double runSpacing;
  final int? columnCount;
  final List<Tuple2<GlobalKey, Widget>> children;

  const WrapDart({
    super.key,
    this.width,
    this.extraWidth,
    this.runSpacing = 0,
    this.columnCount,
    this.children = const [],
  });

  @override
  State<WrapDart> createState() => _WrapDartState();
}

class _WrapDartState extends State<WrapDart> {
  GlobalKey globalKey = GlobalKey();
  double spacing = 0;

  @override
  void initState() {
    super.initState();

    if (widget.children.isNotEmpty) {
      globalKey = widget.children.first.item1;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        spacing = spacingAlt(context: context);
      });
    });
  }

  double spacingAlt({
    required BuildContext context,
  }) {
    final row = widget.width ?? MediaQuery.of(context).size.width;

    if (widget.columnCount != null && widget.children.isNotEmpty) {
      final child = globalKey.currentContext?.size?.width ?? 0;
      final extra = widget.extraWidth ?? 0;
      final count = widget.columnCount ?? 0;
      return row - extra - child * count;
    }else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: widget.runSpacing,
      children: widget.children.map((item) => item.item2).toList(),
    );
  }
}
