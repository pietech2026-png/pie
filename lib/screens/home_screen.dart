import 'package:flutter/material.dart';
import 'package:pie/services/location_service.dart';
import 'package:pie/screens/hotel_list_screen.dart';
import 'banner_view.dart';
import 'guest_screen.dart';
import 'calendar_screen.dart';

// ---------------- HOME SCREEN ----------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<dynamic> locations = [];
  String selectedLocation = "Puri, Odisha, India";

  final TextEditingController controller = TextEditingController();

  // ✅ Recent searches list
  List<String> recentSearches = [];

  // ✅ Guest + Date state
  int rooms = 1;
  int adults = 2;
  int children = 0;

  DateTimeRange selectedDates = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 1)),
  );

  // ✅ Bank coupon copy state
  Map<String, bool> copiedMap = {};

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

              // ✅ RECENT SEARCHES
              _sectionTitle("Recent Searches", size),

              recentSearches.isEmpty
                  ? const Text("No recent searches")
                  : SizedBox(
                height: size.height * 0.20,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentSearches.length,
                  itemBuilder: (context, index) {
                    final location = recentSearches[index];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          controller.text = location;
                          selectedLocation = location;
                        });
                      },
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

                            Text(
                              "$adults Adults",
                              style: const TextStyle(color: Colors.grey),
                            ),

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
              ),

              SizedBox(height: size.height * 0.03),

              _sectionTitle("Daily Steal Deals", size),
              _horizontalList(size, 0.18),

              SizedBox(height: size.height * 0.03),

              // ✅ BANK COUPONS SECTION (Same as screenshot)
              _sectionTitle("Coupons", size),
              _bankCouponsSection(size),

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

  // ---------------- BANK COUPONS SECTION ----------------

  Widget _bankCouponsSection(Size size) {
    final List<Map<String, dynamic>> coupons = [
      {
        'logo': Icons.credit_card,
        'logoColor': const Color(0xFFCC2027), // ICICI red
        'title': 'UPTO 25% OFF',
        'subtitle': 'On ICICI Credit Cards EMI',
        'code': 'ICICIEMI',
        'bgColor': Colors.white,
      },
      {
        'logo': Icons.credit_card,
        'logoColor': const Color(0xFF97144D), // Axis maroon
        'title': 'FLAT 12% OFF',
        'subtitle': 'on Axis Bank Credit Cards EMI',
        'code': 'GOAXISEMI',
        'bgColor': Colors.white,
      },
      {
        'logo': Icons.account_balance,
        'logoColor': const Color(0xFF0057A8), // SBI blue
        'title': 'FLAT 10% OFF',
        'subtitle': 'On SBI Credit Cards',
        'code': 'SBIDEAL10',
        'bgColor': Colors.white,
      },
    ];

    return SizedBox(
      height: size.height * 0.22,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          final coupon = coupons[index];
          final code = coupon['code'] as String;
          final isCopied = copiedMap[code] ?? false;

          return Container(
            width: size.width * 0.52,
            margin: EdgeInsets.only(right: size.width * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // ---- TOP: Logo ----
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (coupon['logoColor'] as Color).withOpacity(0.1),
                    ),
                    child: Icon(
                      coupon['logo'] as IconData,
                      color: coupon['logoColor'] as Color,
                      size: 26,
                    ),
                  ),
                ),

                // ---- Title ----
                Text(
                  coupon['title'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.038,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 4),

                // ---- Subtitle ----
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    coupon['subtitle'] as String,
                    style: TextStyle(
                      fontSize: size.width * 0.03,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),

                const Spacer(),

                // ---- Divider ----
                Divider(color: Colors.grey.shade200, height: 1),

                // ---- Coupon Code + Copy Button ----
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Dashed border code box
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          code,
                          style: TextStyle(
                            fontSize: size.width * 0.028,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      // Copy Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            copiedMap[code] = true;
                          });
                          // Reset after 2 seconds
                          Future.delayed(const Duration(seconds: 2), () {
                            if (mounted) {
                              setState(() {
                                copiedMap[code] = false;
                              });
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isCopied ? Colors.green : Colors.blue.shade600,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isCopied ? "Copied!" : "Copy",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
    );
  }

  // ---------------- SEARCH SECTION ----------------

  Widget _searchSection(BuildContext context, Size size) {
    return Column(
      children: [

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

                  TextField(
                    controller: controller,
                    onChanged: (value) async {
                      final results =
                      await LocationService.searchLocation(value);
                      setState(() {
                        locations = results;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: selectedLocation,
                      prefixIcon: const Icon(Icons.location_on),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  if (locations.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: locations.length,
                        itemBuilder: (context, index) {
                          final item = locations[index];
                          return ListTile(
                            title: Text(item['display_name']),
                            onTap: () {
                              setState(() {
                                selectedLocation = item['display_name'];
                                controller.text = selectedLocation;
                                locations = [];
                              });
                            },
                          );
                        },
                      ),
                    ),

                  Divider(height: size.height * 0.03),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CalendarScreen(
                                initialDates: selectedDates,
                              ),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              selectedDates = result;
                            });
                          }
                        },
                        child: Text(
                          "${selectedDates.start.day}/${selectedDates.start.month} - ${selectedDates.end.day}/${selectedDates.end.month}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GuestScreen(
                                rooms: rooms,
                                adults: adults,
                                children: children,
                              ),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              rooms = result['rooms'];
                              adults = result['adults'];
                              children = result['children'];
                            });
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("$rooms Room",
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text("$adults Adults"),
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
                  onPressed: () {

                    final searchLocation =
                    controller.text.isEmpty ? selectedLocation : controller.text;

                    // ✅ Add to recent searches
                    if (!recentSearches.contains(searchLocation)) {
                      recentSearches.insert(0, searchLocation);
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HotelListScreen(
                          location: searchLocation,
                        ),
                      ),
                    );

                    setState(() {});
                  },
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

  // ---------------- COMMON ----------------

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