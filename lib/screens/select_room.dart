// ======================= SELECT ROOM SCREEN =======================

import 'package:flutter/material.dart';

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
            onPressed: () => _showEditSearchSheet(context),
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

      // ── BOTTOM BAR ───────────────────────────────────────────
      bottomNavigationBar: _buildBottomBar(price, taxes, selectedRoom),

      // ── FAB: Room Types ──────────────────────────────────────
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: GestureDetector(
          onTap: () => _showRoomTypesSheet(context),
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
          _buildFilterChips(size),

          // Room cards list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              itemCount: _rooms.length,
              itemBuilder: (context, index) =>
                  _buildRoomCard(context, index, size),
            ),
          ),
        ],
      ),
    );
  }

  // ── FILTER CHIPS ────────────────────────────────────────────
  Widget _buildFilterChips(Size size) {
    return Container(
      color: Colors.white,
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          _filterChip(
            label: 'Free Cancellation',
            selected: _freeCancellation,
            onTap: () =>
                setState(() => _freeCancellation = !_freeCancellation),
          ),
          const SizedBox(width: 10),
          _filterChip(
            label: 'Add Meals  ⌄',
            selected: _addMeals,
            onTap: () => setState(() => _addMeals = !_addMeals),
          ),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFE3F2FD)
              : Colors.white,
          border: Border.all(
            color: selected
                ? const Color(0xFF1565C0)
                : Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: selected
                ? const Color(0xFF1565C0)
                : Colors.black87,
            fontWeight: selected
                ? FontWeight.w600
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // ── ROOM CARD ───────────────────────────────────────────────
  Widget _buildRoomCard(BuildContext context, int index, Size size) {
    final room = _rooms[index];
    final bool isSelected = _selectedRoomIndex == index;
    final bool hasElite = room['elitePackage'] as bool;
    final bool isExpanded = _expandedRooms.contains(index);

    return AnimatedContainer(
      key: _roomKeys[index],
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isSelected
            ? Border.all(color: const Color(0xFF1565C0), width: 2)
            : null,
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Elite Package badge
          if (hasElite)
            _elitePackageBanner(
              room['eliteSavings'] as int,
              room['elitePrice'] as int,
            ),

          // ── Room type title + toggle arrow ──────────────────
          GestureDetector(
            onTap: () => setState(() {
              if (isExpanded) {
                _expandedRooms.remove(index);
              } else {
                _expandedRooms.add(index);
              }
            }),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      room['type'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.0 : -0.5, // points up when expanded
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 24,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Collapsible body ────────────────────────────────
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 280),
            crossFadeState: isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 12),
                  child: Text(
                    'Max ${room['maxGuests']} Guests',
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500),
                  ),
                ),

                // Image + specs row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Room image with photo count badge
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              room['image'] as String,
                              width: size.width * 0.34,
                              height: size.width * 0.28,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: size.width * 0.34,
                                height: size.width * 0.28,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.hotel,
                                    size: 40, color: Colors.grey),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.photo_library_outlined,
                                      color: Colors.white, size: 13),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${room['imageCount']}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 14),

                      // Specs column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _specRow(Icons.square_foot_rounded,
                                room['sqft'] as String),
                            const SizedBox(height: 8),
                            _specRow(Icons.bed_outlined,
                                room['bedType'] as String),
                            const SizedBox(height: 8),
                            _specRow(Icons.bathtub_outlined,
                                room['bathrooms'] as String),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () =>
                                  _showRoomDetailsSheet(context, room),
                              child: const Text(
                                'Room Details',
                                style: TextStyle(
                                  color: Color(0xFF1565C0),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Plan card
                _buildPlanCard(context, index, room, size),
              ],
            ),
            secondChild: const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  // ── ELITE BANNER ────────────────────────────────────────────
  Widget _elitePackageBanner(int savings, int price) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF3E0),
        border: Border.all(color: const Color(0xFFD4A017)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD4A017)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Elite Package',
                  style: TextStyle(
                    color: Color(0xFFB8860B),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                  fontSize: 13, color: Colors.black87),
              children: [
                const TextSpan(text: 'Enjoy benefits worth '),
                TextSpan(
                  text: '₹$savings',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const TextSpan(text: ' at just '),
                TextSpan(
                  text: '₹$price only',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── PLAN CARD ───────────────────────────────────────────────
  Widget _buildPlanCard(
    BuildContext context,
    int index,
    Map<String, dynamic> room,
    Size size,
  ) {
    final List<String> benefits =
        (room['benefits'] as List).cast<String>();
    final int price = room['pricePerNight'] as int;
    final int taxes = room['taxes'] as int;
    final String cancellationTill =
        room['freeCancellationTill'] as String;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan title row with info icon
          Text(
            room['planTitle'] as String,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          // Benefits list
          ...benefits.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle,
                      size: 7, color: Colors.black45),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(b,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black87)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          GestureDetector(
            onTap: () => _showPlanDetailsSheet(context, room),
            child: const Text(
              'Plan Details',
              style: TextStyle(
                color: Color(0xFF1565C0),
                fontWeight: FontWeight.w600,
                fontSize: 13,
                decoration: TextDecoration.underline,
              ),
            ),
          ),

          const Divider(height: 20),

          // Free cancellation
          Row(
            children: [
              const Icon(Icons.check_circle_outline,
                  color: Color(0xFF2E7D32), size: 16),
              const SizedBox(width: 6),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                      fontSize: 13, color: Colors.black87),
                  children: [
                    const TextSpan(
                      text: 'Free Cancellation ',
                      style: TextStyle(
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: 'till $cancellationTill'),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => _showPlanInfoSheet(context, room),
                child: const Icon(Icons.info_outline,
                    size: 14, color: Colors.black45),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Price + Select button
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: '₹${_formatPrice(price)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: ' +₹',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54),
                          ),
                          TextSpan(
                            text: _formatPrice(taxes),
                            style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54),
                          ),
                          const TextSpan(
                            text: ' taxes & fees',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'per night',
                      style: TextStyle(
                          fontSize: 12, color: Colors.black45),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() => _selectedRoomIndex = index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 11),
                  decoration: BoxDecoration(
                    color: _selectedRoomIndex == index
                        ? const Color(0xFF1565C0)
                        : Colors.white,
                    border: Border.all(
                        color: const Color(0xFF1565C0), width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_selectedRoomIndex == index) ...[
                        const Icon(Icons.check,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        _selectedRoomIndex == index
                            ? 'Selected'
                            : 'Select',
                        style: TextStyle(
                          color: _selectedRoomIndex == index
                              ? Colors.white
                              : const Color(0xFF1565C0),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── BOTTOM BAR ───────────────────────────────────────────────
  Widget _buildBottomBar(
      int price, int taxes, Map<String, dynamic> room) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 10,
              offset: Offset(0, -3))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected room mini info
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    room['image'] as String,
                    width: 44,
                    height: 38,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 44,
                      height: 38,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.hotel,
                          size: 20, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room['type'] as String,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.person_outline,
                              size: 13, color: Colors.black45),
                          const SizedBox(width: 4),
                          Text(
                            '$_guestCount Adult${_guestCount > 1 ? 's' : ''}',
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black45),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              color: const Color(0xFFF5F5F5),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '$_roomCount Room${_roomCount > 1 ? 's' : ''} – Fits $_guestCount Adult${_guestCount > 1 ? 's' : ''}',
                  style: const TextStyle(
                      fontSize: 12, color: Colors.black54),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Strike price
                      Text(
                        '₹${_formatPrice((price * 1.2).round())}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black45,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.local_offer_outlined,
                              size: 13,
                              color: Color(0xFF1565C0)),
                          const SizedBox(width: 4),
                          const Text(
                            '2 Offers Applied',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF1565C0),
                                fontWeight: FontWeight.w600),
                          ),
                          const Icon(Icons.keyboard_arrow_up,
                              size: 16,
                              color: Color(0xFF1565C0)),
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: '₹${_formatPrice(price)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(
                              text: ' per night',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '+₹${_formatPrice(taxes)} taxes & fees',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black45),
                      ),
                    ],
                  ),
                ),

                // Continue button
                ElevatedButton(
                  onPressed: () {
                    // Navigate forward to booking flow
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Proceeding to booking...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE8520A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── SPEC ROW HELPER ─────────────────────────────────────────
  Widget _specRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black54),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style:
                const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),
      ],
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

  // ── EDIT SEARCH SHEET ────────────────────────────────────────
  void _showEditSearchSheet(BuildContext context) {
    // Local temp state inside the sheet
    DateTimeRange tempDates = _searchDates;
    int tempGuests = _guestCount;
    int tempRooms = _roomCount;

    final List<String> months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final List<String> days = [
      '', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
    ];
    String weekday(DateTime d) => days[d.weekday];
    String month(DateTime d) => months[d.month];

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (ctx, anim1, anim2) => Align(
        alignment: Alignment.topCenter,
        child: Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          child: StatefulBuilder(
            builder: (ctx, setSheetState) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  // Add safe area top padding + Appbar height roughly so it doesn't overlap status bar
                  top: MediaQuery.of(ctx).padding.top + 16,
                  bottom: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Subtitle
                    const Text(
                      'Select your travel dates for best price',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    const SizedBox(height: 16),

                    // Date tiles row
                    Row(
                      children: [
                        // Check-in
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: ctx,
                                initialDate: tempDates.start,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                              );
                              if (picked != null) {
                                setSheetState(() {
                                  tempDates = DateTimeRange(
                                    start: picked,
                                    end: picked.isBefore(tempDates.end)
                                        ? tempDates.end
                                        : picked.add(const Duration(days: 1)),
                                  );
                                });
                              }
                            },
                            child: _editTile(
                              label: 'Checkin Date',
                              value:
                                  '${weekday(tempDates.start)}, ${tempDates.start.day} ${month(tempDates.start)} \'${tempDates.start.year % 100}',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Check-out
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: ctx,
                                initialDate: tempDates.end,
                                firstDate: tempDates.start
                                    .add(const Duration(days: 1)),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                              );
                              if (picked != null) {
                                setSheetState(() {
                                  tempDates = DateTimeRange(
                                      start: tempDates.start, end: picked);
                                });
                              }
                            },
                            child: _editTile(
                              label: 'Checkout Date',
                              value:
                                  '${weekday(tempDates.end)}, ${tempDates.end.day} ${month(tempDates.end)} \'${tempDates.end.year % 100}',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Guests + Rooms row
                    Row(
                      children: [
                        // Guests stepper
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showStepperDialog(
                              ctx,
                              title: 'Adults',
                              value: tempGuests,
                              min: 1,
                              max: 10,
                              onChanged: (v) =>
                                  setSheetState(() => tempGuests = v),
                            ),
                            child: _editTile(
                              label: 'Guests',
                              value:
                                  '$tempGuests Adult${tempGuests > 1 ? 's' : ''} 0 Children',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Rooms stepper
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showStepperDialog(
                              ctx,
                              title: 'Rooms',
                              value: tempRooms,
                              min: 1,
                              max: 10,
                              onChanged: (v) =>
                                  setSheetState(() => tempRooms = v),
                            ),
                            child: _editTile(
                              label: 'Rooms',
                              value: '$tempRooms Room${tempRooms > 1 ? 's' : ''}',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Update Search button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8520A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          // Apply to main state
                          setState(() {
                            _searchDates = tempDates;
                            _guestCount = tempGuests;
                            _roomCount = tempRooms;
                          });
                          Navigator.pop(ctx);
                        },
                        child: const Text(
                          'Update Search',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
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

  // ── ROOM DETAILS BOTTOM SHEET ────────────────────────────────
  void _showRoomDetailsSheet(
      BuildContext context, Map<String, dynamic> room) {
    final size = MediaQuery.of(context).size;
    int currentPage = 0;
    
    // Default to 'imageCount' or 5 images, using the placeholder image repeated
    final int imgCount = room['imageCount'] as int? ?? 5;
    final List<String> images = List.generate(
      imgCount,
      (_) => room['image'] as String,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: size.height * 0.85,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 8, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Room Details',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.hotelName,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 1. Room Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room['type'] as String,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        // Image carousel
                        StatefulBuilder(
                          builder: (ctx, setStackState) => Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              SizedBox(
                                height: 180,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RoomImagesScreen(
                                          hotelName: widget.hotelName,
                                          roomType: room['type'] as String,
                                          images: images,
                                          guestCount: _guestCount,
                                          roomCount: _roomCount,
                                          price: room['pricePerNight'] as int,
                                          taxes: room['taxes'] as int,
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: PageView.builder(
                                      onPageChanged: (index) {
                                        setStackState(() {
                                          currentPage = index;
                                        });
                                      },
                                      itemCount: images.length,
                                      itemBuilder: (context, index) {
                                        return Image.asset(
                                          images[index],
                                          width: double.infinity,
                                          height: 180,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Container(
                                            width: double.infinity,
                                            height: 180,
                                            color: Colors.grey.shade200,
                                            child: const Icon(Icons.hotel,
                                                size: 50, color: Colors.grey),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children:
                                        List.generate(images.length, (index) {
                                      return Container(
                                        margin: EdgeInsets.only(
                                            right: index == images.length - 1
                                                ? 0
                                                : 4),
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: currentPage == index
                                              ? const Color(0xFFE8520A)
                                              : Colors.white54,
                                          shape: BoxShape.circle,
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Specs Grid (2x2)
                        Row(
                          children: [
                            Expanded(
                              child: _specRow(Icons.square_foot_rounded,
                                  room['sqft'] as String),
                            ),
                            Expanded(
                              child:
                                  _specRow(Icons.window_outlined, 'City View'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _specRow(
                                  Icons.bed_outlined, room['bedType'] as String),
                            ),
                            Expanded(
                              child: _specRow(Icons.bathtub_outlined,
                                  room['bathrooms'] as String),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 2. Amenities Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Amenities',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: Color(0xFFEEEEEE)),
                        const SizedBox(height: 16),
                        const Text(
                          'Popular with Guests',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        ...(room['benefits'] as List<dynamic>)
                            .cast<String>()
                            .map(
                              (b) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Container(
                                        width: 5,
                                        height: 5,
                                        decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        b,
                                        style: const TextStyle(
                                            fontSize: 13, color: Colors.black87),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── PLAN DETAILS BOTTOM SHEET ────────────────────────────────
  void _showPlanDetailsSheet(
      BuildContext context, Map<String, dynamic> room) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    room['planTitle'] as String,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close)),
              ],
            ),
            const Divider(),
            ...(room['benefits'] as List<dynamic>)
                .cast<String>()
                .map(
                  (b) => ListTile(
                    dense: true,
                    leading: const Icon(Icons.check_circle,
                        color: Color(0xFF2E7D32), size: 20),
                    title: Text(b,
                        style: const TextStyle(fontSize: 13)),
                  ),
                ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // ── PLAN INFO SHEET (info ⓘ icon) ───────────────────────────
  // Shows Cancellation Policy + Plan Details with descriptions
  void _showPlanInfoSheet(
      BuildContext context, Map<String, dynamic> room) {
    // Build plan detail items with description
    final List<Map<String, String>> detailItems = [
      {
        'title': 'Early Check-In upto 2 hours (subject to availability)',
        'desc':
            'Complimentary Early Check-In upto 2 hours before the standard check-in time. This service is subject to availability.',
      },
      {
        'title': 'Late Check-Out upto 2 hours (subject to availability)',
        'desc':
            'Complimentary Late Check-Out upto 2 hours after the standard check-out time. This service is subject to availability.',
      },
      {
        'title': '10% off on Food & Beverages with a-la-carte selection',
        'desc':
            '10% discount on Food & Beverages with a-la-carte selection at Pavilion. This offer is valid per night. This offer includes in-room dining.',
      },
      {
        'title': 'Complimentary Welcome Drink on arrival',
        'desc':
            'Complimentary welcome drinks on arrival, served with Soft Beverages.',
      },
      {
        'title': 'Free Linen Change',
        'desc': 'Complimentary Linen Change is available.',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF5F5F5),
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.88,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (ctx, ctrl) => Column(
          children: [
            // handle
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Header row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room['type'] as String,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          room['planTitle'] as String,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 22),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Scrollable content
            Expanded(
              child: ListView(
                controller: ctrl,
                padding: const EdgeInsets.all(16),
                children: [
                  // Cancellation Policy card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
                          child: Text(
                            'Cancellation Policy',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const Divider(height: 1),
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'This booking is non-refundable and the tariff cannot be cancelled with zero fee.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Plan Details card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
                          child: Text(
                            'Plan Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const Divider(height: 1),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: detailItems.map((item) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text('• ',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['title']!,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item['desc']!,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── ROOM TYPES SHEET (hamburger FAB) ─────────────────────────
  // Shows a summary of all room types with starting price
  void _showRoomTypesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              '${_rooms.length} Room Types',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Room type rows — tappable
            ..._rooms.asMap().entries.map((entry) {
              final idx = entry.key;
              final room = entry.value;
              final isLast = idx == _rooms.length - 1;
              return Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      // 1. Close the sheet
                      Navigator.pop(ctx);
                      // 2. Expand + select the card
                      setState(() {
                        _expandedRooms.add(idx);
                        _selectedRoomIndex = idx;
                      });
                      // 3. Scroll to the card after the frame renders
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final key = _roomKeys[idx];
                        if (key.currentContext != null) {
                          Scrollable.ensureVisible(
                            key.currentContext!,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            alignment: 0.0,
                          );
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  room['type'] as String,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${room['bedType']} | ${room['sqft']}',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'starts at',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black45),
                              ),
                              Text(
                                '₹${_formatPrice(room['pricePerNight'] as int)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast) const Divider(height: 1),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ── ROOM IMAGES SCREEN ───────────────────────────────────────────
class RoomImagesScreen extends StatelessWidget {
  final String hotelName;
  final String roomType;
  final List<String> images;
  final int guestCount;
  final int roomCount;
  final int price;
  final int taxes;

  const RoomImagesScreen({
    super.key,
    required this.hotelName,
    required this.roomType,
    required this.images,
    required this.guestCount,
    required this.roomCount,
    required this.price,
    required this.taxes,
  });

  String _formatPrice(int price) {
    if (price >= 1000) {
      final String s = price.toString();
      if (s.length > 3) {
        return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
      }
    }
    return price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(roomType,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            Text(hotelName,
                style: const TextStyle(color: Colors.black54, fontSize: 13)),
          ],
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              images[index],
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: double.infinity,
                height: 220,
                color: Colors.grey.shade200,
                child: const Icon(Icons.hotel, size: 50, color: Colors.grey),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, -3))
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                color: const Color(0xFFF5F5F5),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '$roomCount Room${roomCount > 1 ? 's' : ''} – Fits $guestCount Adult${guestCount > 1 ? 's' : ''}',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${_formatPrice((price * 1.2).round())}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black45,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.local_offer_outlined,
                                size: 13, color: Color(0xFF1565C0)),
                            const SizedBox(width: 4),
                            const Text(
                              '2 Offers Applied',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF1565C0),
                                  fontWeight: FontWeight.w600),
                            ),
                            const Icon(Icons.keyboard_arrow_up,
                                size: 16, color: Color(0xFF1565C0)),
                          ],
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: '₹${_formatPrice(price)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: ' per night',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '+₹${_formatPrice(taxes)} taxes & fees',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black45),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Proceeding to booking...'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8520A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
