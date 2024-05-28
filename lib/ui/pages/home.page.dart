// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:tp_7/data/datatest/test.data.dart';
import 'package:tp_7/models/city.wather.dart';
import 'package:tp_7/ui/widgets/card.weather.days.dart';
import 'package:tp_7/ui/widgets/custom.text.input.dart';
import 'package:tp_7/ui/widgets/drawer.item.dart';
import 'package:tp_7/ui/widgets/haeder.card.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.city});
  CityWeather city;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  final TextEditingController controller = TextEditingController();
  Future<CityWeather> fetchCityCordiantesByCityNameFromLoactor(
      CityWeather city) {
    return getPositionBtCityName(city.cityName).then((value) {
      return CityWeather(
        cityName: city.cityName,
        lat: value.latitude,
        ampl: value.longitude,
        weatherStatus: city.weatherStatus,
        minTemp: city.minTemp,
        maxTemp: city.maxTemp,
      );
    });
  }

  List<CityWeather> citiWeatherList = [];

  Future<List<CityWeather>> fetchCityWeatherInfoFromOpenWeather(
      CityWeather city) async {
    Dio dio = Dio();
    final resp = await dio.get(
        "https://api.openweathermap.org/data/2.5/forecast?lat=${widget.city.lat}&lon=${widget.city.ampl}&appid=d5379ad63ac267188c264654f22af0e2");

    // I want to get just weather for the next 6 days
    int day = DateTime.now().day;
    for (var s in resp.data["list"]) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(s['dt'] * 1000);
      print(date.toIso8601String());
      if (day < date.day && citiWeatherList.length < 6) {
        print(s);
        citiWeatherList.add(CityWeather(
          dayName: DateFormat('EEEE').format(date),
          cityName: city.cityName,
          lat: city.lat,
          ampl: city.ampl,
          weatherStatus: s['weather'][0]['main'],
          minTemp: s['main']['temp_min'],
          maxTemp: s['main']['temp_max'],
        ));
        day++;
      }
    }
    return citiWeatherList;
  }

  @override
  void initState() {
    super.initState();
    fetchCityCordiantesByCityNameFromLoactor(widget.city).then((value) {
      fetchCityWeatherInfoFromOpenWeather(value).then((value) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.city.cityName),
          ),
          drawer: _buildDrawer(context),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //! Input Text + button for inserting new city
                        _buildInputTextAndAddIconButton(context),
                        //! Weather info for the city
                        _buildHeaderInfo(),
                        //! Card for generale Info
                        HeaderCard(
                            title: citiWeatherList.isNotEmpty
                                ? citiWeatherList[0].weatherStatus
                                : "Clouds",
                            minTemp: citiWeatherList.isNotEmpty
                                ? citiWeatherList[0].minTemp
                                : 10,
                            maxTemp: citiWeatherList.isNotEmpty
                                ? citiWeatherList[0].maxTemp
                                : 2),
                        //! Card for next 5 days with weather info
                        _buildDaysWeatherForCurrentCity(context),
                      ],
                    ),
                  ),
                )),
    );
  }

  _buildDrawer(context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
              child: Column(
            children: [
              const CircleAvatar(
                child: Icon(Icons.location_on, size: 24),
                radius: 25,
              ),
              const Text(
                "Mes villes",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              Text(
                widget.city.cityName,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          )),
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              child: ListView.builder(
                itemCount: TestData.citiesList.length,
                itemBuilder: (context, index) {
                  return DrawerItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            city: CityWeather(
                                cityName: TestData.citiesList[index],
                                lat: 3,
                                ampl: 3,
                                weatherStatus: "weatherStatus",
                                minTemp: 2,
                                maxTemp: 2),
                          ),
                        ),
                      );
                    },
                    itemName: TestData.citiesList[index],
                    icon: Icons.location_city,
                    onPressed: () {
                      setState(() {
                        TestData.citiesList.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputTextAndAddIconButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: CustomTextInput(
            controller: controller,
          ),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              setState(() {
                TestData.citiesList.add(controller.text);
              });
              controller.clear();
            },
            child: Container(
              margin: const EdgeInsets.only(left: 7),
              height: 56,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 54, 83, 120),
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(50)),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            children: [
              Icon(Icons.wb_sunny, size: 80),
            ],
          ),
          Column(
            children: [
              Text(
                "${citiWeatherList.first.maxTemp.toString()} °C",
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDaysWeatherForCurrentCity(context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .5,
        child: Column(
          children: List.generate(
              citiWeatherList.length,
              (index) => Expanded(
                    child: CardDayItem(
                      day: citiWeatherList[index].dayName,
                      maxTemp: citiWeatherList[index].maxTemp,
                      minTemp: citiWeatherList[index].minTemp,
                      statusIcon: const Icon(Icons.cloud_circle),
                      statusText: citiWeatherList[index].weatherStatus,
                    ),
                  )),
        ),
      ),
    );
  }

  Future<Location> getPositionBtCityName(String city) async {
    List<Location> locations = await locationFromAddress(city);
    return locations.first;
  }
}
