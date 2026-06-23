import 'package:flutter/material.dart';
import 'package:weather_y18/pages/weather_details.dart';
import 'search_bar.dart';
import 'package:weather_y18/model/savedCities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_y18/services/weatherApiServices.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    loadCities();
  }
  WeatherApiServices api = WeatherApiServices();
  Future<void> loadCities() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      SavedCities.cities =
          prefs.getStringList('savedCities') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: false,
        title: Text(
          "Weather",
          style: TextStyle(
            fontSize: 44,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Colors.black26,
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: Icon(Icons.search),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WeatherAppHomeScreen(),
                      ),
                    );

                    await loadCities();

                },
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount:SavedCities.cities.length,
          itemBuilder: (context , index) {
            return InkWell(

                onTap: () async {
                  try {
                    final weather = await api.fetchWeather(
                      SavedCities.cities[index],
                    );

                    if (!mounted) return;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WeatherDetails(weather: weather),
                      ),
                    );
                  } catch (e) {
                    debugPrint("Error: $e");
                  }
                },
              child:Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        SavedCities.cities[index],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              )
            );
          }),
    );
  }
}

