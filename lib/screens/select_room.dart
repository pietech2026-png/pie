// ======================= SELECT ROOM SCREEN =======================
import 'package:flutter/material.dart';
import 'package:pie/widgets/room_details_sheet.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/edit_search_sheet.dart';
import '../widgets/filter_chips.dart';
import '../widgets/plan_card.dart';
import '../widgets/room_card.dart';
import '../widgets/rooms_type_sheet.dart';

class SelectRoomScreen extends StatefulWidget {
  final String hotelName;
  final DateTimeRange selectedDates;
  final int guests;
  final int rooms;

  const SelectRoomScreen({
    super.key,
    required this.hotelName,
    required this.selectedDates,
    this.guests = 2,
    this.rooms = 1,
  });

  @override
  State<SelectRoomScreen> createState() => _SelectRoomScreenState();
}

class _SelectRoomScreenState extends State<SelectRoomScreen> {
  bool _freeCancellation = false;
  bool _addMeals = false;
  // Tracks which cards are expanded — all start expanded
  final Set<int> _expandedRooms = {0, 1, 2};
  // Scroll controller + keys for programmatic scroll-to
  final ScrollController _scrollController = ScrollController();
  // One GlobalKey per room card — initialized inline (safe across hot reload)
  final List<GlobalKey> _roomKeys = [GlobalKey(), GlobalKey(), GlobalKey()];

  // Mutable search state (starts from what home screen passed)
  late DateTimeRange _searchDates;
  late int _guestCount;
  late int _roomCount;

