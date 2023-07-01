import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projetc2/screens/overview_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../models/cities.dart';

class CitySelectionScreen extends StatefulWidget {
  const CitySelectionScreen({Key? key}) : super(key: key);
  static const routeName = "/CitySelectionScreen";

  @override
  _CitySelectionScreenState createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  City selectedCity = City(0, '');
  List<City> cities = [];

  @override
  void initState() {
    super.initState();
    fetchCities();
  }

  Future<void> fetchCities() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.0.165:8800/cities'));
      final jsonData = json.decode(response.body) as List<dynamic>;

      setState(() {
        cities = jsonData.map((cityData) {
          return City(cityData['id'], cityData['name']);
        }).toList();
      });
    } catch (error) {
      print('Error fetching cities: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dans quelle ville habitez-vous ?'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 60.h,
              child: ClipRRect(
                child: Image.asset("assets/images/food_illistration.jpg"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Ville sélectionnée:',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          selectedCity.city,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        showCitySelectionDialog(context);
                      },
                      child: Text('Choisissez la ville'),
                    ),
                    SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () {
                        if (selectedCity.id == 0) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content:
                                    Text('Veuillez sélectionner une ville.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("D'ACCORD"),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Navigator.of(context).pushReplacementNamed(
                            OverViewScreenScreen.routeName,
                            arguments: selectedCity,
                          );
                        }
                      },
                      child: Text('Confirmer & Suivant'),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCitySelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a City'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: cities.map((city) {
              return ListTile(
                title: Text(city.city),
                onTap: () {
                  selectCity(city);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void selectCity(City city) {
    setState(() {
      selectedCity = city;
    });
  }
}
