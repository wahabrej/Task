import 'package:flutter/material.dart';
import 'package:task_weather/services/api_services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherApi _weatherApi = WeatherApi();
  String cityName = "New York";
  Map<String, dynamic>? currentWeather;
  List<dynamic>? sevenDayForecast;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeatherData(cityName);
  }

  void fetchWeatherData(String city) async {
    setState(() {
      isLoading = true;
    });
    try {
      currentWeather = await _weatherApi.fetchCurrentWeather(city);
      final lat = currentWeather!["coord"]["lat"];
      final lon = currentWeather!["coord"]["lon"];
      final forecast = await _weatherApi.fetchSevenDayForecast(lat, lon);
      sevenDayForecast = forecast["daily"];
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: ${e.toString()}"),
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: WeatherSearchDelegate(
                    onCitySelected: fetchWeatherData,
                  ));
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (currentWeather != null) ...[
                  WeatherToday(currentWeather!),
                  Expanded(
                    child: ListView.builder(
                      itemCount: sevenDayForecast?.length ?? 0,
                      itemBuilder: (context, index) {
                        final day = sevenDayForecast![index];
                        return ListTile(
                          title: Text(
                              "Day ${index + 1}: ${day["temp"]["min"]}°C / ${day["temp"]["max"]}°C"),
                          subtitle: Text("${day["weather"][0]["description"]}"),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

class WeatherToday extends StatelessWidget {
  final Map<String, dynamic> weather;

  WeatherToday(this.weather);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text("${weather['main']['temp']}°C"),
        subtitle: Text("${weather['weather'][0]['description']}"),
      ),
    );
  }
}

class WeatherSearchDelegate extends SearchDelegate {
  final Function(String) onCitySelected;

  WeatherSearchDelegate({required this.onCitySelected});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onCitySelected(query);
    close(context, null);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
