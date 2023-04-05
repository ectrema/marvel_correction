import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marvel_app/data/endpoint/characters_endpoint.dart';
import 'package:marvel_app/data/model/character.dart';
import 'package:marvel_app/data/model/comic.dart';
import 'package:marvel_app/infrastructure/injections/injector.dart';
import 'package:marvel_app/infrastructure/services/storage_service.dart';
import 'package:provider/provider.dart';

class DetailsViewModel extends ChangeNotifier {
  final CharacterEndpoint _characterEndpoint;
  final StorageService _storageServive;
  final Character selectedCharacter;

  DetailsViewModel._({
    required CharacterEndpoint characterEndpoint,
    required StorageService storageServive,
    required this.selectedCharacter,
  })  : _characterEndpoint = characterEndpoint,
        _storageServive = storageServive;

  static ChangeNotifierProvider<DetailsViewModel> buildWithProvider({
    required Widget Function(BuildContext context, Widget? child)? builder,
    Widget? child,
    required Character selectedCharacter,
  }) {
    return ChangeNotifierProvider<DetailsViewModel>(
      create: (BuildContext context) => DetailsViewModel._(
        characterEndpoint: injector<CharacterEndpoint>(),
        storageServive: injector<StorageService>(),
        selectedCharacter: selectedCharacter,
      )..load(),
      builder: builder,
      lazy: false,
      child: child,
    );
  }

  ValueListenable<Box<dynamic>> get characterListenable =>
      _storageServive.characterListener;

  ValueListenable<Box<Uint8List>> get imageListenable =>
      _storageServive.characterImageListener;

  List<Comic> comics = <Comic>[];

  bool loading = true;

  Future<void> load() async {
    try {
      if (selectedCharacter.id != null) {
        final response = await _characterEndpoint
            .getCharactersDetails(selectedCharacter.id!);
        comics.addAll((response.data.results as List)
            .map((e) => Comic.fromJson(e))
            .toList());
      }
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> handleFavPressed() async {
    if (_storageServive.containCharacter(selectedCharacter.id.toString())) {
      _storageServive.removeCharacter(selectedCharacter);
    } else {
      _storageServive.putCharacter(selectedCharacter);
    }
  }
}
