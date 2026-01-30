import 'package:agro/controller/delayed_pay_filter_controller.dart';
import 'package:agro/gen/assets.gen.dart';
import 'package:agro/helper/core/base/app_base_view.dart';
import 'package:flutter/material.dart';
import '../../../widget/common_widget.dart';

class DelayedPayFilterView extends AppBaseView<DelayedPayFilterController> {
  const DelayedPayFilterView({super.key});

  @override
  Widget buildView() => _buildScaffold();

  Scaffold _buildScaffold() => appScaffoldImg(
        backgroundImage: AssetImage(Assets.images.loginBg.path),
        canpop: true,
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: false, // IMPORTANT
        topSafe: true,
        body: _buildBody(),
      );

  Widget _buildBody() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: const Center(
        child: Text(
          "Filter UI goes here",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
