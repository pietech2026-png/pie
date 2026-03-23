import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  final DateTimeRange initialDates;

  const CalendarScreen({super.key, required this.initialDates});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  late DateTimeRange selectedRange;

  @override
  void initState() {
    super.initState();

    // ✅ Set default from HomeScreen
    selectedRange = widget.initialDates;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Dates"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Column(
        children: [

          Expanded(
            child: CalendarDatePicker(
              initialDate: selectedRange.start,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              onDateChanged: (date) {
                setState(() {
                  if (date.isBefore(selectedRange.start)) {
                    selectedRange = DateTimeRange(
                      start: date,
                      end: selectedRange.end,
                    );
                  } else {
                    selectedRange = DateTimeRange(
                      start: selectedRange.start,
                      end: date,
                    );
                  }
                });
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Check-in: ${selectedRange.start.day}/${selectedRange.start.month}",
                    ),
                    Text(
                      "Check-out: ${selectedRange.end.day}/${selectedRange.end.month}",
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () {
                      // ✅ Send back selected dates
                      Navigator.pop(context, selectedRange);
                    },
                    child: const Text(
                      "Continue",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}