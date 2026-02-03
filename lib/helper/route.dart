import 'package:agro/binding/bill_summary_binding.dart';
import 'package:agro/view/splash/splash_screen.dart';
import 'package:get/get.dart';
import '../binding/home_binding.dart';
import '../binding/login_binding.dart';
import '../binding/splash_binding.dart';
import '../view/home/home_screen.dart';
import '../view/login/login_screen.dart';
import '../view/home/bills_summary/bill_summary_view.dart';

const loginPageRoute = '/login';
const splashPageRoute = '/splash';
const homePageRoute = '/home';
const billSummaryRoute = '/home/bills_summary';

final routes = [
  GetPage(
      name: splashPageRoute,
      page: () => const SplashScreen(),
      binding: const SplashBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 350)),
  // GetPage(

  GetPage(
      name: loginPageRoute,
      page: () => LoginScreen(),
      binding: const LoginBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100)),
  GetPage(
      name: homePageRoute,
      page: () => const HomeScreen(),
      binding: const HomeBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 250)),

  GetPage(
      name: billSummaryRoute,
      page: () => const BillSummaryView(),
      binding: const BillSummaryBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 250)),
];
