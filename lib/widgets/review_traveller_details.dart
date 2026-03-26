import 'package:flutter/material.dart';

class ReviewTravellerDetails extends StatefulWidget {
  const ReviewTravellerDetails({super.key});

  @override
  State<ReviewTravellerDetails> createState() => _ReviewTravellerDetailsState();
}

class _ReviewTravellerDetailsState extends State<ReviewTravellerDetails> {
  String selectedTitle = 'Mr.';
  bool saveToProfile = false;
  bool hasGST = false;
  bool agreeToTerms = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔹 Header
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: const Text(
            'Traveller Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(height: 1),

        // 🔹 Form
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Name',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildRadioOption('Mr.'),
                  _buildRadioOption('Mrs.'),
                  _buildRadioOption('Ms.'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('First Name'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField('Surname'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Phone Number',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: const [
                        Text('+91',
                            style:
                                TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: const TextStyle(color: Color(0xFF1565C0)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Color(0xFF1565C0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Color(0xFF1565C0)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Email Address',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildTextField('Enter email address'),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // 🔹 Pincode & State
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your pincode and state',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: const [
                      Text(
                        'edit',
                        style: TextStyle(
                            color: Color(0xFF1565C0),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      Icon(Icons.keyboard_arrow_down,
                          color: Color(0xFF1565C0), size: 18),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Required for GST purpose on your tax invoice',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              const Text(
                '452006, Madhya Pradesh',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: saveToProfile,
                    onChanged: (v) => setState(() => saveToProfile = v!),
                    activeColor: const Color(0xFF1565C0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  const Text('Save these details to my profile',
                      style: TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // 🔹 GST & Terms
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: hasGST,
                    onChanged: (v) => setState(() => hasGST = v!),
                    activeColor: const Color(0xFF1565C0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                      children: [
                        const TextSpan(text: 'I have a GST number '),
                        TextSpan(
                            text: '(Optional)',
                            style: TextStyle(color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                ],
              ),
              if (hasGST) ...[
                const Divider(height: 24),
                const Text(
                  'Registration Number',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildTextField('Enter Registration Number'),
                const SizedBox(height: 20),
                const Text(
                  'Registered Company Name',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildTextField('Enter Registered Company Name'),
                const SizedBox(height: 20),
                const Text(
                  'Registered Company Address',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildTextField('Enter Registered Company Address'),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
        const Divider(height: 1),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: agreeToTerms,
                onChanged: (v) => setState(() => agreeToTerms = v!),
                activeColor: const Color(0xFF1565C0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        color: Colors.black, fontSize: 11, height: 1.4),
                    children: [
                      const TextSpan(text: 'I agree to Goibibo\'s '),
                      _linkSpan('Privacy Policy'),
                      const TextSpan(text: ', '),
                      _linkSpan('User Agreement'),
                      const TextSpan(text: ' & '),
                      _linkSpan('Terms of Services'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  TextSpan _linkSpan(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Color(0xFF1565C0)),
    );
  }

  Widget _buildRadioOption(String title) {
    return GestureDetector(
      onTap: () => setState(() => selectedTitle = title),
      child: Row(
        children: [
          Radio<String>(
            value: title,
            groupValue: selectedTitle,
            onChanged: (v) => setState(() => selectedTitle = v!),
            activeColor: const Color(0xFF1565C0),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Text(title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
