import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:marvel_app/data/endpoint/characters_endpoint.dart';
import 'package:marvel_app/infrastructure/services/connectivity_service.dart';
import 'package:marvel_app/infrastructure/services/storage_service.dart';
import 'package:marvel_app/presentation/screen/home_screen.dart';
import 'package:marvel_app/presentation/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';

import 'infrastructure/injections/injector.dart';
import 'presentation/screen/map_character/map_character_screen.dart';
import 'presentation/viewmodel/map_character/map_character_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final GetIt getIt = initializeInjections();
  await getIt.allReady();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marvel app',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(
            injector<ConnectivityServive>(),
            characterEndpoint: injector<CharacterEndpoint>(),
            storageServive: injector<StorageService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => MapCharacterViewModel(
            storageService: injector<StorageService>(),
          ),
          lazy: false,
        ),
      ],
      child: Scaffold(
        body: currentScreenIndex == 0
            ? const HomeScreen()
            : const MapCharacterScreen(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentScreenIndex,
          onTap: (value) => setState(() {
            currentScreenIndex = value;
          }),
          items: [
            BottomNavigationBarItem(
                label: '',
                icon: Icon((currentScreenIndex == 0)
                    ? Icons.home
                    : Icons.home_outlined),
                backgroundColor: Colors
                    .indigo // provide color to any one icon as it will overwrite the whole bottombar's color ( if provided any )
                ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                  (currentScreenIndex == 1) ? Icons.map : Icons.map_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
