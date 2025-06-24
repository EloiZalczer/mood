import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About")),
      body: Center(
        child: Column(
          spacing: 16.0,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text("mood"), Text("Built by @EloiZalczer")],
        ),
      ),
    );
  }
}
