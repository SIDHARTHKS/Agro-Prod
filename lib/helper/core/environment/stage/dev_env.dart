import '../env_config.dart';

class DevEnvironment extends EnvironmentConfig {
  DevEnvironment()
      : super(
          baseApiurl: 'http://202.164.153.62/TropicalMobAPI2Api', //uat
          title: 'AGROMIS Dev',
          enableLogs: true,
          enableNetworkImages: true,
          version: '1.0.1',
          appUpdateDate: '06th January 2026 12:00 PM',
          releaseDate: '06th January 2026',
        );
}
