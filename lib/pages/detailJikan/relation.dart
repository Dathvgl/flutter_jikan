import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';

class RelationDart extends StatelessWidget {
  final BuiltList<Relation>? relations;

  const RelationDart({
    super.key,
    required this.relations,
  });

  @override
  Widget build(BuildContext context) {
    if (relations == null) {
      return const SizedBox();
    } else {
      BuiltList<Relation> list = relations!;
      return IntrinsicHeight(
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list.map((item) => Text(item.relation)).toList(),
            ),
            const SizedBox(
              width: 20,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: list
                    .map((item) => TextButton(
                          onPressed: () {},
                          child: Text(
                            item.entry.first.name,
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      );
    }
  }
}
