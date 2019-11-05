import 'package:get_it/get_it.dart';
import 'package:goodvibes/providers.dart/ads_provider.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:goodvibes/services/navigation_service.dart';
import 'package:goodvibes/services/player_service.dart';


GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(()=>NavigationService());
  locator.registerLazySingleton(()=>StartupProvider());
  locator.registerLazySingleton(() => MusicService());
  locator.registerLazySingleton(() => AdsProvider());
}