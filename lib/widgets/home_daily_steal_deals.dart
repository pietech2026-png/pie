import 'package:flutter/material.dart';
import '../screens/hotel_list_screen.dart';
import '../screens/hotel_full_view_screen.dart';

class HomeDailyStealDeals extends StatelessWidget {
  final String location;
  final DateTimeRange selectedDates;
  final int rooms;
  final int adults;

  const HomeDailyStealDeals({
    super.key,
    required this.location,
    required this.selectedDates,
    required this.rooms,
    required this.adults,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> deals = [
      {
        "name": "Hello By Ananya Puri 1",
        "location": "Lal Ghat | 8 minutes walk to City Palace",
        "price": "2,362",
        "originalPrice": "4,500",
        "taxes": "322",
        "rating": "4.3/5",
        "stars": "3",
        "image": "lib/assets/bg_image.jpeg",
        "feature": "Breakfast available at extra charges",
      },
      {
        "name": "Hello By Ananya Puri 2",
        "location": "Hiran Magri | 15 minutes walk to station",
        "price": "1,850",
        "originalPrice": "3,200",
        "taxes": "250",
        "rating": "4.1/5",
        "stars": "4",
        "image": "lib/assets/bg_image.jpeg",
        "feature": "Breakfast available at extra charges",
      },
      {
        "name": "Hello By Ananya Puri 3",
        "location": "Ambrai Ghat | Lake facing view",
        "price": "3,120",
        "originalPrice": "5,500",
        "taxes": "450",
        "rating": "4.5/5",
        "stars": "4",
        "image": "lib/assets/bg_image.jpeg",
        "feature": "Complimentary Breakfast",
      },
    ];

    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFFFF1F0), // Light Peach Background
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotelListScreen(
                      location: location,
                      selectedDates: selectedDates,
                      rooms: rooms,
                      adults: adults,
                    ),
                  ),
                );
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text(
                          "Daily Steal Deals",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.chevron_right, color: Colors.black87, size: 20),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Lowest ever prices on top-rated hotels",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // HORIZONTAL LIST
          SizedBox(
            height: 280, // Same as Today's Offers section height
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: deals.length,
              itemBuilder: (context, index) {
                final hotel = deals[index];
                return _buildDealCard(context, hotel, size.width * 0.75);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDealCard(BuildContext context, Map<String, dynamic> hotel, double width) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelFullViewScreen(
              hotel: {
                "name": hotel["name"],
                "location": hotel["location"],
                "price": hotel["price"],
                "originalPrice": hotel["originalPrice"],
                "image": hotel["image"],
                "images": [hotel["image"], hotel["image"]],
              },
              selectedDates: selectedDates,
              rooms: rooms,
              adults: adults,
            ),
          ),
        );
      },
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE SECTION WITH BADGES
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    hotel["image"],
                    height: 100, // Reduced height to fit rating and description
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Left Badge
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("${hotel["stars"]} ", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        const Icon(Icons.star, color: Colors.orange, size: 10),
                        const Text(" • Hotel", style: TextStyle(fontSize: 10, color: Colors.black87)),
                      ],
                    ),
                  ),
                ),
                // Right Badge
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      hotel["rating"],
                      style: const TextStyle(
                        color: Color(0xFF2E7D32),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // CONTENT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hotel["name"],
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                hotel["location"],
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black54,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "₹${hotel["price"]}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const Text(
                              "for 2 rooms",
                              style: TextStyle(fontSize: 8, color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // RATING & DESC SECTION
                    Row(
                      children: [
                        const Icon(Icons.star, size: 10, color: Colors.orange),
                        const SizedBox(width: 4),
                        Text(
                          "${hotel["rating"]} • Very Good",
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF2E7D32)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Elegant lake-view rooms with modern amenities and heritage-style decor.",
                      style: TextStyle(fontSize: 10, color: Colors.black87, height: 1.2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // AMENITIES
                    Row(
                      children: const [
                        Icon(Icons.wifi, size: 12, color: Colors.black54),
                        SizedBox(width: 6),
                        Icon(Icons.ac_unit, size: 12, color: Colors.black54),
                        SizedBox(width: 6),
                        Icon(Icons.local_parking, size: 12, color: Colors.black54),
                        SizedBox(width: 6),
                        Text("+2 more", style: TextStyle(fontSize: 8, color: Colors.blue)),
                      ],
                    ),
                    
                    const Spacer(),
                    const Divider(height: 1),
                    const SizedBox(height: 6),
                    
                    // FEATURE
                    Row(
                      children: [
                        const Icon(Icons.check, color: Color(0xFF2E7D32), size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            hotel["feature"],
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
