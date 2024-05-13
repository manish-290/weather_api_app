
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_icons/weather_icons.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _locationController;
  String _locationName = '';
  bool isLoading = false;
  String _temperature = '';
  String _weatherDescription = '';
  String _weatherIconUrl = '';
  bool _isLocationSaved = false;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController();
    _getLocationName();
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

//shared preference for data storage and update
  Future<void> _getLocationName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _locationName = prefs.getString('locationName') ?? '';
      _locationController.text = _locationName;
      _isLocationSaved = _locationName.isNotEmpty;
      
    });
    if(_isLocationSaved){
      _getTemperature();
    }
     
   
  }

  Future<void> _saveLocationName(String locationName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('locationName', locationName);
    setState(() {
      _isLocationSaved= true;
    });
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(message)));
  }

  void _handleSaveUpdate() {
    String newLocationName = _locationController.text.trim();
    if (newLocationName.isNotEmpty) {
      _saveLocationName(newLocationName);
       _getTemperature();
    } else {
      _showErrorMessage("Location Name cannot be empty");
    }
  }

  Future<void> _getTemperature() async {
    setState(() {
      isLoading = true;
    });
    String location = _locationController.text.trim();
    String apiKey = "34614eaf89ee4185951102149241305";
     String apiUrl = "http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$location";

    try {
      final res = await http.get(Uri.parse(apiUrl));
       
      if (res.statusCode == 200) {
        Map<String, dynamic> data = json.decode(res.body);
        setState(() {
          _temperature = data['current']['temp_c'].toString();
          _weatherDescription = data['current']['condition']['text'];
          _weatherIconUrl = 'http:' + data['current']['condition']['icon'];
          isLoading = false;
        });
      } else {
        throw Exception("failed to load weather data");
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        _showErrorMessage("Failed to load weather data");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(WeatherIcons.day_sunny, color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 1, 48, 86),
          title: Text("Weather checkout",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter the location:",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: TextField(
                  controller: _locationController,
                  onChanged: (value){
                    setState(() {
                      _isLocationSaved = false;
                    });
                  },
                  decoration: InputDecoration(
                      label: Text("Location"),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)))),
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 0, 48, 88)),
                onPressed: _handleSaveUpdate,
                child: Text(_isLocationSaved ? "Update" : "Save",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500))),
            SizedBox(
              height: 16,
            ),
            _isLocationSaved?
              isLoading
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      Text('Temperature: $_temperature°C',
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      Text('Weather: $_weatherDescription',
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      SizedBox(
                        height: 8,
                      ),
                        Image.network(
                         _weatherIconUrl,
                          width: 60,
                          height: 60,
                      )
                    ],
                  )
                  :Text("Please enter the location")
          ],
        ));
  }
}
