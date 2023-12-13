import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isReadonly;

  const MapScreen({
    super.key,
    this.initialLocation = const PlaceLocation(
      latitude: 37.419857,
      longitude: -122.078827,
    ),
    this.isReadonly = false,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedPostion;

  void _selectPostion(LatLng position) {
    setState(() => _pickedPostion = position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione...'),
        actions: [
          if (!widget.isReadonly)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => _pickedPostion == null
                  ? null
                  : Navigator.of(context).pop(_pickedPostion),
            )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 13,
        ),
        onTap: widget.isReadonly ? null : _selectPostion,
        markers: (_pickedPostion == null && !widget.isReadonly)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('p1'),
                  position: _pickedPostion ?? widget.initialLocation.toLatLng(),
                )
              },
      ),
    );
  }
}
