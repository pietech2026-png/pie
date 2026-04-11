import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://pie-backend-fnfs.onrender.com/api";

  static Future<void> createLead(Map<String, dynamic> leadData) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/leads"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(leadData),
      );
      if (response.statusCode != 201) {
        print("Failed to create lead: ${response.body}");
      } else {
        print("Lead created successfully");
      }
    } catch (e) {
      print("Error creating lead: $e");
    }
  }
}
