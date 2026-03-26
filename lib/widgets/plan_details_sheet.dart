import 'package:flutter/material.dart';

class PlanDetailsSheet {
  static void show(BuildContext context, Map<String, dynamic> room) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    room['planTitle'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const Divider(),

            // BENEFITS LIST
            ...(room['benefits'] as List<dynamic>)
                .cast<String>()
                .map(
                  (b) => ListTile(
                dense: true,
                leading: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF2E7D32),
                  size: 20,
                ),
                title: Text(
                  b,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}