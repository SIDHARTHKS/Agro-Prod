import '../helper/core/base/app_base_service.dart';
import '../model/bill_summary_model.dart';
import '../helper/app_message.dart';
import '../helper/enum.dart';
import '../helper/app_string.dart';
import '../model/app_model.dart';

class BillSummaryService extends AppBaseService {
  /// Fetch delayed payments (Pending + Settled + Location summary)
  /// [companyCode], [branchCode], [SyCode], [LocationID], [InvoiceID] are required by the API
  Future<BillSummaryModel?> fetchDelayedPayBillSummary(
      BillSummaryRequest request) async {
    try {
      // Get token from stored login
      final token = myApplication.preferenceHelper!.getString(accessTokenKey);

      // Call API
      final response = await httpService.postService<BillSummaryModel>(
        endpoint: getDelayedPayBillSummaryApiEndpoint(token: token),
        headers: await getHeaders(), // only content-type needed
        data: CommonRequest<BillSummaryRequest>(
          request: request,
          pageMode: 0,
          requestBase: RequestBase(
            clientTag: "abc123",
            transId: "sample string 2",
            requestId: "sample string 4",
          ),
        ).toJson((r) => (r).toJson()),
        fromJsonT: (json) => BillSummaryModel.fromJson(json),
        ignoreError: false,
      );

      if (response != null && response.data != null) {
        return response.data;
      }

      return null;
    } catch (e) {
      appLog(
        'BillSummary API failed: $e',
        logging: Logging.error,
      );
      return null;
    }
  }
}