  @override
  void initState() {
    super.initState();
    _searchDates = widget.selectedDates;
    _guestCount = widget.guests;
    _roomCount = widget.rooms;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ── Sample room data ──────────────────────────────────────────
  final List<Map<String, dynamic>> _rooms = [
    {
      'type': 'Deluxe Room with Airport Drop',
      'maxGuests': 3,
      'sqft': '256 sq.ft (24 sq.mt)',
      'bedType': 'Double Bed',
      'bathrooms': '1 Bathroom',
      'imageCount': 14,
      'image': 'lib/assets/bg_image.jpeg',
      'planTitle': 'Room With Free Cancellation | Breakfast only',
      'benefits': [
        'Complimentary One-way Airport Transfer',
        'Complimentary Hi-Tea',
        'Guaranteed Early Check-In upto 2 hours',
        'Guaranteed Late Check-Out upto 2 hours',
      ],
      'freeCancellationTill': '25 Mar',
      'pricePerNight': 4353,
      'taxes': 759,
      'elitePackage': true,
      'eliteSavings': 793,
      'elitePrice': 317,
    },
    {
      'type': 'Superior Room',
      'maxGuests': 2,
      'sqft': '180 sq.ft (17 sq.mt)',
      'bedType': 'Twin Bed',
      'bathrooms': '1 Bathroom',
      'imageCount': 10,
      'image': 'lib/assets/bg_image.jpeg',
      'planTitle': 'Room Only | No Meals',
      'benefits': [
        'Complimentary Wi-Fi',
        'Daily Housekeeping',
        'Room Service (24/7)',
      ],
      'freeCancellationTill': '26 Mar',
      'pricePerNight': 3200,
      'taxes': 576,
      'elitePackage': false,
      'eliteSavings': 0,
      'elitePrice': 0,
    },
    {
      'type': 'Premium Suite with City View',
      'maxGuests': 4,
      'sqft': '420 sq.ft (39 sq.mt)',
      'bedType': 'King Bed',
      'bathrooms': '2 Bathrooms',
      'imageCount': 18,
      'image': 'lib/assets/bg_image.jpeg',
      'planTitle': 'Suite | Breakfast + Dinner',
      'benefits': [
        'Complimentary Airport Pickup & Drop',
        'Daily Breakfast & Dinner Included',
        'Access to Executive Lounge',
        'Guaranteed Early Check-In & Late Check-Out',
      ],
      'freeCancellationTill': '24 Mar',
      'pricePerNight': 7800,
      'taxes': 1200,
      'elitePackage': true,
      'eliteSavings': 1500,
      'elitePrice': 650,
    },
  ];

  int? _selectedRoomIndex;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final String dateLabel =
        '${_searchDates.start.day} Mar – '
        '${_searchDates.end.day} Mar, '
        '$_guestCount Guest${_guestCount > 1 ? 's' : ''}';

    // Selected room for bottom bar
    final selectedRoom =
        _selectedRoomIndex != null ? _rooms[_selectedRoomIndex!] : _rooms[0];
    final int price = selectedRoom['pricePerNight'] as int;
    final int taxes = selectedRoom['taxes'] as int;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // ── APP BAR ──────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.hotelName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              dateLabel,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => EditSearchSheet.show(
      context: context,
      initialDates: _searchDates,
      initialGuests: _guestCount,
      initialRooms: _roomCount,
      onUpdate: (dates, guests, rooms) {
        setState(() {
          _searchDates = dates;
          _guestCount = guests;
          _roomCount = rooms;
        });
      },
      showStepperDialog: _showStepperDialog,
      editTile: _editTile,
    ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Edit',
                  style: TextStyle(
                    color: Color(0xFF1565C0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.keyboard_arrow_up,
                    size: 16, color: Color(0xFF1565C0)),
              ],
            ),
          ),
        ],
      ),

      // ── BOTTOM BAR CALLING ───────────────────────────────────────────
      bottomNavigationBar: buildBottomBar(
        context: context,
        price: price,
        taxes: taxes,
        room: selectedRoom,
        guestCount: _guestCount,
        roomCount: _roomCount,
        formatPrice: _formatPrice,
        selectedDates: _searchDates,
        hotelName: widget.hotelName,
      ),

      // ── FAB: Room Types ──────────────────────────────────────
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: GestureDetector(
          onTap: () => RoomTypesSheet.show(
            context: context,
            rooms: _rooms,
            formatPrice: _formatPrice,
            onRoomSelected: (idx) {
              setState(() {
                _expandedRooms.add(idx);
                _selectedRoomIndex = idx;
              });

              WidgetsBinding.instance.addPostFrameCallback((_) {
                final key = _roomKeys[idx];
                if (key.currentContext != null) {
                  Scrollable.ensureVisible(
                    key.currentContext!,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                }
              });
            },
          ),
          child: Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x40000000),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: const Icon(Icons.menu, color: Colors.white, size: 24),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      // ── BODY ─────────────────────────────────────────────────
      body: Column(
        children: [
          // Filter chips
        FilterChips(
        freeCancellation: _freeCancellation,
        addMeals: _addMeals,
        onFreeCancellationTap: () {
          setState(() {
            _freeCancellation = !_freeCancellation;
          });
        },
        onAddMealsTap: () {
          setState(() {
            _addMeals = !_addMeals;
          });
        },
      ),

          // Room cards list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              itemCount: _rooms.length,
              itemBuilder: (context, index) =>
                  RoomCard(
                    room: _rooms[index],
                    index: index,
                    size: size,
                    keyValue: _roomKeys[index],
                    isSelected: _selectedRoomIndex == index,
                    isExpanded: _expandedRooms.contains(index),

                    onToggleExpand: () {
                      setState(() {
                        if (_expandedRooms.contains(index)) {
                          _expandedRooms.remove(index);
                        } else {
                          _expandedRooms.add(index);
                        }
                      });
                    },

                    onSelect: () {
                      setState(() => _selectedRoomIndex = index);
                    },

                    onRoomDetailsTap: () {
                      RoomDetailsSheet.show(
                        context: context,
                        hotelName: widget.hotelName,
                        room: _rooms[index],
                        guestCount: _guestCount,
                        roomCount: _roomCount,
                      );
                    },

                    planCard: PlanCard(
                      context: context,
                      index: index,
                      room: selectedRoom,
                      selectedRoomIndex: _selectedRoomIndex,
                      onSelect: (i) {
                        setState(() => _selectedRoomIndex = i);
                      },
                      formatPrice: _formatPrice,
                    ),
                  )
            ),
          ),
        ],
      ),
    );
  }











  // ── PRICE FORMATTER ─────────────────────────────────────────
  String _formatPrice(int price) {
    if (price >= 1000) {
      final String s = price.toString();
      if (s.length > 3) {
        return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
      }
    }
    return price.toString();
  }



  // Helper: blue tile used inside the edit search sheet
  Widget _editTile({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1565C0),
                      fontWeight: FontWeight.w500)),
              const Icon(Icons.keyboard_arrow_down,
                  size: 16, color: Color(0xFF1565C0)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
        ],
      ),
    );
  }

  // Helper: simple stepper dialog for guest/room count
  void _showStepperDialog(
    BuildContext ctx, {
    required String title,
    required int value,
    required int min,
    required int max,
    required ValueChanged<int> onChanged,
  }) {
    int current = value;
    showDialog(
      context: ctx,
      builder: (_) => StatefulBuilder(
        builder: (dCtx, setDState) => AlertDialog(
          title: Text(title),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: current > min
                    ? () => setDState(() => current--)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
                color: const Color(0xFF1565C0),
                iconSize: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('$current',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                onPressed: current < max
                    ? () => setDState(() => current++)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
                color: const Color(0xFF1565C0),
                iconSize: 30,
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dCtx),
                child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8520A),
                  foregroundColor: Colors.white),
              onPressed: () {
                onChanged(current);
                Navigator.pop(dCtx);
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }


}


