import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class LocationPickerScreen extends StatefulWidget {
  final Function(String address, double lat, double lng) onPicked;
  const LocationPickerScreen({super.key, required this.onPicked});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng _selectedLocation = const LatLng(30.0444, 31.2357);
  String _address = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick Location')),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _selectedLocation,
                initialZoom: 14,
                onTap: (tapPos, point) async {
                  setState(() => _selectedLocation = point);
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                      point.latitude, point.longitude);
                  if (placemarks.isNotEmpty) {
                    final p = placemarks.first;
                    _address =
                        '${p.street}, ${p.locality}, ${p.administrativeArea}';
                  }
                  setState(() {});
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_pin,
                          color: Colors.red, size: 40),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(_address.isEmpty
                    ? 'Tap on map to select location'
                    : _address),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    widget.onPicked(_address, _selectedLocation.latitude,
                        _selectedLocation.longitude);
                    Navigator.pop(context);
                  },
                  child: const Text('Use this location'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
