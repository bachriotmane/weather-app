// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tp_7/models/city.wather.dart';
import 'package:tp_7/ui/pages/home.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getCityNameByPosition(double lat, double long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    return placemarks.first;
  }

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  late CityWeather city;
  @override
  void initState() {
    super.initState();
    city = CityWeather(
      cityName: "Settat",
      lat: 12,
      ampl: 12,
      weatherStatus: "",
      minTemp: 12,
      maxTemp: 12,
    );
    getCurrentPosition().then((value) {
      city.ampl = value.longitude;
      city.lat = value.latitude;

      print(value.latitude);
      print(value.longitude);
      getCityNameByPosition(value.latitude, value.longitude).then((value) {
        city.cityName = value.locality;
        print(value.locality);
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(
        city: city,
      ),
    );
  }
}
