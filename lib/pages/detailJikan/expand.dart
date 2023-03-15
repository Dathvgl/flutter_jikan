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

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: ExpandablePanel(
        collapsed: Column(
          children: [
            less,
            Align(
              alignment: Alignment.centerRight,
              child: ExpandableButton(
                child: Text(lessText),
              ),
            ),
          ],
        ),
        expanded: Column(
          children: [
            more,
            Align(
              alignment: Alignment.centerRight,
              child: ExpandableButton(
                child: Text(moreText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
