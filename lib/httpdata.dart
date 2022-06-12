import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wather_app/homePage.dart';

Map<String, dynamic>? wattheMap;
Map<String, dynamic>? forcustMap;

facthData() async {
  var weatherRespons = await http.get(Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?lat=$lataitute&lon=$longatitute&exclude=hourly%2Cdaily&appid=cc93193086a048993d938d8583ede38a&fbclid=IwAR0tvYJ7vTYYRMuGJXxUpQ2HZFMHqS0256KucjW8G1CkGlufjYRCFSv0UHk"));

  var forcaustRespons = await http.get(Uri.parse(
      "https://api.openweathermap.org/data/2.5/forecast?lat=$lataitute&lon=$longatitute&units=metric&appid=cc93193086a048993d938d8583ede38a&fbclid=IwAR13whb-ohApYd8bYh1CO3CtOGbJZ4vCC6_ngYRHCYAjgRytTJtH28AHfC8"));

  print(forcaustRespons.body);
  print(weatherRespons.body);

  wattheMap = Map<String, dynamic>.from(jsonDecode(weatherRespons.body));
  forcustMap = Map<String, dynamic>.from(jsonDecode(forcaustRespons.body));
}
