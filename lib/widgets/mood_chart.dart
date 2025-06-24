import 'package:flutter/material.dart';
import 'package:mood/models/moods.dart';
import 'package:mood/utils.dart';
import 'package:provider/provider.dart';

class MoodChart extends StatelessWidget {
  const MoodChart({super.key});

  Future<Map<int, int>> _load(BuildContext context) =>
      context.read<MoodModel>().getStatistics();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 216,
      width: 240,
      child: FutureBuilder(
        future: _load(context),
        builder: (BuildContext context, AsyncSnapshot<Map<int, int>> snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;

            final total = data.entries
                .map<int>((e) => e.value)
                .reduce((a, b) => a + b);

            return Row(
              spacing: 10,
              children: [
                MoodColumn(
                  icon: Icons.sentiment_very_satisfied,
                  color: moodToColor(4),
                  relativeHeight: data.containsKey(4) ? data[4]! / total : 0,
                  maxHeight: 150,
                  count: data[4] ?? 0,
                ),
                MoodColumn(
                  icon: Icons.sentiment_satisfied,
                  color: moodToColor(3),
                  relativeHeight: data.containsKey(3) ? data[3]! / total : 0,
                  maxHeight: 150,
                  count: data[3] ?? 0,
                ),
                MoodColumn(
                  icon: Icons.sentiment_neutral,
                  color: moodToColor(2),
                  relativeHeight: data.containsKey(2) ? data[2]! / total : 0,
                  maxHeight: 150,
                  count: data[2] ?? 0,
                ),
                MoodColumn(
                  icon: Icons.sentiment_dissatisfied,
                  color: moodToColor(1),
                  relativeHeight: data.containsKey(1) ? data[1]! / total : 0,
                  maxHeight: 150,
                  count: data[1] ?? 0,
                ),
                MoodColumn(
                  icon: Icons.sentiment_very_dissatisfied,
                  color: moodToColor(0),
                  relativeHeight: data.containsKey(0) ? data[0]! / total : 0,
                  maxHeight: 150,
                  count: data[0] ?? 0,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("An error occurred"));
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class MoodColumn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double relativeHeight;
  final double maxHeight;
  final int count;
  final double width = 40;

  const MoodColumn({
    super.key,
    required this.icon,
    required this.color,
    required this.relativeHeight,
    required this.maxHeight,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: width),
        Spacer(),
        Container(
          height: maxHeight * relativeHeight,
          width: width,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
        ),
        Text(
          "$count",
          style: TextStyle(color: Colors.grey.shade500, fontSize: 16.0),
        ),
      ],
    );
  }
}
