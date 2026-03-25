import 'package:flutter/material.dart';
import 'package:pie/services/location_service.dart';
import 'package:pie/screens/hotel_list_screen.dart';
import 'guest_screen.dart'; // For Person Selection
import 'calendar_screen.dart'; // For Dates Selection

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

  List<String> recentSearches = [];

  int rooms = 1;
  int adults = 2;
  int children = 0;

  DateTimeRange selectedDates = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 1)),
  );

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
            Text("Pie Hotel"),
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
              ),

              SizedBox(height: size.height * 0.03),

              _sectionTitle("Daily Steal Deals", size),
              _horizontalList(size, 0.18, "deals"),

              SizedBox(height: size.height * 0.03),

              _sectionTitle("Coupons", size),
              _bankCouponsSection(size),

              SizedBox(height: size.height * 0.03),

              _sectionTitle("Today's Offers", size),
              _horizontalList(size, 0.18, "offers"),

              SizedBox(height: size.height * 0.03),

              _sectionTitle("Popular Destinations", size),
              _popularDestinationsList(context, size),

              SizedBox(height: size.height * 0.03),

              _sectionTitle("Popular Rooms", size),
              _horizontalList(size, 0.22, "rooms"),

              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
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
                  onPressed: () async {

                    final searchLocation =
                    controller.text.isEmpty ? selectedLocation : controller.text;

                    if (!recentSearches.contains(searchLocation)) {
                      recentSearches.insert(0, searchLocation);
                    }

                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HotelListScreen(
                          location: searchLocation,
                          selectedDates: selectedDates,
                          rooms: rooms,
                          adults: adults,
                        ),
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        selectedDates = result;
                      });
                    }

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

  // ---------------- COUPONS ----------------

  Widget _bankCouponsSection(Size size) {
    final coupons = [
      {'title': 'UPTO 25% OFF', 'code': 'ICICIEMI'},
      {'title': 'FLAT 12% OFF', 'code': 'GOAXISEMI'},
      {'title': 'FLAT 10% OFF', 'code': 'SBIDEAL10'},
    ];

    return SizedBox(
      height: size.height * 0.2,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          final c = coupons[index];
          final isCopied = copiedMap[c['code']] ?? false;

          return Container(
            width: size.width * 0.5,
            margin: EdgeInsets.only(right: size.width * 0.04),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Text(c['title']!,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(c['code']!),
                    GestureDetector(
                      onTap: () {
                        setState(() => copiedMap[c['code']!] = true);
                      },
                      child: Text(isCopied ? "Copied" : "Copy"),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------- COMMON ----------------

  Widget _sectionTitle(String title, Size size) {
    return Text(title,
        style: TextStyle(
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold));
  }

  Widget _horizontalList(Size size, double heightFactor, String seed) {
    return SizedBox(
      height: size.height * heightFactor,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (_, index) => Container(
          width: size.width * 0.6,
          margin: EdgeInsets.only(right: size.width * 0.04),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              "https://picsum.photos/seed/${seed}_$index/800/600",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset('lib/assets/bg_image.jpeg', fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }

  Widget _popularDestinationsList(BuildContext context, Size size) {
    final destinations = [
      {
        "name": "Ho Chi Minh",
        "subtitle": "Economical, historical and entertainment centre of Vietnam",
        "image": "https://picsum.photos/seed/hochiminh/800/600"
      },
      {
        "name": "Paris",
        "subtitle": "The City of Light",
        "image": "https://picsum.photos/seed/paris/800/600"
      },
    ];

    return SizedBox(
      height: size.height * 0.22,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: destinations.length,
        itemBuilder: (context, index) {
          final dest = destinations[index];
          return GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HotelListScreen(
                    location: dest["name"]!,
                    selectedDates: selectedDates,
                    rooms: rooms,
                    adults: adults,
                  ),
                ),
              );
              if (result != null) {
                setState(() {
                  selectedDates = result;
                });
              }
            },
            child: Container(
              width: size.width * 0.65,
              margin: EdgeInsets.only(right: size.width * 0.04),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      dest["image"]!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset('lib/assets/bg_image.jpeg', fit: BoxFit.cover),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.5, 1.0],
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dest["name"]!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dest["subtitle"]!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}