import 'package:agro/helper/app_string.dart';
import 'package:agro/helper/sizer.dart';
import 'package:agro/view/home/homeView/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_controller.dart';
import '../../helper/color_helper.dart';
import '../../helper/core/base/app_base_view.dart';
import '../widget/common_widget.dart';
import 'delayed_payments/delayed_payments_view.dart';

class HomeScreen extends AppBaseView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget buildView() {
    return Obx(() {
      return appScaffold(
          canpop: true,
          extendBodyBehindAppBar: true,
          topSafe: false,
          appBar: customHomeAppBar(
            "User",
            onTap: () {
              if (controller.rxCurrentNavBarIndex.value > 0) {
                controller.rxCurrentNavBarIndex.value--;
              }
            },
          ),
          body: _buildBody(),
          bottomNavigationBar: _bottomNavBr());
    });
  }

  Obx _bottomNavBr() {
    return Obx(() {
      return Container(
        color: AppColorHelper().cardColor,
        child: SafeArea(
          child: Container(
              height: 52,
              color: AppColorHelper().cardColor,
              child: Row(
                children:
                    controller.bottomNavBarItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  bool isSelected =
                      index == controller.rxCurrentNavBarIndex.value;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          controller.rxCurrentNavBarIndex.value = index,
                      child: _navBarItem(item, index, isSelected),
                    ),
                  );
                }).toList(),
              )),
        ),
      );
    });
  }

  GestureDetector _navBarItem(item, index, selected) {
    return GestureDetector(
      onTap: () {
        controller.rxCurrentNavBarIndex(index);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        height: 65,
        width: 65,
        color: AppColorHelper().cardColor,
        child: Image.asset(
          item,
          scale: 3,
          color: selected ? AppColorHelper().iconColor : null,
        ),
      ),
    );
  }

  Widget _transitBody() {
    return appContainer(
      child: Center(child: appText("Transit Screen")),
    );
  }

  Widget _settingsBody() {
    return appContainer(
      child: Column(
        children: [
          appText("Settings Screen", color: AppColorHelper().primaryTextColor),
          height(50),
          buttonContainer(
            height: 50,
            color: AppColorHelper().primaryColor,
            appText(
              logOut.tr,
              fontSize: 15,
              color: AppColorHelper().textColor,
              fontWeight: FontWeight.w500,
            ),
            onPressed: () async {
              controller.logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      switch (controller.rxCurrentNavBarIndex.value) {
        case 0:
          return HomeView();
        case 1:
          return const DelayedPaymentsView();

        case 2:
          return _transitBody();
        case 3:
          return _settingsBody();
        default:
          return HomeView();
      }
    });
  }
}
