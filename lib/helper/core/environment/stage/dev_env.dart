import '../env_config.dart';

class DevEnvironment extends EnvironmentConfig {
  DevEnvironment()
      : super(
          baseApiurl: 'https://retailis.in/TropicalMobAPI2Api', //uat
          title: 'AGROMIS Dev',
          enableLogs: true,
          enableNetworkImages: true,
          version: '1.0.1',
          appUpdateDate: '20th January 2026 12:00 PM',
          releaseDate: '20th January 2026',
        );
}
