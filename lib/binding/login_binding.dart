import 'package:get/get.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import '../controller/login_controller.dart';
import '../service/auth_service.dart';

class LoginBinding extends BaseBinding {
  const LoginBinding();

  @override
  void injectDependencies() {
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
  }
}
