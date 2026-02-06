import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import '../controller/home_view_controller.dart';

class HomeViewBinding extends BaseBinding {
  const HomeViewBinding();
  @override
  void injectDependencies() {
    Get.lazyPut<HomeViewController>(() => HomeViewController(), fenix: true);
  }
}
