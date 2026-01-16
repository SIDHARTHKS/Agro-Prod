import 'package:agro/AgroApp.dart';
import 'package:flutter/material.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import 'helper/core/environment/env.dart';
import 'helper/enum.dart';
import 'helper/init/app_init.dart';

void main() async {
  AppEnvironment.setEnv(Environment.PROD);
  AppEnvironment.setClient(AppClient.agro);
  await AppInit().mainInit();
  runApp(const AgroApp());
}
