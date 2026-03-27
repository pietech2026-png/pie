import 'package:flutter/material.dart';
import 'package:pie/services/auth_service.dart';

class ReviewTravellerDetails extends StatefulWidget {
  const ReviewTravellerDetails({super.key});

  @override
  State<ReviewTravellerDetails> createState() => ReviewTravellerDetailsState();
}

class ReviewTravellerDetailsState extends State<ReviewTravellerDetails> {
  String selectedTitle = 'Mr.';
  bool saveToProfile = false;
  bool hasGST = false;
  bool agreeToTerms = true;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-fill phone number from AuthService if available
    if (AuthService.phoneNumber != null) {
      phoneController.text = AuthService.phoneNumber!;
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    phoneFocus.dispose();
    emailFocus.dispose();
    super.dispose();
  }

  bool validate() {
    if (firstNameController.text.trim().isEmpty) {
      firstNameFocus.requestFocus();
      _showError('First Name is required');
      return false;
    }
    if (lastNameController.text.trim().isEmpty) {
      lastNameFocus.requestFocus();
      _showError('Surname is required');
      return false;
    }
    if (phoneController.text.trim().isEmpty) {
      phoneFocus.requestFocus();
      _showError('Phone Number is required');
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      emailFocus.requestFocus();
      _showError('Email Address is required');
      return false;
    }
    if (!agreeToTerms) {
      _showError('You must agree to the terms');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

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
                    child: _buildTextField(
                      hint: 'First Name',
                      controller: firstNameController,
                      focusNode: firstNameFocus,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      hint: 'Surname',
                      controller: lastNameController,
                      focusNode: lastNameFocus,
                    ),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: const [
                        Text('+91',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: phoneController,
                      focusNode: phoneFocus,
                      keyboardType: TextInputType.phone,
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
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
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
              _buildTextField(
                hint: 'Enter email address',
                controller: emailController,
                focusNode: emailFocus,
                keyboardType: TextInputType.emailAddress,
              ),
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
                _buildTextField(hint: 'Enter Registration Number'),
                const SizedBox(height: 20),
                const Text(
                  'Registered Company Name',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildTextField(hint: 'Enter Registered Company Name'),
                const SizedBox(height: 20),
                const Text(
                  'Registered Company Address',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildTextField(hint: 'Enter Registered Company Address'),
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
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    FocusNode? focusNode,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
