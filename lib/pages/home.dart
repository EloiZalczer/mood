import 'package:flutter/material.dart';
import 'package:mood/widgets/menu_drawer.dart';
import 'package:mood/widgets/mood_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _calendarKey = GlobalKey<State<MoodCalendar>>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("mood"),
        backgroundColor: Colors.purple.shade100,
        actions: [
          IconButton(
            onPressed: () {
              _key.currentState!.openEndDrawer();
            },
            icon: Icon(Icons.menu),
          ),
        ],
      ),
      endDrawer: MenuDrawer(),
      body: SafeArea(child: MoodCalendar(key: _calendarKey)),
    );
  }
}
