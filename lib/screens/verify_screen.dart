import 'package:flutter/material.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  String otpCode = "";

  void _onKeyPressed(String value) {
    if (otpCode.length < 4) {
      setState(() {
        otpCode += value;
      });
    }
  }

  void _onBackspacePressed() {
    if (otpCode.isNotEmpty) {
      setState(() {
        otpCode = otpCode.substring(0, otpCode.length - 1);
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
                      "Verify phone\nnumber",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E244D),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Subtitle
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(text: "Check your SMS messages. We've sent you\nthe PIN at "),
                          TextSpan(text: "79027381524", style: TextStyle(color: Color(0xFFECA322))), // Orange text
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // OTP Input Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _otpSlot(otpCode.length > 0 ? otpCode[0] : "", filled: otpCode.length > 0, active: otpCode.isEmpty),
                        const SizedBox(width: 16),
                        _otpSlot(otpCode.length > 1 ? otpCode[1] : "", filled: otpCode.length > 1, active: otpCode.length == 1),
                        const SizedBox(width: 16),
                        _otpSlot(otpCode.length > 2 ? otpCode[2] : "", filled: otpCode.length > 2, active: otpCode.length == 2),
                        const SizedBox(width: 16),
                        _otpSlot(otpCode.length > 3 ? otpCode[3] : "", filled: otpCode.length > 3, active: otpCode.length == 3),
                      ],
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Resend Text
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          otpCode = "";
                        });
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Verification code resent!")));
                      },
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                          children: [
                            TextSpan(text: "Didn't receive SMS? "),
                            TextSpan(text: "Resend Code", style: TextStyle(color: Color(0xFFECA322))), // Orange text
                          ],
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // VERIFY Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFECA322), // Orange
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        onPressed: () {
                          if (otpCode.length == 4) {
                            // Navigate to Home screen ("hotels thing should show faow not change")
                            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                          } else {
                            // Show generic snackbar for invalid otp
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter a 4-digit code.')),
                            );
                          }
                        },
                        child: const Text("VERIFY", style: TextStyle(color: Color(0xFF1E244D), fontWeight: FontWeight.bold)),
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
                           const SizedBox(width: 24), // Placeholder for alignment
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

  Widget _otpSlot(String digit, {required bool filled, required bool active}) {
    return Column(
      children: [
        SizedBox(
          height: 35,
          child: Text(
            digit,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E244D),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 2,
          width: 40,
          color: active ? const Color(0xFFECA322) : const Color(0xFF1E244D),
        ),
      ],
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
