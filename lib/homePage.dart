import 'dart:convert';
import 'package:jiffy/jiffy.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:wather_app/httpdata.dart';
import 'package:flutter_switch/flutter_switch.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

double? lataitute;
double? longatitute;

class _HomePageState extends State<HomePage> {
  bool stutus = false;
  //todo  golocatro
  late Position position;

  _determinePosition() async {
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

    position = await Geolocator.getCurrentPosition();
    setState(() {
      lataitute = position.altitude;
      longatitute = position.longitude;
    });
    facthData();
    print("lateaititute is $lataitute longatitute is $longatitute");
  }

  Map<String, dynamic>? wattheMap;
  Map<String, dynamic>? forcustMap;

  facthData() async {
    var weatherRespons = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lataitute&lon=$longatitute&exclude=hourly%2Cdaily&appid=0cac39049510ae140169d592847aa4e0"));

    var forcaustRespons = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=$lataitute&lon=$longatitute&units=metric&appid=0cac39049510ae140169d592847aa4e0"));

    print(forcaustRespons.body);
    print(weatherRespons.body);

    setState(() {
      wattheMap = Map<String, dynamic>.from(jsonDecode(weatherRespons.body));
      forcustMap = Map<String, dynamic>.from(jsonDecode(forcaustRespons.body));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Weather App"),
          actions: [
            Icon(Icons.search),
            Container(
              child: FlutterSwitch(
                inactiveText: "F",
                activeText: "C",
                activeColor: Colors.green,
                width: 50.0,
                height: 30.0,
                valueFontSize: 10.0,
                toggleSize: 20,
                value: stutus,
                borderRadius: 12.0,
                showOnOff: true,
                onToggle: (val) {
                  setState(() {
                    stutus = val;
                  });
                },
              ),
            ),
          ],
        ),
        body: forcustMap != null
            ? SafeArea(
                child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${Jiffy("${forcustMap!["list"][0]["dt_txt"]}").format("MMM do yy")},${Jiffy("${forcustMap!["list"][0]["dt_txt"]}").format(" h:mm")}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${wattheMap!["name"] == null ? "Dhaka Bangladesh" : "Dhaka Bangladesh"}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Image.network(
                          "https://freepngimg.com/thumb/categories/2275.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          "${forcustMap!["list"][0]["main"]["temp"]}°",
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "feels like${forcustMap!["list"][0]["main"]["feels_like"]}°",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${forcustMap!["list"][0]["weather"][0]["description"]}°",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            "humidity ${forcustMap!["list"][0]["main"]["humidity"]} pressure ${forcustMap!["list"][0]["main"]["pressure"]}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "sunrise ${Jiffy("${DateTime.fromMillisecondsSinceEpoch(wattheMap!["sys"]["sunrise"] * 1000)}").format("hh mm a")} sunset ${Jiffy("${DateTime.fromMillisecondsSinceEpoch(wattheMap!["sys"]["sunset"] * 1000)}").format("hh mm a")}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: 200,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: forcustMap!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 100,
                                color: Colors.blueGrey,
                                margin: EdgeInsets.only(right: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      "${Jiffy("${forcustMap!["list"][index]["dt_txt"]}").format("EE")}${Jiffy("${forcustMap!["list"][index]["dt_txt"]}").format(" h:mm")} ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                    Image.network(
                                      "https://freepngimg.com/thumb/categories/2275.png",
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                    ),
                                    Text(
                                      "${forcustMap!["list"][index]["main"]["temp_min"]}°/${forcustMap!["list"][index]["main"]["temp_max"]}° ",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "${forcustMap!["list"][index]["weather"][0]["description"]} ",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              );
                            }))
                  ],
                ),
              ))
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
