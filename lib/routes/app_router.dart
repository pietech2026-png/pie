// ======================= APP FLOW & ROUTING WITH FILE MAPPING =======================

// 1. HomeScreen [lib/screens/home_screen.dart] 
//    → Click "Search Button" 
//    → HotelListScreen [lib/screens/hotel_list_screen.dart]

// 2. HotelListScreen [lib/screens/hotel_list_screen.dart] 
//    → Click "Hotel Card" 
//    → HotelFullViewScreen [lib/screens/hotel_full_view_screen.dart]

// 3. HotelFullViewScreen [lib/screens/hotel_full_view_screen.dart] 
//    → Click "Select Room" 
//    → SelectRoomScreen [lib/screens/select_room.dart]

// 4. SelectRoomScreen [lib/screens/select_room.dart]:
//    - Click "Room Details" 
//      → Logic in: [lib/screens/select_room.dart]
//      → Opens: [lib/widgets/room_details_sheet.dart]
//    - Click "Continue" 
//      → Logic in: [lib/widgets/bottom_bar.dart]
//      → Opens: [lib/screens/continue_screen.dart]

// 5. ContinueScreen [lib/screens/continue_screen.dart]:
//    - Modular View: Uses [lib/widgets/review_hotel_info.dart], [lib/widgets/review_room_info.dart], etc.
//    - Click "View Room & Plan Details" 
//      → Logic in: [lib/widgets/review_room_info.dart]
//      → Reuses: [lib/widgets/room_details_sheet.dart]
//    - Click "Confirm Traveller Details" 
//      → Logic in: [lib/widgets/bottom_bar.dart] (Action Button)
//      → Outcome: Final Booking Confirmation
