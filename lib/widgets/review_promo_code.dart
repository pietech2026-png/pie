import 'package:flutter/material.dart';

class ReviewPromoCode extends StatefulWidget {
  final Function(String) onApply;

  const ReviewPromoCode({super.key, required this.onApply});

  @override
  State<ReviewPromoCode> createState() => _ReviewPromoCodeState();
}

class _ReviewPromoCodeState extends State<ReviewPromoCode> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade300)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Have a Promo Code?',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey.shade300)),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter Promo Code',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              suffixIcon: TextButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    widget.onApply(_controller.text);
                    _controller.clear();
                  }
                },
                child: const Text(
                  'Apply',
                  style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'View all promo codes',
            style: TextStyle(
                color: Color(0xFF1565C0),
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDE7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Goibibo Gift Card can be applied at payment step',
              style: TextStyle(fontSize: 13, color: Color(0xFF827717)),
            ),
          ),
        ],
      ),
    );
  }
}
