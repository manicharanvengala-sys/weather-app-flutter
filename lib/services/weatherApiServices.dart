import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_y18/model/ApiResponse.dart';

const String apiKey = "ae603634fd8d4e06b3762453260706";

class WeatherApiServices {
  final String baseUrl =
      "https://api.weatherapi.com/v1/forecast.json";

  Future<List<dynamic>> getSuggestions(String query) async {
    final response = await http.get(
      Uri.parse(
        "https://api.weatherapi.com/v1/search.json?key=$apiKey&q=$query",
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }

  Future<ApiResponse> fetchWeather(String location) async {
    try {
      final String apiUrl =
          "$baseUrl?key=$apiKey&q=$location&days=7";

      print("URL: $apiUrl");

      final response = await http.get(
        Uri.parse(apiUrl),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(
          jsonDecode(response.body),
        );
      } else {
        throw Exception(
          "Failed to load weather. Status: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("REAL ERROR: $e");
      rethrow;
    }
  }

  Future<ApiResponse> getCurrentWeatherByLatLong(
      double latitude,
      double longitude,
      ) async {
    try {
      final String apiUrl =
          "$baseUrl?key=$apiKey&q=$latitude,$longitude";

      print("URL: $apiUrl");

      final response = await http.get(
        Uri.parse(apiUrl),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(
          jsonDecode(response.body),
        );
      } else {
        throw Exception(
          "Failed to load weather. Status: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("REAL ERROR: $e");
      rethrow;
    }
  }
}

class LocationService {
  Future<Position> getLocation() async {
    PermissionStatus permission =
    await Permission.location.request();

    if (permission == PermissionStatus.granted) {
      try {
        return await Geolocator.getCurrentPosition();
      } catch (e) {
        throw Exception(
          "Failed to get location: $e",
        );
      }
    } else if (permission == PermissionStatus.denied) {
      throw const PermissionDeniedException(
        "Location permission denied by user",
      );
    } else {
      throw Exception(
        "Location permission not granted",
      );
    }
  }
}

Future<Map<String, dynamic>> getForecast(
    double latitude,
    double longitude,
    ) async {
  final url =
      "https://api.weatherapi.com/v1/forecast.json"
      "?key=$apiKey"
      "&q=$latitude,$longitude"
      "&days=1";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  throw Exception("Failed to load forecast");
}