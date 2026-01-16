import '../env_config.dart';

class UatEnvironment extends EnvironmentConfig {
  UatEnvironment()
      : super(
          baseApiurl: 'http://202.164.153.62/TropicalMobAPI2Api', //uat
          title: 'MIS UAT',
          enableLogs: true,
          enableNetworkImages: true,
          version: '1.0.1',
          appUpdateDate: '3rd October 2025 09:00 AM',
          releaseDate: '3rd October 2025',
        );
}
