import 'package:flutter/material.dart';
import '../screens/offer_details_screen.dart';

class HomeTodayOffers extends StatelessWidget {
  const HomeTodayOffers({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final offers = [
      {
        "title": "Up to 40% OFF on Sarovar Hotels & Resorts.",
        "validity": "Limited Period Offer",
        "image": "lib/assets/bg_image.jpeg",
        "brandLabel": "SAROVAR",
        "brandSub": "HOTELS & RESORTS",
        "headerText": "Enjoy Comfortable & Stylish Stays\nat Sarovar Hotels & Resorts!",
        "promoCode": "Get up to 40% OFF*",
        "validityDate": "31st Mar'26",
      },
      {
        "title": "Get FLAT 10% OFF on Summit Hotels & Resorts!",
        "validity": "Offer validity: 27 Mar 2026",
        "image": "lib/assets/bg_image.jpeg",
        "brandLabel": "summit",
        "brandSub": "HOTELS & RESORTS",
        "headerText": "Experience Luxury Stays\nat Summit Hotels & Resorts!",
        "promoCode": "Get FLAT 10% OFF*",
        "validityDate": "27th Apr'26",
      },
    ];

    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OfferDetailsScreen(offerData: offer)),
              );
            },
            child: Container(
              width: size.width * 0.75,
              margin: EdgeInsets.only(right: 16, left: index == 0 ? 0 : 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image with Logo Overlay
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.asset(
                          offer["image"]!,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 160,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                offer["brandLabel"]!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1565C0),
                                  fontSize: 10,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Text(
                                offer["brandSub"]!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 6,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offer["title"]!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xDE000000),
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Offer validity: ${offer["validity"]}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
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
