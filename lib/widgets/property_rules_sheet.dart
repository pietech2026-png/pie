import 'package:flutter/material.dart';

class PropertyRulesSheet extends StatelessWidget {
  const PropertyRulesSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PropertyRulesSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // 🔹 Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Property Rules and Policies',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // 🔹 Content
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(12),
                children: [
                   _buildPolicySection(
                    'Must read',
                    [
                      'Primary Guest should be atleast 18 years of age.',
                      'Aadhaar, Driving License, Govt. ID and Passport are accepted as ID proof(s)',
                      'Pets are not allowed',
                      'Outside food is not allowed',
                      'Smoking within the premises is not allowed',
                    ],
                    Icons.info_outline,
                  ),
                  _buildPolicySection(
                    'Guest Profile',
                    [
                      'Unmarried couples allowed',
                      'Primary guest should be atleast 18 years of age',
                      'Groups with only male guests are allowed at the property',
                    ],
                    Icons.check_circle_outline,
                    iconColor: Colors.blueGrey,
                  ),
                   _buildPolicySection(
                    'Guest Profile (Hourly)',
                    [
                      'Unmarried couples are allowed in hourly stay rooms',
                    ],
                    Icons.check_circle_outline,
                    iconColor: Colors.blueGrey,
                  ),
                  _buildPolicySection(
                    'ID Proof Related',
                    [
                      'Aadhaar, Driving License, Govt. ID and Passport are accepted as ID proof(s)',
                      'Local ids are allowed',
                    ],
                    Icons.check_circle_outline,
                    iconColor: Colors.blueGrey,
                  ),
                   _buildPolicySection(
                    'Smoking/Alcohol consumption Rules',
                    [
                      'Alcohol consumption is not allowed within the property premises.',
                      'Smoking within the premises is not allowed',
                    ],
                    Icons.cancel_outlined,
                    iconColor: Colors.blueGrey,
                  ),
                  _buildPolicySection(
                    'Food Arrangement',
                    [
                      'Non veg food is allowed',
                      'Outside food is not allowed',
                      'Food Delivery is available',
                      'Food Delivery available from Zomato and Swiggy',
                      'In room dining available',
                    ],
                    Icons.check_circle_outline,
                    iconColor: Colors.blueGrey,
                  ),
                   _buildPolicySection(
                    'Property Accessibility',
                    [
                      'This property is not accessible to guests who use a wheelchair. Please make arrangements accordingly.',
                    ],
                    Icons.cancel_outlined,
                    iconColor: Colors.blueGrey,
                  ),
                   _buildPolicySection(
                    'Pet(s) Related',
                    [
                      'Pets are not allowed',
                      'There are no pets living on the property',
                    ],
                    Icons.cancel_outlined,
                    iconColor: Colors.blueGrey,
                  ),
                  _buildPolicySection(
                    'Other Rules',
                    [
                      'Does not allow private parties or events',
                      'Guests are requested not to invite outside visitors in the room during their stay',
                    ],
                    Icons.cancel_outlined,
                    iconColor: Colors.blueGrey,
                  ),
                   _buildPolicySection(
                    'Infant Policy',
                    [
                      '1 infant (0-2 yrs) per room included without counting in total room capacity',
                      'Complimentary infant meals not provided',
                    ],
                    Icons.cancel_outlined,
                    iconColor: Colors.blueGrey,
                  ),
                  _buildPolicySection(
                    'Child Extra Bed Policy',
                    [
                      'An extra bed will be provided to accommodate any child included in the booking for a charge mentioned below.',
                      'INR 1000 will be charged for an extra mattress per child. (To be paid at the property)',
                    ],
                    Icons.info_outline,
                  ),
                  _buildPolicySection(
                    'Adult Extra Bed Policy',
                    [
                      'An extra bed will be provided to accommodate any additional guest included in the booking for a charge mentioned below. (Subject to availability)',
                      'INR 1500 will be charged for an extra mattress per guest. (To be paid at the property)',
                    ],
                    Icons.info_outline,
                  ),
                  _buildPolicySection(
                    'Cancellation Policy',
                    [
                      'Cancellation and prepayment policies vary according to room type. Please check the Fare policy associatedr room.',
                    ],
                    Icons.info_outline,
                  ),
                  _buildPolicySection(
                    'Property Policy',
                    [
                      'According to government regulations, a valid Photo ID has to be carried by every person above the age of 18 staying at Maharaja Classic. The identification proofs accepted are Drivers License, Voters Card, Passport, Ration Card. Without valid ID the guest will not be allowed to check in.',
                      'The primary guest checking in to the hotel must be at least 18 years of age.',
                      'Early check-in or late check-out is subject to availability and may be chargeable by Maharaja Classic. The standard check-in time is 12 PM and the standard check-out time is 10 AM. After booking you will be sent an email confirmation with hotel phone number. You can contact the hotel directly for early check-in or late check-out.',
                      'The room tariff includes all taxes. The amount paid for the room does not include charges for optional services and facilities (such as room service, mini bar, snacks or telephone calls). These will be charged at the time of check-out from the Hotel.',
                      'Goibibo will not be responsible for any check-in denied by the Hotel due to the aforesaid reason.',
                      'Maharaja Classic reserves the right of admission. Accommodation can be denied to guests posing as a \'couple\' if suitable proof of identification is not presented at check-in.Goibibo will not be responsible for any check-in denied by the Hotel',
                      'Maharaja Classic reserves the right of admission for local residents. Accommodation can be denied to guests residing in the same city. Goibibo will not be responsible for any check-in denied by the Hotel due to the aforesaid reason.',
                      'For any update, User shall pay applicable cancellation/modification charges.',
                      'For any concerns or clarifications related to your booking, you can contact the property on 9462662619.',
                      'Modified bookings will be subject to availability and revised booking policy of the Hotel.',
                      'The cancellation/modification charges are standard and any waiver is on the hotel\'s discretion.',
                      'Number of modifications possible on a booking will be on the discretion of Goibibo.',
                      'Selective offers of Goibibo will not be sanctioned on a cancellation or modification of booking.',
                      'Any e-coupon discount on the original booking shall be forfeited in the event of cancellation or modification.',
                    ],
                    Icons.info_outline,
                  ),
                  _buildPolicySection(
                    'Payment Mode',
                    [
                      'You can pay now or you can pay at the hotel if your selected room type has this option.',
                    ],
                    Icons.info_outline,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection(String title, List<String> rules, IconData icon, {Color iconColor = Colors.blueGrey}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...rules.map((rule) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, size: 18, color: iconColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        rule,
                        style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
