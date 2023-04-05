import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marvel_app/presentation/viewmodel/map_character/map_character_viewmodel.dart';
import 'package:provider/provider.dart';

class MapCharacterScreen extends StatelessWidget {
  const MapCharacterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MapCharacterViewModel viewModel =
        Provider.of<MapCharacterViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Position des personnages'),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        markers: viewModel.markers,
        initialCameraPosition:
            CameraPosition(target: viewModel.initialCameraPosition),
        onMapCreated: viewModel.onMapCreated,
        onCameraMove: viewModel.onCameraMove,
        onCameraIdle: viewModel.onCameraIdle,
      ),
    );
  }
}
