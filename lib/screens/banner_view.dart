import 'package:flutter/material.dart';

class BannerView extends StatefulWidget {
  const BannerView({Key? key}) : super(key: key);

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  late PageController _pageController;
  int _currentPage = 0;

  // 🔥 Add your banner images here
  final List<String> _assetImages = [
    'lib/assets/bg_image.jpeg',
    // 'lib/assets/bg_image.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // 🔥 Banner Slider
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _assetImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  _assetImages[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // 🔥 Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _assetImages.length,
                (index) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? Colors.orange
                    : Colors.grey.shade400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}