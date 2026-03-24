import 'package:flutter/material.dart';
import 'verify_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  String phoneNumber = "";

  void _onKeyPressed(String value) {
    if (phoneNumber.length < 15) {
      setState(() {
        phoneNumber += value;
      });
    }
  }

  void _onBackspacePressed() {
    if (phoneNumber.isNotEmpty) {
      setState(() {
        phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6), // Light grey background
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Back button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Color(0xFF1E244D)),
                    ),
                    const SizedBox(height: 32),
                    
                    // Title
                    const Text(
                      "What is your\nphone number?",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E244D),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Subtitle
                    const Text(
                      "Tap \"Continue\" to get an SMS confirmation to help\nyou use Pie. We would like your phone number.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Phone Input Field
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Country Code
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Changing Country Code...")));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Country Code", style: TextStyle(color: Colors.grey, fontSize: 11)),
                              const SizedBox(height: 4),
                              Row(
                                children: const [
                                  Text("+1", style: TextStyle(fontSize: 18, color: Color(0xFF1E244D))),
                                  SizedBox(width: 8),
                                  Icon(Icons.keyboard_arrow_down, color: Color(0xFF1E244D), size: 18),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Container(height: 1.5, width: 60, color: const Color(0xFF1E244D)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Phone Number
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                phoneNumber.isEmpty ? "Phone number" : phoneNumber,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: phoneNumber.isEmpty ? Colors.grey : const Color(0xFF1E244D),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(height: 1.5, width: double.infinity, color: const Color(0xFFECA322)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                    
                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFECA322),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        onPressed: () {
                          if (phoneNumber.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const VerifyScreen()),
                            );
                          }
                        },
                        child: const Text("CONTINUE", style: TextStyle(color: Color(0xFF1E244D), fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            
            // Custom DialPad
            Container(
              color: const Color(0xFFE8EAF1),
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: Column(
                children: [
                   _dialRow(["1", "", "2", "ABC", "3", "DEF"]),
                   _dialRow(["4", "GHI", "5", "JKL", "6", "MNO"]),
                   _dialRow(["7", "PQRS", "8", "TUV", "9", "WXYZ"]),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       const Expanded(child: SizedBox()),
                       Expanded(
                         child: GestureDetector(
                           behavior: HitTestBehavior.opaque,
                           onTap: () => _onKeyPressed("0"),
                           child: Container(
                             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                             padding: const EdgeInsets.symmetric(vertical: 10),
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(6),
                             ),
                             child: const Center(
                               child: Text("0", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xFF1E244D))),
                             ),
                           ),
                         ),
                       ),
                       Expanded(
                         child: GestureDetector(
                           behavior: HitTestBehavior.opaque,
                           onTap: _onBackspacePressed,
                           child: const Center(
                             child: Icon(Icons.backspace_outlined, color: Colors.grey, size: 24),
                           ),
                         ),
                       ),
                     ],
                   ),
                   const SizedBox(height: 16),
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 24.0),
                     child: HitTestTarget(
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           const SizedBox(width: 24),
                           Container(width: 120, height: 4, decoration: BoxDecoration(color: const Color(0xFF1E244D), borderRadius: BorderRadius.circular(2))),
                           const Icon(Icons.mic_none, color: Colors.grey, size: 24),
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
    );
  }

  Widget _dialRow(List<String> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _dialKey(items[0], items[1]),
        _dialKey(items[2], items[3]),
        _dialKey(items[4], items[5]),
      ],
    );
  }

  Widget _dialKey(String number, String letters) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onKeyPressed(number),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Text(number, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xFF1E244D))),
              if (letters.isNotEmpty)
                Text(letters, style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
              if (letters.isEmpty)
                 const SizedBox(height: 11), // maintain alignment
            ],
          ),
        ),
      ),
    );
  }
}

class HitTestTarget extends StatelessWidget {
  final Widget child;
  const HitTestTarget({super.key, required this.child});
  @override
  Widget build(BuildContext context) => child;
}
