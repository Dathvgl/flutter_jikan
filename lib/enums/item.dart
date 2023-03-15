import 'package:flutter/material.dart';

enum ItemStateType {
  watching,
  completed,
  planToWatch,
  onHold,
  dropped;

  String get name {
    switch (this) {
      case ItemStateType.watching:
        return "Watching";
      case ItemStateType.completed:
        return "Completed";
      case ItemStateType.planToWatch:
        return "Plan to Watch";
      case ItemStateType.onHold:
        return "On Hold";
      case ItemStateType.dropped:
        return "Dropped";
    }
  }

  Color get color {
    switch (this) {
      case ItemStateType.watching:
        return Colors.green;
      case ItemStateType.completed:
        return Colors.blueAccent;
      case ItemStateType.planToWatch:
        return Colors.red;
      case ItemStateType.onHold:
        return Colors.purple;
      case ItemStateType.dropped:
        return Colors.grey;
    }
  }
}
