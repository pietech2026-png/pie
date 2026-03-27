import 'package:flutter/material.dart';

class ReviewOffersSection extends StatelessWidget {
  final List<String> appliedCoupons;
  final Function(Map<String, dynamic>) onApply;
  final Function(String) onRemove;

  const ReviewOffersSection({
    super.key,
    required this.appliedCoupons,
    required this.onApply,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Coupons',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All Coupons', true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildOfferCard(
            code: 'FIRSTSTAY',
            discount: '-₹2,755',
            description: 'EXCLUSIVE offer on your first hotel booking!',
            isApplied: appliedCoupons.contains('FIRSTSTAY'),
            discountValue: 2755,
          ),
          const SizedBox(height: 12),
          _buildOfferCard(
            code: 'GOSMARTDEAL',
            discount: '-₹2,619',
            description:
                'Use GOSMARTDEAL to get instant discount on this hotel booking.',
            isApplied: appliedCoupons.contains('GOSMARTDEAL'),
            discountValue: 2619,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE3F2FD) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isSelected ? const Color(0xFF1565C0) : Colors.grey.shade300,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFF1565C0) : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildOfferCard({
    required String code,
    required String discount,
    required String description,
    required bool isApplied,
    required int discountValue,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isApplied ? const Color(0xFF1565C0) : Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  code,
                  style:
                      const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  discount,
                  style:
                      const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (isApplied) {
                      onRemove(code);
                    } else {
                      onApply({
                        'code': code,
                        'discount': discountValue,
                        'description': description,
                      });
                    }
                  },
                  child: Text(
                    isApplied ? 'REMOVE' : 'APPLY',
                    style: const TextStyle(
                      color: Color(0xFF1565C0),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
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
