import 'package:flutter/material.dart';
import 'package:mood/widgets/mood_chart.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Statistics")),
      body: Center(child: MoodChart()),
    );
  }
}
