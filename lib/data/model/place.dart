import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'place.g.dart';

@HiveType(typeId: 0)
class StoragePlace {
  @HiveField(0)
  final double lat;
  @HiveField(1)
  final double lng;

  StoragePlace(this.lat, this.lng);
}

class Place with ClusterItem {
  final LatLng latLng;

  Place(this.latLng);
  @override
  LatLng get location => latLng;
}
