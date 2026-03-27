import 'package:flutter/material.dart';
import '../screens/calendar_screen.dart';

class HotelDateBar extends StatelessWidget {
  final DateTimeRange selectedDates;
  final Function(DateTimeRange) onDatesChanged;

  const HotelDateBar({
    super.key,
    required this.selectedDates,
    required this.onDatesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              "${selectedDates.start.day} Mar - ${selectedDates.end.day} Mar | 2 Guests"),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CalendarScreen(initialDates: selectedDates),
                ),
              );

              if (result != null) {
                onDatesChanged(result);
              }
            },
            child: const Text("Edit",
                style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
