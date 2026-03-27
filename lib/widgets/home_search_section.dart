import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../screens/calendar_screen.dart';
import '../screens/guest_screen.dart';
import '../screens/hotel_list_screen.dart';

class HomeSearchSection extends StatefulWidget {
  final String initialLocation;
  final DateTimeRange initialDates;
  final int initialRooms;
  final int initialAdults;
  final int initialChildren;
  final Function(String, DateTimeRange, int, int, int) onSearch;

  const HomeSearchSection({
    super.key,
    required this.initialLocation,
    required this.initialDates,
    required this.initialRooms,
    required this.initialAdults,
    required this.initialChildren,
    required this.onSearch,
  });

  @override
  State<HomeSearchSection> createState() => _HomeSearchSectionState();
}

class _HomeSearchSectionState extends State<HomeSearchSection> {
  late TextEditingController controller;
  late String selectedLocation;
  late DateTimeRange selectedDates;
  late int rooms;
  late int adults;
  late int children;
  List<dynamic> locations = [];

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    selectedLocation = widget.initialLocation;
    selectedDates = widget.initialDates;
    rooms = widget.initialRooms;
    adults = widget.initialAdults;
    children = widget.initialChildren;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            size.width * 0.05,
            size.width * 0.05,
            size.width * 0.05,
            size.height * 0.06,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.shade200,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "City, Area or Property Name",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: size.height * 0.01),
              TextField(
                controller: controller,
                onChanged: (value) async {
                  final results = await LocationService.searchLocation(value);
                  setState(() {
                    locations = results;
                  });
                },
                decoration: InputDecoration(
                  hintText: selectedLocation,
                  prefixIcon: const Icon(Icons.location_on),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              if (locations.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: locations.length,
                    itemBuilder: (context, index) {
                      final item = locations[index];
                      return ListTile(
                        title: Text(item['display_name']),
                        onTap: () {
                          setState(() {
                            selectedLocation = item['display_name'];
                            controller.text = selectedLocation;
                            locations = [];
                          });
                        },
                      );
                    },
                  ),
                ),
              Divider(height: size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CalendarScreen(
                            initialDates: selectedDates,
                          ),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          selectedDates = result;
                        });
                      }
                    },
                    child: Text(
                      "${selectedDates.start.day}/${selectedDates.start.month} - ${selectedDates.end.day}/${selectedDates.end.month}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GuestScreen(
                            rooms: rooms,
                            adults: adults,
                            children: children,
                          ),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          rooms = result['rooms'];
                          adults = result['adults'];
                          children = result['children'];
                        });
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("$rooms Room",
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text("$adults Adults"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -size.height * 0.03,
          left: size.width * 0.2,
          right: size.width * 0.2,
          child: SizedBox(
            height: size.height * 0.06,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                final finalLocation = controller.text.isEmpty ? selectedLocation : controller.text;
                widget.onSearch(finalLocation, selectedDates, rooms, adults, children);
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HotelListScreen(
                      location: finalLocation,
                      selectedDates: selectedDates,
                      rooms: rooms,
                      adults: adults,
                    ),
                  ),
                );
              },
              child: const Text(
                "Search",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
