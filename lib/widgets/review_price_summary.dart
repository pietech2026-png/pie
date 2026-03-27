import 'package:flutter/material.dart';

class ReviewPriceSummary extends StatefulWidget {
  final int price;
  final int taxes;
  final int addonPrice;
  final int couponDiscount;
  final int contributionPrice;
  final List<Map<String, dynamic>> appliedAddons;
  final String Function(int) formatPrice;

  const ReviewPriceSummary({
    super.key,
    required this.price,
    required this.taxes,
    required this.addonPrice,
    required this.couponDiscount,
    required this.contributionPrice,
    required this.appliedAddons,
    required this.formatPrice,
  });

  @override
  State<ReviewPriceSummary> createState() => _ReviewPriceSummaryState();
}

class _ReviewPriceSummaryState extends State<ReviewPriceSummary> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 🔹 Header with Expand Toggle
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Price Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      _isExpanded ? 'Hide Price Break-up' : 'View Price Break-up',
                      style: const TextStyle(
                          color: Color(0xFF1565C0),
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                    ),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                      color: const Color(0xFF1565C0),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 🔹 Collapsible Content
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: SizedBox(
              width: double.infinity,
              child: _isExpanded
                  ? Column(
                      children: [
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Price + Taxes & Service Fees',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black87),
                            ),
                            Text(
                              '₹${widget.formatPrice(widget.price)} + ₹${widget.formatPrice(widget.taxes)}',
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        if (widget.couponDiscount > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Coupon Discount',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.green),
                                ),
                                Text(
                                  '- ₹${widget.formatPrice(widget.couponDiscount)}',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        if (widget.contributionPrice > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Plantation Contribution',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black87),
                                ),
                                Text(
                                  '₹${widget.formatPrice(widget.contributionPrice)}',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ...widget.appliedAddons.map((addon) => Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Addon: ${addon['name']}',
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.black87),
                                  ),
                                  Text(
                                    '₹${widget.formatPrice(addon['price'])}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // 🔹 Footer: Always Visible Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount to be paid',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '₹${widget.formatPrice(widget.price + widget.taxes + widget.addonPrice + widget.contributionPrice - widget.couponDiscount)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
