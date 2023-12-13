import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/widgets/image_input.dart';
import 'package:great_places/widgets/location_input.dart';
import 'package:provider/provider.dart';

class PlaceFormScreen extends StatefulWidget {
  const PlaceFormScreen({super.key});

  @override
  State<PlaceFormScreen> createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {
  final _titleController = TextEditingController();
  File? _pickedImage;
  LatLng? _pickedPosition;

  void _selectImage(File pickedImage) =>
      setState(() => _pickedImage = pickedImage);

  void _selectPosition(LatLng position) =>
      setState(() => _pickedPosition = position);

  bool isValidForm() =>
      _titleController.text.isNotEmpty &&
      _pickedImage != null &&
      _pickedPosition != null;

  void _submitForm() {
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _pickedPosition == null) return;
    Provider.of<GreatPlaces>(
      context,
      listen: false,
    ).addPlace(_titleController.text, _pickedImage!, _pickedPosition!);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Lugar'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ImageInput(onSelectImage: _selectImage),
                    const SizedBox(height: 10),
                    LocationInput(onSelectPosition: _selectPosition),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: isValidForm() ? _submitForm : null,
            icon: const Icon(Icons.add),
            label:
                const Text('Adicionar', style: TextStyle(color: Colors.black)),
            style: ButtonStyle(
              shape: const MaterialStatePropertyAll(BeveledRectangleBorder()),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor:
                  MaterialStatePropertyAll(Theme.of(context).accentColor),
              iconColor: const MaterialStatePropertyAll(Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
