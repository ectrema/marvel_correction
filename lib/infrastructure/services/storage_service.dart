import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:marvel_app/data/model/character.dart';
import 'package:marvel_app/data/model/place.dart';
import 'package:marvel_app/infrastructure/services/map_service.dart';

@singleton
class StorageService {
  final MapService _mapService;
  final Box<String> _favoriteBox;
  final Box<Uint8List> _favoriteImageBox;
  final Box<StoragePlace> _favoriteCharacterPosition;

  StorageService(
    this._favoriteBox,
    this._favoriteImageBox,
    this._favoriteCharacterPosition,
    this._mapService,
  );

  @factoryMethod
  static Future<StorageService> inject(MapService mapService) async {
    await Hive.initFlutter();

    Hive.registerAdapter(StoragePlaceAdapter());

    final charactersBox = await Hive.openBox<String>('FavoriteCharacter');
    final imageBox = await Hive.openBox<Uint8List>('FavoriteCharacterImage');
    final position =
        await Hive.openBox<StoragePlace>('FavoriteCharacterPosition');

    return StorageService(charactersBox, imageBox, position, mapService);
  }

  ValueListenable<Box<String>> get characterListener =>
      _favoriteBox.listenable();

  ValueListenable<Box<Uint8List>> get characterImageListener =>
      _favoriteImageBox.listenable();

  bool containCharacter(String key) {
    return _favoriteBox.containsKey(key);
  }

  Future<void> putCharacter(Character character) async {
    _favoriteBox.put(character.id.toString(), jsonEncode(character.toJson()));
    if (character.thumb != null) {
      final result = (await NetworkAssetBundle(Uri.parse(character.thumb!))
              .load(character.thumb!))
          .buffer
          .asUint8List();
      _favoriteImageBox.put(character.id.toString(), result);
      _favoriteCharacterPosition.put(character.id.toString(),
          StoragePlace(_mapService.randomLat, _mapService.randomLng));
    }
  }

  Future<void> removeCharacter(Character character) async {
    _favoriteBox.delete(character.id.toString());
    _favoriteImageBox.delete(character.id.toString());
    _favoriteCharacterPosition.delete(character.id.toString());
  }

  List<Character> getFavoriteCharacters() {
    return _favoriteBox.values.map((e) {
      return Character.fromJson(jsonDecode(e));
    }).toList();
  }

  List<Place> getFavoriteCharactersPlace() {
    return _favoriteCharacterPosition.values
        .map((e) => Place(LatLng(e.lat, e.lng)))
        .toList();
  }
}
