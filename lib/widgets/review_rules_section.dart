import 'package:flutter/material.dart';
import 'property_rules_sheet.dart';

class ReviewRulesSection extends StatelessWidget {
  const ReviewRulesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Property Rules and Policies',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildRuleRow(
              'Primary Guest should be atleast 18 years of age.'),
          _buildRuleRow(
              'Aadhaar, Driving License, Govt. ID and Passport are accepted as ID proof(s)'),
          _buildRuleRow('Pets are not allowed'),
          _buildRuleRow('Outside food is not allowed'),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => PropertyRulesSheet.show(context),
            child: const Text(
              'View all rules and policies',
              style: TextStyle(
                  color: Color(0xFF1565C0),
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info, size: 18, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
