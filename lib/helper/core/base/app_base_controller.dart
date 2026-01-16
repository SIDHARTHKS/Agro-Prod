import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:getx_base_classes/getx_base_classes.dart';
import '../../../view/widget/dialog/http_error_list_dialog.dart';
import '../../single_app.dart';
import '../../util.dart';
import 'app_base_response.dart';

class AppBaseController extends BaseController {
  final MyApplication myApp = Get.find<MyApplication>();

  var debouncer = Debouncer(delay: const Duration(milliseconds: 200));

  final rxDataChange = true.obs;
  var rxDefaultBaseViewObx = false.obs;
  RxBool isDarkTheme = false.obs;

  dynamic handleBaseResponse(AppBaseResponse? response) {
    if (response != null) {
      if (response.success ?? false) {
        return response.data;
      }
    }
    return null;
  }

  // RxBool isError = false.obs;

  bool isListNullOrEmpty(List<dynamic>? list) => list == null || list.isEmpty;

  bool isStringNullOrEmpty(String? value) => Util.isStringNullOrEmpty(value);

  void hideKeyboard() => FocusScope.of(Get.context!).requestFocus(FocusNode());

  void showErroListDialog(List<ResponseError> errors) => showDialog(
        context: Get.context!,
        builder: (context) => HttpErrorListDialog(
          errors: errors,
        ),
      );

  Future<void> delay({int milliseconds = 200}) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  bool isPortaritMode() => Get.context!.orientation == Orientation.portrait;
}
