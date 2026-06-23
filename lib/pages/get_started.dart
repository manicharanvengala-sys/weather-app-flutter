import 'package:flutter/material.dart';
import 'package:weather_y18/pages/search_bar.dart';


class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/7xm2_1v9x_230103.jpg',
              width: 280,
              height: 280,
            ),

            SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(300, 50),
                backgroundColor: Colors.orangeAccent,
              ),

              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => const WeatherAppHomeScreen(),
                    ),
                );
                print('Get Started');
              },
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
