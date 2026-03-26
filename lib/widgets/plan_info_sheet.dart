import 'package:flutter/material.dart';

class PlanInfoSheet {
  static void show({
    required BuildContext context,
    required Map<String, dynamic> room,
  }) {
    // STATIC DATA (can move later to constants if needed)
    final List<Map<String, String>> detailItems = [
      {
        'title': 'Early Check-In upto 2 hours (subject to availability)',
        'desc':
        'Complimentary Early Check-In upto 2 hours before the standard check-in time. This service is subject to availability.',
      },
      {
        'title': 'Late Check-Out upto 2 hours (subject to availability)',
        'desc':
        'Complimentary Late Check-Out upto 2 hours after the standard check-out time. This service is subject to availability.',
      },
      {
        'title': '10% off on Food & Beverages with a-la-carte selection',
        'desc':
        '10% discount on Food & Beverages with a-la-carte selection at Pavilion. This offer is valid per night. This offer includes in-room dining.',
      },
      {
        'title': 'Complimentary Welcome Drink on arrival',
        'desc':
        'Complimentary welcome drinks on arrival, served with Soft Beverages.',
      },
      {
        'title': 'Free Linen Change',
        'desc': 'Complimentary Linen Change is available.',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF5F5F5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.88,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (ctx, ctrl) => Column(
          children: [
            // HANDLE
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room['type'] as String,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          room['planTitle'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 22),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // CONTENT
            Expanded(
              child: ListView(
                controller: ctrl,
                padding: const EdgeInsets.all(16),
                children: [
                  // CANCELLATION POLICY
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
                          child: Text(
                            'Cancellation Policy',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Divider(height: 1),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'This booking is non-refundable and the tariff cannot be cancelled with zero fee.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // PLAN DETAILS
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
                          child: Text(
                            'Plan Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(height: 1),

                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: detailItems.map((item) {
                              return Padding(
                                padding:
                                const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '• ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['title']!,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item['desc']!,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}