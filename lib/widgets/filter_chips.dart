import 'package:flutter/material.dart';

class FilterChips extends StatelessWidget {
  final bool freeCancellation;
  final bool addMeals;
  final VoidCallback onFreeCancellationTap;
  final VoidCallback onAddMealsTap;

  const FilterChips({
    super.key,
    required this.freeCancellation,
    required this.addMeals,
    required this.onFreeCancellationTap,
    required this.onAddMealsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          _filterChip(
            label: 'Free Cancellation',
            selected: freeCancellation,
            onTap: onFreeCancellationTap,
          ),
          const SizedBox(width: 10),
          _filterChip(
            label: 'Add Meals  ⌄',
            selected: addMeals,
            onTap: onAddMealsTap,
          ),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE3F2FD) : Colors.white,
          border: Border.all(
            color: selected
                ? const Color(0xFF1565C0)
                : Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: selected
                ? const Color(0xFF1565C0)
                : Colors.black87,
            fontWeight:
            selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}