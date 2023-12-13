import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:location/location.dart';

import '../utils/location_util.dart';

class LocationInput extends StatefulWidget {
  final void Function(LatLng) onSelectPosition;

  const LocationInput({
    super.key,
    required this.onSelectPosition,
  });

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageurl;

  Future<void> _getCurrentUserLocation() async {
    var location = await Location().getLocation();
    _showPreview(location.latitude!, location.longitude!);
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(),
        fullscreenDialog: true,
      ),
    );
    if (selectedLocation == null) return;

    _showPreview(selectedLocation.latitude!, selectedLocation.longitude!);

    widget.onSelectPosition(selectedLocation);
  }

  void _showPreview(double lat, double lng) {
    final previewImageurl = LocationUtil.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() => _previewImageurl = previewImageurl);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageurl == null
              ? const Text('Localização não informada!')
              : Image.network(
                  _previewImageurl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Localização atual'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Selecione no Mapa'),
            )
          ],
        )
      ],
    );
  }
}
