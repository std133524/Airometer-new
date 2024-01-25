import 'package:air_quality_app/model/air_quality/air_quality.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';
//import 'package:percent_indicator/circular_percent_indicator.dart';
//import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AQIDataWidget extends StatelessWidget {
  final AirQuality airQuality;

  const AQIDataWidget({Key? key, required this.airQuality}) : super(key: key);

  @override
  Widget build(BuildContext context)  {
    int aqi = airQuality.list![0].main!.aqi!;

    aqi = Random().nextInt(5) + 1;
    double aqiPercent = aqi / 5;

    return Container(
      alignment: Alignment.center,
      child:
      CircularPercentIndicator(
        radius: 120,
        lineWidth: 15,
        animation: true,
        animationDuration: 2000,
        startAngle: 185,
        percent: aqiPercent,
        progressColor: progressColor(aqi),
        backgroundColor: Colors.grey.shade400,
        circularStrokeCap: CircularStrokeCap.round,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 120, width: 120, child: aqiImage(aqi)),
            Text(
              aqiText(aqi),
              style: TextStyle(color: Colors.grey.shade800, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Color progressColor(int aqi) {
    switch (aqi) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.deepOrange.shade400;
      case 5:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Image aqiImage(int aqi) => Image.asset('assets/images/$aqi.png');

  String aqiText(int aqi) {
    switch (aqi) {
      case 1:
        return 'Καλή:1';
      case 2:
        return 'Μέτρια:2 ';
      case 3:
        return 'Ανθυγιεινή:3';
      case 4:
        return 'Πολύ Ανθυγιεινή:4';
      case 5:
        return 'Επικίνδυνη!:5';
      default:
        return 'AQI';
    }
  }


}
