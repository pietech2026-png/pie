import 'package:flutter/material.dart';

class HotelListScreen extends StatelessWidget {
  final String location;

  const HotelListScreen({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final hotels = List.generate(5, (index) {
      return {
        "image": "lib/assets/bg_image.jpeg",
      };
    });

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Puri"),
            Text(
              "24 Mar - 25 Mar, 2 Guests",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.search),
          )
        ],
      ),

      body: Column(
        children: [

          // 🔹 FILTER CHIPS
          SizedBox(
            height: size.height * 0.06,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
              children: [
                _filterChip("✨ Smart Filters"),
                _filterChip("Couple Friendly"),
                _filterChip("goTribe Deals"),
              ],
            ),
          ),

          // 🔹 TITLE
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04, vertical: 8),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Showing Properties in Puri",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // 🔹 LIST
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(size.width * 0.04),
              itemCount: hotels.length,
              itemBuilder: (context, index) {

                return Container(
                  margin: EdgeInsets.only(bottom: size.height * 0.02),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6,
                        color: Colors.grey.shade300,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // 🔹 IMAGE + DOTS
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(14),
                            ),
                            child: Image.asset(
                              hotels[index]["image"]!,
                              height: size.height * 0.22,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                          Positioned(
                            bottom: 8,
                            child: Row(
                              children: List.generate(
                                4,
                                    (i) => Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  width: i == 0 ? 14 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: i == 0 ? Colors.orange : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // 🔹 CONTENT
                      Padding(
                        padding: EdgeInsets.all(size.width * 0.03),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // RATING + BRAND
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        "4.3/5",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text("(766 Ratings)"),
                                  ],
                                ),
                                const Text(
                                  "goSTAYS",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // NAME
                            const Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.orange, size: 18),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    "Hello By Ananya Puri",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            const Text(
                              "Puri | 5 km drive to Shree Jagannath Temple",
                              style: TextStyle(color: Colors.grey),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              "Room in an Apartment",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),

                            const Text("Sleeps 4 guests"),

                            const SizedBox(height: 10),

                            // LEFT + RIGHT
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Row(
                                        children: [
                                          Icon(Icons.favorite, size: 16, color: Colors.red),
                                          SizedBox(width: 4),
                                          Text("Couple Friendly"),
                                        ],
                                      ),

                                      SizedBox(height: 6),

                                      Row(
                                        children: [
                                          Icon(Icons.check, size: 16, color: Colors.green),
                                          SizedBox(width: 4),
                                          Text("Breakfast Included"),
                                        ],
                                      ),

                                      SizedBox(height: 6),

                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.check, size: 16, color: Colors.green),
                                          SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              "25% off on Food & Beverages from a Fixed menu",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 10),

                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [

                                    Text(
                                      "₹6,480",
                                      style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                      ),
                                    ),

                                    SizedBox(height: 2),

                                    Text(
                                      "₹1,563",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),

                                    SizedBox(height: 2),

                                    Text(
                                      "+₹262 taxes & fees",
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),

                                    Text(
                                      "per night",
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.lightbulb, size: 16, color: Colors.orange),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    "Complimentary Pujari, in-house cafe, Spacious Rooms & Parking",
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // RUSH DEAL
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  const Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "RUSH DEAL ",
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Hurry! 10 % extra savings included for today",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Column(
                                    children: const [
                                      Text("1/2"),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          CircleAvatar(radius: 3, backgroundColor: Colors.orange),
                                          SizedBox(width: 3),
                                          CircleAvatar(radius: 3, backgroundColor: Colors.grey),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // 🔥 FLOATING BOTTOM BAR (LIKE IMAGE)
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: size.height * 0.075,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.swap_vert, color: Colors.white, size: 18),
                      SizedBox(width: 6),
                      Text("Sort", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),

                Container(width: 1, height: 30, color: Colors.white24),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.tune, color: Colors.white, size: 18),
                      SizedBox(width: 6),
                      Text("Filters", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),

                Container(width: 1, height: 30, color: Colors.white24),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.access_time, color: Colors.white, size: 18),
                      SizedBox(width: 6),
                      Text("Rush Deals", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _filterChip(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Chip(
        label: Text(text),
        backgroundColor: Colors.grey.shade200,
      ),
    );
  }
}