import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  static Future<List<dynamic>> searchLocation(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse(
        "https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5&countrycodes=in",
    );

    final response = await http.get(
      url,
      headers: {
        'User-Agent': 'pi-hotel-app',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }
}