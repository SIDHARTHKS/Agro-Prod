import '../env_config.dart';

class ProdEnvironment extends EnvironmentConfig {
  ProdEnvironment()
      : super(
          baseApiurl: 'https://202.164.153.62/TropicalMobAPI2Api', //uat
          // baseApiurl: 'http://202.164.153.62:8697/mzmobileapp', //live
          title: 'AgroMIS',
          enableLogs: false,
          enableNetworkImages: true,
          version: '1.0.1',
          appUpdateDate: '20th January 2026 12:00 PM',
          releaseDate: '20th January 2026',
        );
}
