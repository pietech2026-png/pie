import 'package:flutter/material.dart';

class ReviewAddonsSection extends StatelessWidget {
  final bool isBreakfastAdded;
  final VoidCallback onBreakfastToggle;
  final Map<String, bool> additionalAddons;
  final Function(String, bool) onAddonToggle;

  const ReviewAddonsSection({
    super.key,
    required this.isBreakfastAdded,
    required this.onBreakfastToggle,
    required this.additionalAddons,
    required this.onAddonToggle,
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
            'Addons',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // 🔹 Breakfast Addon (Original Style)
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Add Breakfast for ₹ 801 for all guests',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Includes taxes and fees',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onBreakfastToggle,
                child: Text(
                  isBreakfastAdded ? 'REMOVE' : 'ADD',
                  style: const TextStyle(
                    color: Color(0xFF1565C0),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          const Text(
            'Addon Services',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _buildCheckboxAddon(
            'luggage',
            'Assured luggage space (either carrier or boot space) for Rs. 1001',
          ),
          _buildCheckboxAddon(
            'carModel',
            'Confirm Car Model 2022 or above for Rs. 751',
          ),
          _buildCheckboxAddon(
            'pet',
            'Pet Allowance for Rs. 1001',
          ),
          _buildCheckboxAddon(
            'refundable',
            'Upgrade to Refundable booking (100% refund for cancellation before 3 hours of departure time) for Rs. 751',
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxAddon(String key, String title) {
    bool isSelected = additionalAddons[key] ?? false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: isSelected,
              onChanged: (v) => onAddonToggle(key, v!),
              activeColor: const Color(0xFF1565C0),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => onAddonToggle(key, !isSelected),
              child: Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
