import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HotelCouponsSection extends StatefulWidget {
  const HotelCouponsSection({super.key});

  @override
  State<HotelCouponsSection> createState() => _HotelCouponsSectionState();
}

class _HotelCouponsSectionState extends State<HotelCouponsSection> {
  final Map<String, bool> _copiedCoupons = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text("Coupons",
              style:
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _couponCard(
                brandName: "Uber",
                brandIcon: Icons.local_taxi,
                description: "20% flat off on all rides within the city using Credit Card",
                code: "STEALDEAL20",
                validTill: "20 Dec, 2025",
                gradientColors: [const Color(0xFF9B59B6), const Color(0xFF6C3483)],
              ),
              const SizedBox(width: 12),
              _couponCard(
                brandName: "Zomato",
                brandIcon: Icons.restaurant,
                description: "Flat ₹150 off on your first order above ₹299",
                code: "HOTELDEAL15",
                validTill: "31 Mar, 2025",
                gradientColors: [const Color(0xFFE74C3C), const Color(0xFFC0392B)],
              ),
              const SizedBox(width: 12),
              _couponCard(
                brandName: "HSBC Bank",
                brandIcon: Icons.credit_card,
                description: "Get ₹1139 off on payment via HSBC Credit Card EMI",
                code: "HSBCEMI20",
                validTill: "30 Apr, 2025",
                gradientColors: [const Color(0xFF2980B9), const Color(0xFF1A5276)],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _couponCard({
    required String brandName,
    required IconData brandIcon,
    required String description,
    required String code,
    required String validTill,
    required List<Color> gradientColors,
  }) {
    bool isCopied = _copiedCoupons[code] ?? false;

    return Container(
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(brandIcon, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      brandName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Valid till",
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        Text(
                          validTill,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: code));
                        setState(() => _copiedCoupons[code] = true);
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) setState(() => _copiedCoupons[code] = false);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isCopied ? "COPIED!" : "COPY CODE",
                          style: TextStyle(
                            color: gradientColors[0],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: -20,
            top: 40,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade100.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
