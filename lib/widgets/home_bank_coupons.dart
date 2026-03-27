import 'package:flutter/material.dart';

class HomeBankCoupons extends StatelessWidget {
  final Map<String, bool> copiedMap;
  final Function(String) onCopy;

  const HomeBankCoupons({
    super.key,
    required this.copiedMap,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
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
                      onTap: () => onCopy(c['code']!),
                      child: Text(
                        isCopied ? "Copied" : "Copy",
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
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
}
