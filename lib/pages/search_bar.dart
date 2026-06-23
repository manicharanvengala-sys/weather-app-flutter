import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_y18/pages/weather_details.dart';
import 'package:weather_y18/services/weatherApiServices.dart';
import 'package:weather_y18/model/ApiResponse.dart';


class WeatherAppHomeScreen extends StatefulWidget {
  const WeatherAppHomeScreen({super.key});

  @override
  State<WeatherAppHomeScreen> createState() => _WeatherAppHomeScreenState();
}

class _WeatherAppHomeScreenState extends State<WeatherAppHomeScreen> {

  final TextEditingController cityController =
  TextEditingController();
  WeatherApiServices api = WeatherApiServices();
  ApiResponse? data;

  List<dynamic> suggestions = [];

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5C6BC0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: SizedBox(
          height: 50,
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search city",
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.blueGrey,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            controller: cityController,
            onChanged: (value) async {
              if (value.isEmpty) {
                setState(() {
                  suggestions.clear();
                });
                return;
              }

              final result = await api.getSuggestions(value);

              if (cityController.text != value) return;

              setState(() {
                suggestions = result;
              });
            },
          ),
        ),
      ),

      body: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                final weather =
                await api.fetchWeather(suggestions[index]["name"]);

                if (!mounted) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WeatherDetails(
                      weather: weather,
                    ),
                  ),
                );
              },
              child: ListTile(
                leading: const Icon(Icons.location_city),
                title: Text(suggestions[index]["name"]),
                subtitle: Text(
                  "${suggestions[index]["region"]}, "
                      "${suggestions[index]["country"]}",
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}