import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ExpandDart extends StatelessWidget {
  final Widget less;
  final Widget more;
  final String lessText;
  final String moreText;

  const ExpandDart({
    super.key,
    required this.less,
    required this.more,
    required this.lessText,
    required this.moreText,
  });

  final sbHeight = const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: ExpandablePanel(
        collapsed: Column(
          children: [
            less,
            sbHeight,
            Align(
              alignment: Alignment.centerRight,
              child: ExpandableButton(
                child: Text(
                  lessText,
                  style: const TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
        expanded: Column(
          children: [
            more,
            sbHeight,
            Align(
              alignment: Alignment.centerRight,
              child: ExpandableButton(
                child: Text(
                  moreText,
                  style: const TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
