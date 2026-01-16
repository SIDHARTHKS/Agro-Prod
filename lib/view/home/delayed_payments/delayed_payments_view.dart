import 'package:agro/controller/delayed_payment_controller.dart';
import 'package:agro/gen/assets.gen.dart';
import 'package:agro/helper/core/base/app_base_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helper/color_helper.dart';
import 'package:agro/helper/sizer.dart';
import '../../widget/common_widget.dart';
import 'delayed_payments_pending_view.dart';
import 'delayed_payments_settled_view.dart';

class DelayedPaymentsView extends AppBaseView<DelayedPaymentController> {
  const DelayedPaymentsView({super.key});

  @override
  Widget buildView() => _buildScaffold();

  Scaffold _buildScaffold() => appScaffoldImg(
        backgroundImage: AssetImage(Assets.images.loginBg.path),
        canpop: true,
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: true,
        topSafe: true,
        body: _buildBody(),
      );

  Widget _buildBody() {
    return Column(
      children: [
        height(16),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 80,
          ),
          child: Obx(() => _tabSwitch()),
        ),
        height(10),
        Expanded(
          child: Obx(() {
            return IndexedStack(
              index: controller.isPending.value ? 0 : 1,
              children: const [
                DelayedPaymentsPendingView(),
                DelayedPaymentsSettledView(),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _tabSwitch() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          color: AppColorHelper().dividerColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            _tabItem(
              "Pending Bills",
              controller.isPending.value,
              controller.showPending,
            ),
            _tabItem(
              "Settled Bills",
              !controller.isPending.value,
              controller.showSettled,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(String title, bool selected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:
                selected ? AppColorHelper().primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: appText(
            title,
            color: selected
                ? Colors.white
                : AppColorHelper().primaryTextColor.withAlpha(128),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
