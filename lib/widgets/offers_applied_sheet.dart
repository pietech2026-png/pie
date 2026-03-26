import 'package:flutter/material.dart';

class OffersAppliedSheet extends StatelessWidget {
  final int totalSavings;
  final int priceAfterDiscount;
  final int roomCount;
  final int nights;

  const OffersAppliedSheet({
    super.key,
    required this.totalSavings,
    required this.priceAfterDiscount,
    required this.roomCount,
    required this.nights,
  });

  static void show(
    BuildContext context, {
    required int totalSavings,
    required int priceAfterDiscount,
    required int roomCount,
    required int nights,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OffersAppliedSheet(
        totalSavings: totalSavings,
        priceAfterDiscount: priceAfterDiscount,
        roomCount: roomCount,
        nights: nights,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔹 Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Offers Applied',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Promo Category
                Row(
                  children: const [
                    Icon(Icons.stars, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'PROMOCODE',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 🔹 Horizontal Offers List
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildOfferCard(
                        context,
                        code: 'GOHSBC',
                        discount: '₹2,546',
                        description:
                            'Pay using HSBC Bank Credit Cards to avail the offer',
                        isSelected: true,
                      ),
                      const SizedBox(width: 12),
                      _buildOfferCard(
                        context,
                        code: 'ICICI15',
                        discount: '₹2,016',
                        description:
                            'Pay using ICICI Bank Credit Cards to avail the offer',
                        isSelected: false,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(height: 1),
                const SizedBox(height: 16),

                // 🔹 Savings Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total savings',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                    Text(
                      '- ₹$totalSavings',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Price after discount',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Per night for $roomCount Rooms',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹$priceAfterDiscount',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '+₹518 taxes & fees',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(
    BuildContext context, {
    required String code,
    required String discount,
    required String description,
    required bool isSelected,
  }) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.green : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: isSelected ? Colors.blue : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance, size: 14, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          code,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                '- $discount',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
          ),
          const SizedBox(height: 12),
          const Text(
            'View More',
            style: TextStyle(
                color: Color(0xFF1565C0),
                fontWeight: FontWeight.bold,
                fontSize: 13),
          ),
        ],
      ),
    );
  }
}
