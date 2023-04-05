import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injector.config.dart';

///
/// [GetIt] instance
///
final GetIt injector = GetIt.instance;

///
/// Setup injector
///
@InjectableInit()
GetIt initializeInjections() => injector.init();
