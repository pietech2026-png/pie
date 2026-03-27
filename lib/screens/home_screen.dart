import 'package:flutter/material.dart';
import '../widgets/home_search_section.dart';
import '../widgets/home_recent_searches.dart';
import '../widgets/home_bank_coupons.dart';
import '../widgets/home_popular_destinations.dart';
import '../widgets/home_section_widgets.dart';
import '../widgets/home_today_offers.dart';
import '../widgets/home_daily_steal_deals.dart';
import '../widgets/home_popular_rooms.dart';

// ---------------- HOME SCREEN ----------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedLocation = "Puri, Odisha, India";
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

              // SEARCH SECTION
              HomeSearchSection(
                initialLocation: selectedLocation,
                initialDates: selectedDates,
                initialRooms: rooms,
                initialAdults: adults,
                initialChildren: children,
                onSearch: (loc, dates, r, a, c) {
                  setState(() {
                    selectedLocation = loc;
                    selectedDates = dates;
                    rooms = r;
                    adults = a;
                    children = c;
                    if (!recentSearches.contains(loc)) {
                      recentSearches.insert(0, loc);
                    }
                  });
                },
              ),

              SizedBox(height: size.height * 0.05),

              const HomeSectionTitle(title: "Recent Searches"),
              const SizedBox(height: 12),
              HomeRecentSearches(
                recentSearches: recentSearches,
                adults: adults,
                selectedDates: selectedDates,
                onTap: (loc) => setState(() => selectedLocation = loc),
              ),

              SizedBox(height: size.height * 0.03),

              HomeDailyStealDeals(
                location: selectedLocation,
                selectedDates: selectedDates,
                rooms: rooms,
                adults: adults,
              ),

              SizedBox(height: size.height * 0.03),

              const HomeSectionTitle(title: "Coupons"),
              const SizedBox(height: 12),
              HomeBankCoupons(
                copiedMap: copiedMap,
                onCopy: (code) => setState(() => copiedMap[code] = true),
              ),

              SizedBox(height: size.height * 0.03),

              const HomeSectionTitle(title: "Today's Offers"),
              const SizedBox(height: 12),
              const HomeTodayOffers(),

              SizedBox(height: size.height * 0.03),

              const HomeSectionTitle(title: "Popular Destinations"),
              const SizedBox(height: 12),
              HomePopularDestinations(
                selectedDates: selectedDates,
                rooms: rooms,
                adults: adults,
                onDatesChanged: (dates) => setState(() => selectedDates = dates),
              ),

              SizedBox(height: size.height * 0.03),

              const HomeSectionTitle(title: "Popular Rooms"),
              const SizedBox(height: 12),
              HomePopularRooms(
                selectedDates: selectedDates,
                rooms: rooms,
                adults: adults,
                children: children,
              ),

              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}