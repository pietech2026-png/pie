import 'package:flutter/material.dart';

class HomeSectionTitle extends StatelessWidget {
  final String title;

  const HomeSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Text(
      title,
      style: TextStyle(
        fontSize: size.width * 0.05,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class HomeHorizontalList extends StatelessWidget {
  final double heightFactor;
  final String seed;

  const HomeHorizontalList({
    super.key,
    required this.heightFactor,
    required this.seed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
}
