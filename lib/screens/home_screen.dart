import 'package:flutter/material.dart';

// ---------------- HOME SCREEN ----------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.hotel),
            SizedBox(width: 8),
            Text("Pi Hotel"),
          ],
        ),
        centerTitle: true,
      ),

      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(child: Text("Menu")),
            ListTile(title: Text("Profile")),
            ListTile(title: Text("Bookings")),
            ListTile(title: Text("Logout")),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: size.height * 0.02),

              _searchSection(context, size),

              SizedBox(height: size.height * 0.05),

              _sectionTitle("Recent Searches", size),
              _horizontalList(size, 0.14),

              SizedBox(height: size.height * 0.03),

              _sectionTitle("Daily Steal Deals", size),
              _horizontalList(size, 0.18),

              SizedBox(height: size.height * 0.03),

              _sectionTitle("Coupons", size),
              Container(
                width: double.infinity,
                height: size.height * 0.12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.orange.shade200,
                ),
                child: const Center(
                  child: Text(
                    "Get 20% OFF on your first booking!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.03),

              _sectionTitle("Today's Offers", size),
              _horizontalList(size, 0.18),

              SizedBox(height: size.height * 0.03),

              _sectionTitle("Popular Destinations", size),
              _horizontalList(size, 0.18),

              SizedBox(height: size.height * 0.03),

              _sectionTitle("Popular Rooms", size),
              _horizontalList(size, 0.22),

              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchSection(BuildContext context, Size size) {
    DateTimeRange? selectedDates;

    return Column(
      children: [

        Container(
          width: double.infinity,
          padding: EdgeInsets.all(size.width * 0.04),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade200,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "HOURLY\nSTAYS",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: size.width * 0.04),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "BOOK FOR 3, 6 OR 9 HOURS!",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text("Flexible slots, great savings"),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),

        SizedBox(height: size.height * 0.02),

        Stack(
          clipBehavior: Clip.none,
          children: [

            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                size.width * 0.05,
                size.width * 0.05,
                size.width * 0.05,
                size.height * 0.06,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade200,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "City, Area or Property Name",
                    style: TextStyle(color: Colors.grey),
                  ),

                  SizedBox(height: size.height * 0.01),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          "Puri, Odisha, India",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.my_location),
                        label: const Text("Near Me"),
                      ),
                    ],
                  ),

                  Divider(height: size.height * 0.03),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      // 👇 DATE PICKER ADDED
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            selectedDates = picked;
                          }
                        },
                        child: Text(
                          selectedDates == null
                              ? "Select Dates"
                              : "${selectedDates!.start.day}/${selectedDates!.start.month} - ${selectedDates!.end.day}/${selectedDates!.end.month}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GuestScreen(),
                            ),
                          );
                        },
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "1 Room",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("2 Adults"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: -size.height * 0.03,
              left: size.width * 0.2,
              right: size.width * 0.2,
              child: SizedBox(
                height: size.height * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Search",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, Size size) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.015),
      child: Text(
        title,
        style: TextStyle(
          fontSize: size.width * 0.05,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _horizontalList(Size size, double heightFactor) {
    return SizedBox(
      height: size.height * heightFactor,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: size.width * 0.6,
            margin: EdgeInsets.only(right: size.width * 0.04),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage('lib/assets/bg_image.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------- GUEST SCREEN ----------------

class GuestScreen extends StatefulWidget {
  const GuestScreen({super.key});

  @override
  State<GuestScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  int rooms = 1;
  int adults = 2;
  int children = 0;

  Widget counter(String title, int value, Function(bool) onChange) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Row(
          children: [
            IconButton(
              onPressed: () => onChange(false),
              icon: const Icon(Icons.remove),
            ),
            Text(value.toString()),
            IconButton(
              onPressed: () => onChange(true),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Select Guests")),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.05),
        child: Column(
          children: [

            counter("Rooms", rooms, (isAdd) {
              setState(() {
                if (isAdd) {
                  rooms++;
                } else if (rooms > 1) {
                  rooms--;
                }
              });
            }),

            counter("Adults", adults, (isAdd) {
              setState(() {
                if (isAdd) {
                  adults++;
                } else if (adults > 1) {
                  adults--;
                }
              });
            }),

            counter("Children", children, (isAdd) {
              setState(() {
                if (isAdd) {
                  children++;
                } else if (children > 0) {
                  children--;
                }
              });
            }),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: size.height * 0.07,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Done",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}