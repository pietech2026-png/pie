import 'package:flutter/material.dart';

class HotelImageSection extends StatelessWidget {
  final List<String> images;
  final int currentIndex;
  final Function(int) onPageChanged;
  final VoidCallback onBack;

  const HotelImageSection({
    super.key,
    required this.images,
    required this.currentIndex,
    required this.onPageChanged,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(12),
          height: size.height * 0.32,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: PageView.builder(
              itemCount: images.length,
              onPageChanged: onPageChanged,
              itemBuilder: (_, i) => Image.asset(
                images[i],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ),

        Positioned(
          top: 40,
          left: 20,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: onBack,
            ),
          ),
        ),

        const Positioned(
          top: 40,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.share),
          ),
        ),
      ],
    );
  }
}
