import '../helper/app_message.dart';
import '../helper/app_string.dart';
import '../helper/core/base/app_base_service.dart';
import '../helper/enum.dart';
import '../model/app_model.dart';
import '../model/login_model.dart';

class AuthService extends AppBaseService {
  // Future<AppBaseResponse?>? fetchSupportedVersion() async =>
  //     await httpService.getService(
  //       endpoint: getSupportedVersionApiEndpoint(),
  //       headers: await getHeaders(authorization: false),
  //       fromJsonT: (json) => DeviceSupportModel.fromJson(json),
  //     );

  // Future<LoginResponse?> login(LoginRequest request) async {
  //   try {
  //     final commonRequest = CommonRequest<LoginRequest>(request: request);

  //     final response = await httpService.postService<LoginResponse>(
  //       endpoint: getLoginApiEndpoint(),
  //       headers: await getHeaders(),
  //       data: commonRequest.toJson((req) => req.toJson()),
  //       fromJsonT: (json) => LoginResponse.fromJson(json),
  //       ignoreError: false,
  //       requiresToken: false,
  //     );

  //     return response?.data;
  //   } catch (e) {
  //     print('Login Exception: $e');
  //     return null;
  //   }
  // }

  Future<LoginResponse?> login(LoginRequest request) async {
    try {
      var response = await httpService.postService<LoginResponse>(
        endpoint: getLoginApiEndpoint(),
        headers: await getHeaders(),
        data: CommonRequest<LoginRequest>(
          request: request,
          pageMode: 0,
          requestBase: RequestBase(
            clientTag: "abc123",
            transId: "sample string 2",
            requestId: "sample string 4",
          ),
        ).toJson((r) => (r).toJson()),
        fromJsonT: (json) {
          if (json is String) {
            return LoginResponse(data: json);
          } else if (json is Map<String, dynamic>) {
            return LoginResponse.fromJson(json);
          }
          return LoginResponse(data: null);
        },
        ignoreError: false,
        requiresToken: false,
      );

      if (response != null && response.data != null) {
        return response.data;
      }
      return null;
    } catch (e) {
      print('Login Exception: $e');
      return null;
    }
  }

  Future<UserLoginResponse?> userLogin(UserLoginRequest request) async {
    final token = myApplication.preferenceHelper!.getString(accessTokenKey);

    var response = await httpService.postService<UserLoginResponse>(
      endpoint: getUserLoginApiEndpoint(token: token),
      headers: await getHeaders(),
      data: CommonRequest<UserLoginRequest>(
        request: request,
        pageMode: 0,
        requestBase: RequestBase(
          clientTag: "abc123",
          transId: "sample string 2",
          requestId: "sample string 4",
        ),
      ).toJson((r) => (r).toJson()),
      fromJsonT: (json) => UserLoginResponse.fromJson(json),
    );
    if (response != null && response.data != null) {
      return response.data;
    }
    return null;
  }

  // Future<EmailResponse?> getMail(List<CommonRequest> request) async {
  //   var response = await httpService.postService<EmailResponse>(
  //     endpoint: getMailApiEndpoint(),
  //     headers: await getHeaders(
  //       authorization: false,
  //       xCorrelationId: false,
  //       sid: false,
  //     ),
  //     data: request,
  //     fromJsonT: (json) => EmailResponse.fromJson(json),
  //   );
  //   if (response != null && response.data != null) {
  //     return response.data;
  //   }
  //   return null;
  // }

  // Future<OtpResponse?> getOtp(List<CommonRequest> request) async {
  //   var response = await httpService.postService<OtpResponse>(
  //     endpoint: getVerificationCodeApiEndpoint(),
  //     headers: await getHeaders(
  //       authorization: false,
  //       xCorrelationId: false,
  //       sid: false,
  //     ),
  //     data: request,
  //     fromJsonT: (json) => OtpResponse.fromJson(json),
  //   );
  //   if (response != null && response.data != null) {
  //     return response.data;
  //   }
  //   return null;
  // }

  // Future<bool> verifyOtp(List<CommonRequest> request) async {
  //   var response = await httpService.postService(
  //     endpoint: getverifyOtpApiEndpoint(),
  //     headers: await getHeaders(
  //       authorization: false,
  //       xCorrelationId: false,
  //       sid: false,
  //     ),
  //     data: request,
  //     fromJsonT: (json) => json,
  //   );
  //   if (response != null && response.success != null) {
  //     appLog('Change password response: ${response.success}');
  //     return response.success!;
  //   } else {
  //     return false;
  //   }
  // }

  // Future<RefreshResponse?> refresh(RefreshRequest request) async {
  //   final response = await httpService.postService(
  //     endpoint: getRefreshApiEndpoint(),
  //     headers: await getHeaders(
  //       authorization: false,
  //       xCorrelationId: false,
  //       sid: false,
  //     ),
  //     data: request.toJson(),
  //     fromJsonT: (json) => RefreshResponse.fromJson(json),
  //     //retryOnUnauthorized: false,
  //     ignoreError: true, // or true if you want silent handling
  //   );

  //   if (response != null && response.data != null) {
  //     myApplication.preferenceHelper!
  //         .setString(accessTokenKey, response.data!.authToken!);
  //     return response.data;
  //   }
  //   appLog('refresh returned null value', logging: Logging.warning);
  //   return null;
  // }

  // Future<bool> logoutSession() async {
  //   final request = {};
  //   var response = await httpService.postService(
  //     endpoint: getLogoutApiEndpoint(),
  //     headers: await getHeaders(
  //       authorization: true,
  //       xCorrelationId: false,
  //       sid: false,
  //     ),
  //     retryOnUnauthorized: true,
  //     data: request,
  //     fromJsonT: (json) => json,
  //   );
  //   if (response != null) {
  //     return response.success ?? false;
  //   }
  //   return false;
  // }
}
