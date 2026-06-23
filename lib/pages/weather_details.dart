import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_y18/model/ApiResponse.dart';
import 'package:intl/intl.dart';
import 'package:weather_y18/model/frosted_glass.dart';
import 'package:weather_y18/model/savedCities.dart';

import 'package:shared_preferences/shared_preferences.dart';

class WeatherDetails extends StatelessWidget {
  final ApiResponse weather;


  const WeatherDetails({
    super.key,
    required this.weather,

});


  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    List<Hour> next24hrs = [];


    for(var hour in weather.forecast!.forecastday![0].hour!){
      final hourTime = DateTime.parse(hour.time!);

      if (hourTime.isAfter(now)){
        next24hrs.add(hour);
      }
    }
    if (next24hrs.length < 24) {
      for (var hour in weather.forecast!.forecastday![1].hour!) {
        next24hrs.add(hour);

        if (next24hrs.length == 24) break;
      }
    }
    final days = weather.forecast?.forecastday ?? [];
    return Scaffold(
        backgroundColor: Colors.transparent,

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () async {
          final city = weather.location?.name;

          if (city != null &&
              !SavedCities.cities.contains(city)) {

            SavedCities.cities.add(city);

            final prefs = await SharedPreferences.getInstance();
            await prefs.setStringList(
              'savedCities',
              SavedCities.cities,
            );
          }

          Navigator.pop(context); // go back to existing Home
        },
        child: const Icon(Icons.add),
      ),

        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF7E5F),
                  Color(0xFFFEB47B),
                ],
            ),
          ),
      child : ListView(
        children: [
          Center(
            child: FrostedGlass(
              width: 350.0,
              height: 280.0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("MY LOCATION", style: TextStyle(fontSize: 24)),
                    Text("${weather.location?.name}",
                        style: TextStyle(fontSize: 24)),
                    Text("${weather.current?.tempC}",
                        style: TextStyle(fontSize: 40)),
                    Text("Mostly Cloudy",
                        style: TextStyle(fontSize: 16)),
                    Text("H:32  L:25",
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),

          FrostedGlass(
            width: MediaQuery.of(context).size.width - 32,
            height: 220.0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Hourly Forecast",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(),

                  SizedBox(height: 10),

                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: next24hrs.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 90,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('h a').format(
                                  DateTime.parse(next24hrs[index].time!),
                                ),
                              ),
                              Text(
                                "${next24hrs[index].tempC}°C",
                                style: TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          FrostedGlass(
            width: MediaQuery.of(context).size.width - 32.0,
            height: 450.0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Daily Forecast",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(),

                  Expanded(
                    child: ListView.builder(
                      itemCount: days.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              "${DateFormat('EEEE').format(DateTime.parse(days[index].date!))} "
                                  "${days[index].day?.maxTempC ?? '--'}°C",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(
              child: FrostedGlass(
                  width: double.infinity,
                  height: 150.0,
                  child:
              Text("Humidity"),
              ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: FrostedGlass(
                    width: double.infinity,
                    height: 150.0,
                    child:
                    Text("$weather"),

                ),
              ),

            ],
          )
        ],


      ),
      ),
    );

  }
}
