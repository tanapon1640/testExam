import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectofsgn/view/widgets/custom_app_bar.dart';

class ScheduleAppointmentPage extends StatefulWidget {
  const ScheduleAppointmentPage({super.key});

  @override
  State<ScheduleAppointmentPage> createState() =>
      _ScheduleAppointmentPageState();
}

class _ScheduleAppointmentPageState extends State<ScheduleAppointmentPage> {
  DateTime _currentMonth = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  late PageController _pageController;

  List<List<DateTime?>> _getWeeks(DateTime month) {
    DateTime first = DateTime(month.year, month.month, 1);
    DateTime last = DateTime(month.year, month.month + 1, 0);
    List<List<DateTime?>> weeks = [];
    List<DateTime?> week = List.filled(7, null);
    int dayOffset = first.weekday - 1;
    for (int i = 0; i < dayOffset; i++) {
      week[i] = null;
    }

    for (int day = 1; day <= last.day; day++) {
      DateTime date = DateTime(month.year, month.month, day);
      int weekday = date.weekday - 1;
      week[weekday] = date;

      if (weekday == 6 || day == last.day) {
        weeks.add(List.from(week));
        week = List.filled(7, null);
      }
    }

    return weeks;
  }

  void goToPrevious() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
      _pageController = PageController(initialPage: 0);
    });
  }

  void goToNext() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
      _pageController = PageController(initialPage: 0);
    });
  }

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    List<List<DateTime?>> weeks = _getWeeks(_currentMonth);
    int initialPage = 0;

    for (int i = 0; i < weeks.length; i++) {
      for (var day in weeks[i]) {
        if (day != null &&
            day.year == today.year &&
            day.month == today.month &&
            day.day == today.day) {
          initialPage = i ~/ 2;
          break;
        }
      }
    }

    _pageController = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String? selectedTime;
  final List<String> times = ["09:00 AM", "10:30 AM", "01:00 PM", "02:30 PM"];
  @override
  Widget build(BuildContext context) {
    List<List<DateTime?>> weeks = _getWeeks(_currentMonth);

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Schedule Appointment',
          notShowAvatar: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Biometric Collection",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "For application #LTR-22345",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 200,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Container(
                          color: Colors.blue.shade100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: goToPrevious,
                                icon: Icon(Icons.chevron_left),
                              ),
                              Text(
                                DateFormat('MMMM yyyy').format(_currentMonth),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: goToNext,
                                icon: Icon(Icons.chevron_right),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children:
                            ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                                .map(
                                  (e) => Expanded(
                                    child: Center(
                                      child: Text(
                                        e,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: (weeks.length / 2).ceil(),
                          itemBuilder: (context, pageIndex) {
                            final startWeekIndex = pageIndex * 2;
                            final endWeekIndex = min(
                              startWeekIndex + 1,
                              weeks.length - 1,
                            );

                            return Column(
                              children: [
                                for (
                                  int weekIndex = startWeekIndex;
                                  weekIndex <= endWeekIndex;
                                  weekIndex++
                                )
                                  if (weekIndex < weeks.length)
                                    Row(
                                      children: List.generate(7, (dayIndex) {
                                        final day = weeks[weekIndex][dayIndex];

                                        bool isToday =
                                            day != null &&
                                            day.year == DateTime.now().year &&
                                            day.month == DateTime.now().month &&
                                            day.day == DateTime.now().day;

                                        bool isSelected =
                                            day != null &&
                                            day.year == _selectedDate.year &&
                                            day.month == _selectedDate.month &&
                                            day.day == _selectedDate.day;

                                        return Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              if (day != null) {
                                                setState(() {
                                                  _selectedDate = day;
                                                });
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              margin: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color:
                                                      isSelected
                                                          ? Colors.blue.shade800
                                                          : isToday
                                                          ? Colors.blue.shade800
                                                          : Colors
                                                              .grey
                                                              .shade100,
                                                  width: 2,
                                                ),
                                                shape: BoxShape.circle,
                                                color:
                                                    isSelected
                                                        ? Colors.blue.shade800
                                                        : isToday
                                                        ? Colors.blue.shade800
                                                        : Colors.white,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  day != null
                                                      ? '${day.day}'
                                                      : '',
                                                  style: TextStyle(
                                                    color:
                                                        (isToday || isSelected)
                                                            ? Colors.white
                                                            : Colors
                                                                .grey
                                                                .shade700,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Available Times - ${DateFormat('MMMM d').format(_selectedDate)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.center,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 10,
                    runSpacing: 10,
                    children:
                        times.map((time) {
                          final bool isSelected = selectedTime == time;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTime = time;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 150,
                              height: 45,
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Colors.blue.shade800
                                        : Colors.white,
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? Colors.blue.shade800
                                          : Colors.grey.shade200,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                time,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.grey.shade800,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),

                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 10, top: 25),
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    'Confirm Appointment',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
