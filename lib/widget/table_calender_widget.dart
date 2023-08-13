import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderDatePickerWidget extends StatefulWidget {
  const CalenderDatePickerWidget({super.key});

  @override
  State<CalenderDatePickerWidget> createState() =>
      _CalenderDatePickerWidgetState();
}

class _CalenderDatePickerWidgetState extends State<CalenderDatePickerWidget> {
  var contractDate = DateTime.parse(Get.arguments) ?? DateTime.now();
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = contractDate;
    _focusedDay = contractDate; // Initialize _focusedDay as well
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date Picker'),
      ),
      body: Center(
        child: Column(
          children: [
            TableCalendar(
              focusedDay: _focusedDay, // Use _focusedDay here
              firstDay: DateTime.utc(1940, 01, 01),
              lastDay: DateTime.now(),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay; // Update _focusedDay
                });
              },
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.back(result: _selectedDay);
                  },
                  child: const Text('OK'),
                ),
                const SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Cancel'), // Corrected typo
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}