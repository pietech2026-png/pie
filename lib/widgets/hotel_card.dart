import 'package:flutter/material.dart';
import '../screens/hotel_full_view_screen.dart';

class HotelCard extends StatelessWidget {
  final Map<String, dynamic> hotel;
  final DateTimeRange selectedDates;
  final int rooms;
  final int adults;
  final int index;

  const HotelCard({
    super.key,
    required this.hotel,
    required this.selectedDates,
    required this.rooms,
    required this.adults,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final updatedDates = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HotelFullViewScreen(
              hotel: hotel,
              selectedDates: selectedDates,
              rooms: rooms,
              adults: adults,
              isSoldOut: index == 0, // Mock Hotel 1 as Sold Out
            ),
          ),
        );

        if (updatedDates != null) {
          Navigator.pop(context, updatedDates);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 1.5),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT: IMAGE GALLERY
                Container(
                  width: 140,
                  height: 190,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          hotel["image"] ?? 'lib/assets/bg_image.jpeg',
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset('lib/assets/bg_image.jpeg', fit: BoxFit.cover),
                        ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 35,
                        child: Row(
                          children: [
                            Expanded(child: _miniImage("lib/assets/bg_image.jpeg")),
                            const SizedBox(width: 4),
                            Expanded(child: _miniImage("lib/assets/bg_image.jpeg")),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                alignment: Alignment.center,
                                child: const Text("VIEW\nALL", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                
                // RIGHT: DETAILS
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Badges
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text("4⭐ • Hotel", style: TextStyle(fontSize: 10)),
                            ),
                            Row(
                              children: [
                                const Text("2933 Ratings ", style: TextStyle(fontSize: 10, color: Colors.black54)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(4)),
                                  child: const Text("4.5/5", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 6),
                        
                        // Title
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle, color: Colors.deepOrange, size: 16),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hotel["name"] as String,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (index == 0) ...[
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        "SOLD OUT",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        
                        // Location
                        Text(
                          hotel["location"].toString().split('|').first,
                          style: const TextStyle(color: Colors.blue, fontSize: 11),
                        ),
                        const SizedBox(height: 6),
                        
                        // Chips
                        Row(
                          children: [
                            _pill("Parking"),
                            const SizedBox(width: 4),
                            _pill("Gym"),
                            const SizedBox(width: 4),
                            const Text("& more", style: TextStyle(color: Colors.blue, fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        
                        // Features
                        _featureRow(Icons.favorite, "Couple Friendly", Colors.deepOrange),
                        _featureRow(Icons.check, "Breakfast available at extra charges", Colors.green),
                        _featureRow(Icons.check, "Airport Transfer", Colors.green),
                      ],
                    ),
                  ),
                )
              ],
            ),
            
            const Divider(height: 1),
            
            // BOTTOM: PRICE AND OFFERS
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Bank Offer
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.local_offer, size: 14, color: Colors.black54),
                              SizedBox(width: 4),
                              Text("Bank offer | ₹1139 off", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Pay using HSBC Bank Credit Cards EMI to avail the offer with no cost EMI",
                            style: TextStyle(fontSize: 10, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Pricing
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "₹${hotel["originalPrice"]}",
                              style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 12),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "₹${hotel["price"]}",
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Text("+₹550 taxes & fees", style: TextStyle(color: Colors.grey, fontSize: 10)),
                        const Text("per night", style: TextStyle(color: Colors.grey, fontSize: 10)),
                        const SizedBox(height: 4),
                        const Text("Login now & save more", style: TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Elite Package Bottom Banner
            Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(border: Border.all(color: Colors.orange.shade300), borderRadius: BorderRadius.circular(4)),
                    child: Text("ELITE PACKAGE", style: TextStyle(fontSize: 9, color: Colors.orange.shade700, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Enjoy exclusive benefits at a discounted price in an Elite Package deal",
                      style: TextStyle(fontSize: 10, color: Colors.black87),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _miniImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: url.startsWith('http') 
        ? Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Image.asset('lib/assets/bg_image.jpeg', fit: BoxFit.cover),
          )
        : Image.asset(
            url,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Image.asset('lib/assets/bg_image.jpeg', fit: BoxFit.cover),
          ),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Text(text, style: const TextStyle(fontSize: 10, color: Colors.black87)),
    );
  }

  Widget _featureRow(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Expanded(child: Text(text, style: TextStyle(fontSize: 10, color: color == Colors.deepOrange ? color : Colors.black87))),
        ],
      ),
    );
  }
}
