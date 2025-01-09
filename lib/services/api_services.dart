import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class WeatherApi {
  final String apiKey = "a1f0d993032edcb7bc89c3352c387e59";

  Future<Map<String, dynamic>> fetchCurrentWeather(String cityName) async {
    const url =
        "https://api.openweathermap.org/data/3.0/onecall/timemachine?lat=39.099724&lon=-94.578331&dt=1643803200&appid={apiKey}";
    final response = await http.get(Uri.parse(url));
    log(response.body.length);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load weather data");
    }
  }

  Future<Map<String, dynamic>> fetchSevenDayForecast(
      double lat, double lon) async {
    final url =
        "https://api.openweathermap.org/data/3.0/onecall/timemachine?lat=39.099724&lon=-94.578331&dt=1643803200&appid={API key}";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load forecast data");
    }
  }
}
