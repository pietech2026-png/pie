import 'package:flutter/material.dart';

class HomeRecentSearches extends StatelessWidget {
  final List<String> recentSearches;
  final int adults;
  final DateTimeRange selectedDates;
  final Function(String) onTap;

  const HomeRecentSearches({
    super.key,
    required this.recentSearches,
    required this.adults,
    required this.selectedDates,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (recentSearches.isEmpty) {
      return const Text("No recent searches");
    }

    return SizedBox(
      height: size.height * 0.20,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recentSearches.length,
        itemBuilder: (context, index) {
          final location = recentSearches[index];

          return GestureDetector(
            onTap: () => onTap(location),
            child: Container(
              width: size.width * 0.55,
              margin: EdgeInsets.only(right: size.width * 0.04),
              padding: EdgeInsets.all(size.width * 0.04),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "City",
                          style: TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14),
                    ],
                  ),
                  SizedBox(height: size.height * 0.015),
                  Text(
                    location.split(',').first,
                    style: TextStyle(
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text("$adults Adults",
                      style: const TextStyle(color: Colors.grey)),
                  Text(
                    "${selectedDates.start.day}/${selectedDates.start.month} - ${selectedDates.end.day}/${selectedDates.end.month}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
