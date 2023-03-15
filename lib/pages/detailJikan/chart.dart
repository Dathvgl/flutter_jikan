import 'package:flutter/material.dart';
import 'package:flutter_jikan/main.dart';
import 'package:intl/intl.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ItemChart {
  final String key;
  final int? value;

  ItemChart({
    required this.key,
    required this.value,
  });
}

class ChartDart extends StatelessWidget {
  final List<ItemChart> list;

  const ChartDart({
    super.key,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      series: [
        BarSeries<ItemChart, String>(
          dataSource: list,
          xValueMapper: (datum, index) => datum.key,
          yValueMapper: (datum, index) => datum.value,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        numberFormat: NumberFormat.compact(),
      ),
    );
  }
}

class StatisticsDart extends StatelessWidget {
  final Future<Stats> stats;

  const StatisticsDart({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: stats,
      builder: (context, snapshot) {
        final item = snapshot.data;
        if (item == null) {
          return const Text("Loading");
        } else {
          return httpBuild(
            snapshot: snapshot,
            widget: Column(
              children: [
                ChartDart(
                  list: [
                    ItemChart(
                      key: "Watching",
                      value: item.watching,
                    ),
                    ItemChart(
                      key: "Completed",
                      value: item.completed,
                    ),
                    ItemChart(
                      key: "On Hold",
                      value: item.onHold,
                    ),
                    ItemChart(
                      key: "Dropped",
                      value: item.dropped,
                    ),
                    ItemChart(
                      key: "Plan to Watch",
                      value: item.planToWatch,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("All members ${kDot(item.total)}"),
                ),
                const SizedBox(
                  height: 30,
                ),
                ChartDart(
                  list: item.scores.map((child) {
                    return ItemChart(
                      key: child.score.toString(),
                      value: child.votes,
                    );
                  }).toList(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("Scored members ${kDot(item.scores.map(
                        (child) => child.votes,
                      ).reduce((prev, next) => prev + next))}"),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
