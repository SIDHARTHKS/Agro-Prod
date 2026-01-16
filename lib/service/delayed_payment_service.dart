import '../helper/core/base/app_base_service.dart';
import '../model/delayed_payments_model.dart';
import '../helper/app_message.dart';
import '../helper/enum.dart';
import '../helper/app_string.dart';
import '../model/app_model.dart';

class DelayedPaymentService extends AppBaseService {
  /// Fetch delayed payments (Pending + Settled + Location summary)
  /// [companyCode], [branchCode], [repToDate] are required by the API
  Future<DelayedPaymentsModel?> fetchDelayedPayments(
      DelayedPaymentsRequest request) async {
    try {
      // Get token from stored login
      final token = myApplication.preferenceHelper!.getString(accessTokenKey);

      // Call API
      final response = await httpService.postService<DelayedPaymentsModel>(
        endpoint: getDelayedPaymentsApiEndpoint(token: token),
        headers: await getHeaders(), // only content-type needed
        data: CommonRequest<DelayedPaymentsRequest>(
          request: request,
          pageMode: 0,
          requestBase: RequestBase(
            clientTag: "abc123",
            transId: "sample string 2",
            requestId: "sample string 4",
          ),
        ).toJson((r) => (r).toJson()),
        fromJsonT: (json) => DelayedPaymentsModel.fromJson(json),
        ignoreError: false,
      );

      if (response != null && response.data != null) {
        return response.data;
      }

      return null;
    } catch (e) {
      appLog(
        'DelayedPayments API failed: $e',
        logging: Logging.error,
      );
      return null;
    }
  }
}
