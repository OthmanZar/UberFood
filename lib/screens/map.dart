import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:projetc2/models/order.dart';

import 'package:projetc2/widgets/cart_grid.dart';

import '../models/orderFinal.dart';
import '../widgets/action_button.dart';
import 'restaurant_detail_screen.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/HomePage";

  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  LatLng? _selectedLocation;

  void _navigateToMapPage() async {
    final selectedLocation = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );

    if (selectedLocation != null) {
      setState(() {
        _selectedLocation = selectedLocation;
      });
    }
  }

  Future<void> _saveData() async {
    final name = _nameController.text;
    final address = _addressController.text;
    final latitude = _selectedLocation?.latitude;
    final longitude = _selectedLocation?.longitude;

    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez choisir un emplacement'),
        ),
      );
      return;
    }

    // Do something with the client data (e.g., save it to a database)

    RestaurantDetailScreen.order.lat = latitude!;
    RestaurantDetailScreen.order.lang = longitude!;

    final order = OrderFinal(
      email: RestaurantDetailScreen.order.email,
      items: RestaurantDetailScreen.order.objects,
      restaurentCity: RestaurantDetailScreen.order.restcity,
      latitude: latitude,
      longitude: longitude,
      price: RestaurantDetailScreen.order.price,
    );
    final url =
        'http://192.168.0.165:8800/add/order'; // Replace with your API endpoint
    final body = jsonEncode(order.toJson());
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      //  final City? citySel = ModalRoute.of(context)!.settings.arguments as City?;
      //  Navigator.of(context).pushNamedAndRemoveUntil(
      //  OverViewScreenScreen.routeName,
      //(Route<dynamic> route) => false,
      //arguments: citySel,
      //);

      setState(() {
        RestaurantDetailScreen.order = OrderModel();

        CartGrid.cart = Map();
        Navigator.pop(context);
      });
    } else {
      // Handle error response
      print('Failed to add user. Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vos informations'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nom Complet'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Numero de Telephone'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address Exact'),
              ),
            ),
            ElevatedButton(
              onPressed: _navigateToMapPage,
              child: Text("Choisissez l'emplacement"),
            ),
            Padding(
              padding: const EdgeInsets.all(27.0),
              child: Text(
                _selectedLocation != null
                    ? 'Sélection effectuée'
                    : 'Aucun emplacement sélectionné',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: ActionButton(
                onTap: _saveData,
                text: ('Commander'),
                height: 40,
                width: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _currentLocation;
  LatLng? _selectedLocation;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    print('Location permission: $permission');

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    print('Current position: $position');

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  void _onMapCreated(GoogleMapController controller) {}

  void _onMapTap(LatLng point) {
    setState(() {
      _selectedLocation = point;
      _markers = Set<Marker>.from([
        Marker(
          markerId: MarkerId('selectedLocation'),
          position: point,
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Localisation'),
      ),
      body: Stack(
        children: [
          if (_currentLocation != null)
            GoogleMap(
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              onTap: _onMapTap,
              initialCameraPosition: CameraPosition(
                target: _currentLocation!,
                zoom: 15.0,
              ),
              markers: _markers,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _selectedLocation);
        },
        child: Icon(Icons.check),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.startFloat, // Align FAB to the left
    );
  }
}
