import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:mood/constants.dart';
import 'package:mood/database/moods.dart';
import 'package:mood/dialogs/empty_day.dart';
import 'package:mood/dialogs/show_entry.dart';
import 'package:mood/models/moods.dart';
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
    super.initState();

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
  }

  void onEmptyDayTapped(BuildContext context, DateTime day) {
    EmptyDayDialog.show(context, day);
  }

  void onEntryDayTapped(BuildContext context, MoodDailyEntry entry) {
    ShowEntryDialog.show(context, entry);
  }

  @override
  Widget build(BuildContext context) {
    final moodsByMonth = context.watch<MoodModel>().entriesByMonth;
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

    return LayoutBuilder(
      builder: (context, constraints) {
        var height = constraints.constrainHeight();
        double squareHeight = (height / 32).toDouble();
        return CustomScrollView(
          scrollDirection: Axis.horizontal,
          slivers: [
            SliverStickyHeader(
              // overlapsContent: true,
              header: Column(
                children: [
                  Container(
                    height: squareHeight,
                    width: squareHeight,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black),
                        right: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  ...List.generate(31, (index) {
                    return Container(
                      padding: EdgeInsets.all(1.0),
                      height: squareHeight,
                      width: squareHeight,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        ),
                      ),
                      child: Text(
                        (index + 1).toString(),
                        textAlign: TextAlign.end,
                      ),
                    );
                  }),
                ],
              ),
              sliver: SliverList.separated(
                itemCount: months.length,
                itemBuilder: (context, index) {
                  final month = months[index];
                  final monthlyEntries = moodsByMonth[month];
                  Map<int, MoodDailyEntry> entriesByDays = {};

                  if (monthlyEntries != null) {
                    entriesByDays = {
                      for (var entry in monthlyEntries) entry.date.day: entry,
                    };
                  }

                  print(entriesByDays);

                  return MoodMonthColumn(
                    squareSize: squareHeight,
                    month: month,
                    entries: entriesByDays,
                    isLast: index == months.length - 1,
                    onEmptyDayTapped: (date) => onEmptyDayTapped(context, date),
                    onEntryDayTapped:
                        (entry) => onEntryDayTapped(context, entry),
                  );
                },
                separatorBuilder: (context, index) {
                  return VerticalDivider(
                    color: Colors.black,
                    thickness: 1.0,
                    width: 1.0,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class MoodMonthColumn extends StatefulWidget {
  final double squareSize;
  final YearMonth month;
  final Map<int, MoodDailyEntry> entries;
  final bool isLast;
  final ValueSetter onEmptyDayTapped;
  final ValueSetter onEntryDayTapped;

  const MoodMonthColumn({
    super.key,
    required this.squareSize,
    required this.month,
    required this.entries,
    required this.isLast,
    required this.onEmptyDayTapped,
    required this.onEntryDayTapped,
  });

  @override
  State<MoodMonthColumn> createState() => _MoodMonthColumnState();
}

class _MoodMonthColumnState extends State<MoodMonthColumn> {
  late int nbdays;
  late Border border;

  @override
  void initState() {
    super.initState();

    nbdays = daysInMonth(widget.month.year, widget.month.month);

    border = Border(
      bottom: BorderSide(color: Colors.black),
      right: widget.isLast ? BorderSide(color: Colors.black) : BorderSide.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: widget.squareSize,
          width: widget.squareSize,
          decoration: BoxDecoration(border: border),
          child: Text(
            getMonthLetter(widget.month.month),
            textAlign: TextAlign.center,
          ),
        ),
        ...List.generate(nbdays, (index) {
          final entry = widget.entries[index + 1];

          if (entry != null) {
            return GestureDetector(
              onTap: () => widget.onEntryDayTapped(entry),
              child: Container(
                width: widget.squareSize,
                height: widget.squareSize,
                decoration: BoxDecoration(
                  color: moodToColor(entry.mood),
                  border: border,
                ),
              ),
            );
          } else {
            return GestureDetector(
              onTap:
                  () => widget.onEmptyDayTapped(
                    DateTime(widget.month.year, widget.month.month, index + 1),
                  ),
              child: Container(
                width: widget.squareSize,
                height: widget.squareSize,
                decoration: BoxDecoration(color: Colors.white, border: border),
              ),
            );
          }
        }),
      ],
    );
  }
}
