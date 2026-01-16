import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/login_controller.dart';
import '../../gen/assets.gen.dart';
import '../../helper/app_string.dart';
import '../../helper/core/base/app_base_view.dart';
import '../../service/auth_service.dart';
import '../widget/common_widget.dart';

class CreatePasswordScreen extends AppBaseView<LoginController> {
  final AuthService _authService = Get.find<AuthService>();
  CreatePasswordScreen({super.key});

  @override
  Widget buildView() => _widgetView();

  Widget _widgetView() {
    return Scaffold(
      backgroundColor: Colors.transparent, // prevent white background
      extendBodyBehindAppBar: true, // allows full background image
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: appBar(titleText: "CREATE NEW PASSWORD"),
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.images.loginBg2.path),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<void>(
          future: _initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // transparent loader prevents white flash
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.transparent,
                ),
              );
            }
            return _buildBody();
          },
        ),
      ),
    );
  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(milliseconds: 180));
    // await controller.callChangePassword();
  }

  Widget _buildBody() {
    // your actual content here
    return const Center(
      child: Text(
        "Create Password Content Here",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
