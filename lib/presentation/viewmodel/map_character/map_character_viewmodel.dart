import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marvel_app/data/model/place.dart';
import 'package:marvel_app/infrastructure/services/map_service.dart';
import 'package:marvel_app/infrastructure/services/storage_service.dart';

class MapCharacterViewModel extends ChangeNotifier {
  final StorageService _storageService;

  MapCharacterViewModel({
    required StorageService storageService,
  }) : _storageService = storageService;

  ValueListenable<Box<dynamic>> get characterListenable =>
      _storageService.characterListener;

  GoogleMapController? _controller;

  ClusterManager? _clusterManager;

  final Set<Place> _places = <Place>{};

  LatLng get initialCameraPosition => MapService.parisLatLng;

  final Set<Marker> markers = <Marker>{};

  void init() {
    final List<Place> positions = _storageService.getFavoriteCharactersPlace();
    _places
      ..clear()
      ..addAll(positions);
  }

  void onMapCreated(GoogleMapController controller) {
    _controller = controller;
    init();
    _clusterManager = ClusterManager<Place>(_places, _updateMarkers,
        markerBuilder: markerBuilder,
        levels: [
          1,
          4.25,
          8.25,
          11.5,
          14.5,
          16.0,
          20.0,
        ],
        extraPercent: 0.2,
        stopClusteringZoom: 17.0);
    _clusterManager?.setMapId(_controller!.mapId);
  }

  void _updateMarkers(Set<Marker> value) {
    markers
      ..clear()
      ..addAll(value);
    notifyListeners();
  }

  void onCameraMove(CameraPosition cameraPosition) {
    _clusterManager?.onCameraMove(cameraPosition);
  }

  void onCameraIdle() {
    _clusterManager?.updateMap();
  }

  static Future<Marker> Function(Cluster) get markerBuilder => (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            print(cluster.items);
          },
          icon: await getClusterBitmap(cluster.isMultiple ? 125 : 75,
              text: cluster.isMultiple ? cluster.count.toString() : ''),
        );
      };

  static Future<BitmapDescriptor> getClusterBitmap(int size,
      {String? text}) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = Colors.red;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }
}
