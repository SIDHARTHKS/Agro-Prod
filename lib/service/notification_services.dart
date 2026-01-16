import '../helper/core/base/app_base_service.dart';

class NotificationServices extends AppBaseService {
  // Future<List<NotificationModel>?> getNotifications(
  //     List<CommonRequest> request) async {
  //   var response = await httpService.postService<List<NotificationModel>>(
  //       endpoint: getTasksApiEndpoint(),
  //       headers: await getHeaders(
  //         authorization: true,
  //         xCorrelationId: false,
  //         sid: false,
  //       ),
  //       data: request,
  //       fromJsonT: (json) => List<NotificationModel>.from(
  //             json.map((x) => NotificationModel.fromJson(x)),
  //           ),
  //       ignoreError: false);
  //   if (response != null && response.data != null) {
  //     return response.data;
  //   } else {
  //     return null;
  //   }
  // }
}
