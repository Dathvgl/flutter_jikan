import 'package:flutter/material.dart';

class MusicDart extends StatelessWidget {
  const MusicDart({super.key});

  Stream<int> getSecondsFromCurrentMinute() async* {
    final now = DateTime.now();
    final seconds = now.second;
    yield seconds;
    await Future.delayed(Duration(seconds: 1 - seconds));
    yield* getSecondsFromCurrentMinute();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: getSecondsFromCurrentMinute(),
      builder: (context, AsyncSnapshot<int> snapshot) {
        double percentageOfSecond = (snapshot.data ?? 0) / 60;
        return SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    value: percentageOfSecond,
                    valueColor: const AlwaysStoppedAnimation(
                      Colors.red,
                    ),
                    backgroundColor: Colors.red.withOpacity(0.15),
                  ),
                ),
              ),
              // the play arrow, inside the circle
              Positioned(
                top: 0,
                left: 0,
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: IconButton(
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.red,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
