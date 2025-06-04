import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mood/database.dart';
import 'package:mood/dialogs/empty_day.dart';
import 'package:mood/dialogs/show_entry.dart';
import 'package:mood/models.dart';
import 'package:mood/notifications.dart';
import 'package:mood/structures.dart';
import 'package:mood/utils.dart';
import 'package:provider/provider.dart';

class MoodCalendar extends StatefulWidget {
  const MoodCalendar({super.key});

  @override
  State<MoodCalendar> createState() => _MoodCalendarState();
}

class _MoodCalendarState extends State<MoodCalendar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      final notificationsProvider = Provider.of<NotificationsProvider>(
        context,
        listen: false,
      );
      notificationsProvider.notificationResponses.listen((
        NotificationResponse response,
      ) {
        final today = DateTime.now();
        final entry = Provider.of<MoodModel>(
          context,
          listen: false,
        ).getEntry(today);

        if (entry == null) {
          if (mounted) onEmptyDayTapped(context, today);
        } else {
          if (mounted) onEntryDayTapped(context, entry);
        }
      });
    });
  }

  void onEmptyDayTapped(BuildContext context, DateTime day) {
    EmptyDayDialog.show(context, day);
  }

  void onEntryDayTapped(BuildContext context, MoodDailyEntry entry) {
    ShowEntryDialog.show(context, entry);
  }

  @override
  Widget build(BuildContext context) {
    var moodEntries = context.watch<MoodModel>();

    double height =
        MediaQuery.sizeOf(context).height - AppBar().preferredSize.height;

    double squareHeight = (height / 31).floorToDouble();

    final moodsByMonth = moodEntries.entriesByMonth;

    print(moodsByMonth);

    final sortedEntries = moodsByMonth.entries.sortedBy(
      (e) => "${e.key.year}${e.key.month}",
    );

    List<YearMonth> months;

    if (sortedEntries.isNotEmpty) {
      final firstEntry = sortedEntries[0];
      months = monthsSince(firstEntry.key.year, firstEntry.key.month);
    } else {
      months = [
        YearMonth(year: DateTime.now().year, month: DateTime.now().month),
      ];
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: months.length,
      itemBuilder: (context, index) {
        final List<Widget> children = [];

        final month = months[index];

        final monthlyEntries = moodsByMonth[month];

        final nbdays = daysInMonth(month.year, month.month);

        Map<int, MoodDailyEntry> entriesByDays = {};

        if (monthlyEntries != null) {
          entriesByDays = {
            for (var entry in monthlyEntries) entry.date.day: entry,
          };
        }

        for (var i = 1; i <= nbdays; i++) {
          final entry = entriesByDays[i];
          if (entry != null) {
            children.add(
              GestureDetector(
                onTap: () => onEntryDayTapped(context, entry),
                child: Container(
                  width: squareHeight,
                  height: squareHeight,
                  decoration: BoxDecoration(
                    color: moodToColor(entry.mood),
                    border: Border.all(color: Colors.black),
                  ),
                ),
              ),
            );
          } else {
            children.add(
              GestureDetector(
                onTap:
                    () => onEmptyDayTapped(
                      context,
                      DateTime(month.year, month.month, i),
                    ),
                child: Container(
                  width: squareHeight,
                  height: squareHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                ),
              ),
            );
          }
        }

        return Column(children: children);
      },
    );
  }
}
