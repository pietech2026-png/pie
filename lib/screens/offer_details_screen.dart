import 'package:flutter/material.dart';
import 'hotel_full_view_screen.dart';
import '../widgets/hotel_card.dart';

class OfferDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> offerData;
  const OfferDetailsScreen({super.key, required this.offerData});

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  String selectedDay = "Friday";

  @override
  Widget build(BuildContext context) {
    final offerData = widget.offerData;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Offer Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header and Promo Card Overlap
            Stack(
              clipBehavior: Clip.none,
              children: [
                _buildHeader(),
                Positioned(
                  bottom: -60,
                  left: 0,
                  right: 0,
                  child: _buildPromoCard(),
                ),
              ],
            ),
            
            const SizedBox(height: 80), // Compensation for the overflowing promo card
            
            // Bank Deals
            _buildBankDeals(),
            
            // Hotel Selection Title
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                "Choose from the following Sarovar Hotels & Resorts across India:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ),
            
            // Filter Dropdown
            _buildFilterDropdown(5),
            
            // Hotel List
            _buildHotelList(),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final offerData = widget.offerData;
    return Stack(
      children: [
        Image.asset(
          offerData["image"] ?? "lib/assets/bg_image.jpeg",
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 250,
            color: Colors.blue.shade100,
          ),
        ),
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.4), Colors.transparent, Colors.black.withOpacity(0.4)],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          alignment: Alignment.topCenter,
          child: Text(
            offerData["headerText"] ?? "Enjoy Comfortable & Stylish Stays\nat ${offerData["brandLabel"] ?? "Sarovar"} Hotels & Resorts!",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCard() {
    final offerData = widget.offerData;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomPaint(
        painter: DashedBorderPainter(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            children: [
              // Logo
              Column(
                children: [
                  Text(
                    offerData["brandLabel"]?.toUpperCase() ?? "SAROVAR",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1565C0),
                      fontSize: 18,
                      letterSpacing: 2.0,
                    ),
                  ),
                  Text(
                    offerData["brandSub"] ?? "HOTELS & RESORTS",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              Text(
                offerData["promoCode"] ?? "Get up to 40% OFF*",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "+ FLAT 15% OFF* on Food\n&Beverage.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      "Booking Period Till: ${offerData["validityDate"] ?? "31st Mar'26"}",
                      style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Stay Validity Till: 31st May'26",
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBankDeals() {
    final days = ["Friday", "Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday"];
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD).withOpacity(0.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Don't forget to enjoy amazing deals with these banks:",
            style: TextStyle(color: Color(0xFF0D47A1), fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: days.map((day) => _buildDayBadge(day)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayBadge(String day) {
    final isSelected = day == selectedDay;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDay = day;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.orange : Colors.grey.shade300),
        ),
        child: Text(
          day,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("All Properties - $count properties"),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelList() {
    final brand = widget.offerData["brandLabel"] ?? "Sarovar";
    final List<Map<String, dynamic>> hotels = List.generate(5, (index) {
      return {
        "name": "$brand Hotel ${index + 1}",
        "location": "Puri | 5 km drive to Jagannath Temple",
        "price": "1,563",
        "originalPrice": "6,480",
        "rating": "4.3",
        "reviews": "766",
        "image": "lib/assets/bg_image.jpeg",
        "details": "Spacious rooms, in-house cafe, free parking, couple friendly & premium stay experience.",
      };
    });

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: hotels.length,
      itemBuilder: (context, index) {
        return HotelCard(
          hotel: hotels[index],
          selectedDates: DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(days: 1)),
          ),
          rooms: 1,
          adults: 2,
          index: index,
        );
      },
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 5;
    const dashSpace = 3;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(12),
    );
    final path = Path()..addRRect(rrect);

    for (var subPath in path.computeMetrics()) {
      double distance = 0;
      while (distance < subPath.length) {
        canvas.drawPath(
          subPath.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
