import '../env_config.dart';

class ProdEnvironment extends EnvironmentConfig {
  ProdEnvironment()
      : super(
          baseApiurl: 'http://202.164.153.62/TropicalMobAPI2Api', //uat
          // baseApiurl: 'http://202.164.153.62:8697/mzmobileapp', //live
          title: 'AgroMIS',
          enableLogs: false,
          enableNetworkImages: true,
          version: '1.0.1',
          appUpdateDate: '12rd Dec 2025 2:00 PM',
          releaseDate: '12rd Dec 2025',
        );
}
