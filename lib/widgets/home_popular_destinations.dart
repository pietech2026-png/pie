import 'package:flutter/material.dart';
import '../screens/hotel_list_screen.dart';

class HomePopularDestinations extends StatelessWidget {
  final DateTimeRange selectedDates;
  final int rooms;
  final int adults;
  final Function(DateTimeRange) onDatesChanged;

  const HomePopularDestinations({
    super.key,
    required this.selectedDates,
    required this.rooms,
    required this.adults,
    required this.onDatesChanged,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final destinations = [
      {
        "name": "Ho Chi Minh",
        "subtitle": "Economical, historical and entertainment centre of Vietnam",
        "image": "https://picsum.photos/seed/hochiminh/800/600"
      },
      {
        "name": "Paris",
        "subtitle": "The City of Light",
        "image": "https://picsum.photos/seed/paris/800/600"
      },
    ];

    return SizedBox(
      height: size.height * 0.22,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: destinations.length,
        itemBuilder: (context, index) {
          final dest = destinations[index];
          return GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HotelListScreen(
                    location: dest["name"]!,
                    selectedDates: selectedDates,
                    rooms: rooms,
                    adults: adults,
                  ),
                ),
              );
              if (result != null) {
                onDatesChanged(result);
              }
            },
            child: Container(
              width: size.width * 0.65,
              margin: EdgeInsets.only(right: size.width * 0.04),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      dest["image"]!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset('lib/assets/bg_image.jpeg', fit: BoxFit.cover),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.5, 1.0],
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dest["name"]!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dest["subtitle"]!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
