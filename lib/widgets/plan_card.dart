import 'package:flutter/material.dart';
import 'plan_details_sheet.dart';
import 'plan_info_sheet.dart';

class PlanCard extends StatelessWidget {
  final BuildContext context;
  final int index;
  final Map<String, dynamic> room;
  final int? selectedRoomIndex;
  final Function(int) onSelect;
  final String Function(int) formatPrice;

  const PlanCard({
    super.key,
    required this.context,
    required this.index,
    required this.room,
    required this.selectedRoomIndex,
    required this.onSelect,
    required this.formatPrice,
  });

  @override
  Widget build(BuildContext _) {
    final List<String> benefits =
    (room['benefits'] as List).cast<String>();
    final int price = room['pricePerNight'] as int;
    final int taxes = room['taxes'] as int;
    final String cancellationTill =
    room['freeCancellationTill'] as String;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            room['planTitle'] as String,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          ...benefits.map(
                (b) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle,
                      size: 7, color: Colors.black45),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(b,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black87)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          GestureDetector(
            onTap: () => PlanDetailsSheet.show(context, room),
            child: const Text(
              'Plan Details',
              style: TextStyle(
                color: Color(0xFF1565C0),
                fontWeight: FontWeight.w600,
                fontSize: 13,
                decoration: TextDecoration.underline,
              ),
            ),
          ),

          const Divider(height: 20),

          Row(
            children: [
              const Icon(Icons.check_circle_outline,
                  color: Color(0xFF2E7D32), size: 16),
              const SizedBox(width: 6),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                      fontSize: 13, color: Colors.black87),
                  children: [
                    const TextSpan(
                      text: 'Free Cancellation ',
                      style: TextStyle(
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: 'till $cancellationTill'),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => PlanInfoSheet.show(
                  context: context,
                  room: room,
                ),
                child: const Icon(Icons.info_outline,
                    size: 14, color: Colors.black45),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: '₹${formatPrice(price)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: ' +₹',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54),
                          ),
                          TextSpan(
                            text: formatPrice(taxes),
                            style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54),
                          ),
                          const TextSpan(
                            text: ' taxes & fees',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'per night',
                      style: TextStyle(
                          fontSize: 12, color: Colors.black45),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => onSelect(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 11),
                  decoration: BoxDecoration(
                    color: selectedRoomIndex == index
                        ? const Color(0xFF1565C0)
                        : Colors.white,
                    border: Border.all(
                        color: const Color(0xFF1565C0), width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (selectedRoomIndex == index) ...[
                        const Icon(Icons.check,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        selectedRoomIndex == index
                            ? 'Selected'
                            : 'Select',
                        style: TextStyle(
                          color: selectedRoomIndex == index
                              ? Colors.white
                              : const Color(0xFF1565C0),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}