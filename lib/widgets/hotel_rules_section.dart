import 'package:flutter/material.dart';
import 'property_rules_sheet.dart';

class HotelRulesSection extends StatelessWidget {
  const HotelRulesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Hotel Rules",
              style:
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text(
            "Check-In: 12 PM | Check-Out: 11 AM",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _rule("Unmarried couples allowed"),
          _rule("Primary Guest should be atleast 18 years of age."),
          _rule(
              "Aadhaar, Driving License and Passport are accepted as ID proof(s)"),
          _rule("Pets are not allowed"),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _showRulesPopup(context),
            child: const Text("View all rules and policies",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _rule(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  void _showRulesPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PropertyRulesSheet(),
    );
  }
}
