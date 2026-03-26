import 'package:flutter/material.dart';

class EditSearchSheet {
  static void show({
    required BuildContext context,
    required DateTimeRange initialDates,
    required int initialGuests,
    required int initialRooms,
    required Function(DateTimeRange, int, int) onUpdate,
    required Function(
        BuildContext, {
        required String title,
        required int value,
        required int min,
        required int max,
        required ValueChanged<int> onChanged,
        }) showStepperDialog,
    required Widget Function({
    required String label,
    required String value,
    }) editTile,
  }) {
    DateTimeRange tempDates = initialDates;
    int tempGuests = initialGuests;
    int tempRooms = initialRooms;

    final List<String> months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final List<String> days = [
      '', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
    ];

    String weekday(DateTime d) => days[d.weekday];
    String month(DateTime d) => months[d.month];

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (ctx, _, __) => Align(
        alignment: Alignment.topCenter,
        child: Material(
          color: Colors.white,
          borderRadius:
          const BorderRadius.vertical(bottom: Radius.circular(20)),
          child: StatefulBuilder(
            builder: (ctx, setSheetState) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: MediaQuery.of(ctx).padding.top + 16,
                  bottom: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Select your travel dates for best price',
                      style:
                      TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    const SizedBox(height: 16),

                    // Dates
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: ctx,
                                initialDate: tempDates.start,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                              );
                              if (picked != null) {
                                setSheetState(() {
                                  tempDates = DateTimeRange(
                                    start: picked,
                                    end: picked.isBefore(tempDates.end)
                                        ? tempDates.end
                                        : picked.add(
                                        const Duration(days: 1)),
                                  );
                                });
                              }
                            },
                            child: editTile(
                              label: 'Checkin Date',
                              value:
                              '${weekday(tempDates.start)}, ${tempDates.start.day} ${month(tempDates.start)} \'${tempDates.start.year % 100}',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: ctx,
                                initialDate: tempDates.end,
                                firstDate: tempDates.start
                                    .add(const Duration(days: 1)),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                              );
                              if (picked != null) {
                                setSheetState(() {
                                  tempDates = DateTimeRange(
                                      start: tempDates.start,
                                      end: picked);
                                });
                              }
                            },
                            child: editTile(
                              label: 'Checkout Date',
                              value:
                              '${weekday(tempDates.end)}, ${tempDates.end.day} ${month(tempDates.end)} \'${tempDates.end.year % 100}',
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Guests + Rooms
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => showStepperDialog(
                              ctx,
                              title: 'Adults',
                              value: tempGuests,
                              min: 1,
                              max: 10,
                              onChanged: (v) =>
                                  setSheetState(() => tempGuests = v),
                            ),
                            child: editTile(
                              label: 'Guests',
                              value:
                              '$tempGuests Adult${tempGuests > 1 ? 's' : ''} 0 Children',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => showStepperDialog(
                              ctx,
                              title: 'Rooms',
                              value: tempRooms,
                              min: 1,
                              max: 10,
                              onChanged: (v) =>
                                  setSheetState(() => tempRooms = v),
                            ),
                            child: editTile(
                              label: 'Rooms',
                              value:
                              '$tempRooms Room${tempRooms > 1 ? 's' : ''}',
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8520A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          onUpdate(
                              tempDates, tempGuests, tempRooms);
                          Navigator.pop(ctx);
                        },
                        child: const Text(
                          'Update Search',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}