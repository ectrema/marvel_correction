import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:marvel_app/data/dto/response_dto.dart';
import 'package:marvel_app/data/endpoint/characters_endpoint.dart';
import 'package:marvel_app/data/model/character.dart';
import 'package:marvel_app/infrastructure/services/connectivity_service.dart';
import 'package:marvel_app/infrastructure/services/storage_service.dart';

class HomeViewModel extends ChangeNotifier {
  final CharacterEndpoint _characterEndpoint;
  final ConnectivityServive _connectivityServive;
  final StorageService _storageServive;

  HomeViewModel(
    this._connectivityServive, {
    required CharacterEndpoint characterEndpoint,
    required StorageService storageServive,
  })  : _characterEndpoint = characterEndpoint,
        _storageServive = storageServive {
    load();
    initScroll();
  }

  ValueListenable<Box<Uint8List>> get imageListenable =>
      _storageServive.characterImageListener;

  List<Character> characters = <Character>[];

  ResultsDto? paginate;

  bool loading = true;

  final ScrollController scrollController = ScrollController();

  void initScroll() {
    scrollController.addListener(() {
      if (scrollController.offset >=
          (scrollController.position.maxScrollExtent * 0.9)) {
        loadMore();
      }
    });
  }

  Future<void> load() async {
    try {
      if (!_connectivityServive.isConnected) {
        characters.addAll(_storageServive.getFavoriteCharacters());
      } else {
        final response = await _characterEndpoint.getCharacters(
            paginate?.offset == null ? 0 : paginate!.offset! + 20);
        paginate = response.data;
        characters.addAll((paginate?.results as List)
            .map((e) => Character.fromJson(e))
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

  Future<void> loadMore() async {
    if (!loading) {
      loading = true;
      notifyListeners();
      await load();
    }
  }
}
