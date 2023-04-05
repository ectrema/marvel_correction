import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

@singleton
class MapService {
  MapService();

  static const LatLng parisLatLng = LatLng(48.866667, 2.333333);

  double get randomLat => -90 + Random().nextDouble() * 90 * 2;
  double get randomLng => -180 + Random().nextDouble() * 180 * 2;
}
