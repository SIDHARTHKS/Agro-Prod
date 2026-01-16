// login request

import 'dart:convert';

LoginRequest loginRequestFromJson(String str) =>
    LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest {
  String? userCode;
  String? password;

  LoginRequest({
    this.userCode,
    this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        userCode: json["UserCode"],
        password: json["Password"],
      );

  Map<String, dynamic> toJson() => {
        "UserCode": userCode, // NOTE: Capitalized keys!
        "Password": password,
      };
}

//login response

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  String? data;

  LoginResponse({
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}

//

UserLoginResponse userLoginResponseFromJson(String str) =>
    UserLoginResponse.fromJson(json.decode(str));

String userLoginResponseToJson(UserLoginResponse data) =>
    json.encode(data.toJson());

class UserLoginResponse {
  String? userName;
  String? userCode;
  String? userId;
  String? userValidYn;
  int? employeeId;
  String? employeeCode;
  String? employeeName;
  int? locationId;
  String? locationName;
  int? companyId;
  int? branchId;
  String? userImgUrl;
  String? employeeType;

  UserLoginResponse({
    this.userName,
    this.userCode,
    this.userId,
    this.userValidYn,
    this.employeeId,
    this.employeeCode,
    this.employeeName,
    this.locationId,
    this.locationName,
    this.companyId,
    this.branchId,
    this.userImgUrl,
    this.employeeType,
  });

  factory UserLoginResponse.fromJson(Map<String, dynamic> json) =>
      UserLoginResponse(
        userName: json["userName"],
        userCode: json["userCode"],
        userId: json["userID"],
        userValidYn: json["userValidYN"],
        employeeId: json["employeeID"],
        employeeCode: json["employeeCode"],
        employeeName: json["employeeName"],
        locationId: json["locationID"],
        locationName: json["locationName"],
        companyId: json["companyID"],
        branchId: json["branchID"],
        userImgUrl: json["userImgUrl"],
        employeeType: json["employeeType"],
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "userCode": userCode,
        "userID": userId,
        "userValidYN": userValidYn,
        "employeeID": employeeId,
        "employeeCode": employeeCode,
        "employeeName": employeeName,
        "locationID": locationId,
        "locationName": locationName,
        "companyID": companyId,
        "branchID": branchId,
        "userImgUrl": userImgUrl,
        "employeeType": employeeType,
      };
}

//

EmailResponse emailResponseFromJson(String str) =>
    EmailResponse.fromJson(json.decode(str));

String emailResponseToJson(EmailResponse data) => json.encode(data.toJson());

class EmailResponse {
  String? message;
  String? emailId;

  EmailResponse({
    this.message,
    this.emailId,
  });

  factory EmailResponse.fromJson(Map<String, dynamic> json) => EmailResponse(
        message: json["message"],
        emailId: json["emailID"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "emailID": emailId,
      };
}

OtpRequest otpRequestFromJson(String str) =>
    OtpRequest.fromJson(json.decode(str));

String otpRequestToJson(OtpRequest data) => json.encode(data.toJson());

class OtpRequest {
  Requestotp? request;
  int? pageMode;

  OtpRequest({
    this.request,
    this.pageMode,
  });

  factory OtpRequest.fromJson(Map<String, dynamic> json) => OtpRequest(
        request: json["Request"] == null
            ? null
            : Requestotp.fromJson(json["Request"]),
        pageMode: json["PageMode"],
      );

  Map<String, dynamic> toJson() => {
        "Request": request?.toJson(),
        "PageMode": pageMode,
      };
}

class Requestotp {
  String? userCode;
  String? emailId;

  Requestotp({
    this.userCode,
    this.emailId,
  });

  factory Requestotp.fromJson(Map<String, dynamic> json) => Requestotp(
        userCode: json["UserCode"],
        emailId: json["EmailID"],
      );

  Map<String, dynamic> toJson() => {
        "UserCode": userCode,
        "EmailID": emailId,
      };
}

OtpResponse otpResponseFromJson(String str) =>
    OtpResponse.fromJson(json.decode(str));

String otpResponseToJson(OtpResponse data) => json.encode(data.toJson());

class OtpResponse {
  String? verificationCode;

  OtpResponse({
    this.verificationCode,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) => OtpResponse(
        verificationCode: json["VerificationCode"],
      );

  Map<String, dynamic> toJson() => {
        "VerificationCode": verificationCode,
      };
}

VerifyOtpRequest verifyOtpRequestFromJson(String str) =>
    VerifyOtpRequest.fromJson(json.decode(str));

String verifyOtpRequestToJson(VerifyOtpRequest data) =>
    json.encode(data.toJson());

class VerifyOtpRequest {
  VerifyOtpDetails? request;
  int? pageMode;

  VerifyOtpRequest({
    this.request,
    this.pageMode,
  });

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) =>
      VerifyOtpRequest(
        request: json["Request"] == null
            ? null
            : VerifyOtpDetails.fromJson(json["Request"]),
        pageMode: json["PageMode"],
      );

  Map<String, dynamic> toJson() => {
        "Request": request?.toJson(),
        "PageMode": pageMode,
      };
}

class VerifyOtpDetails {
  String? userCode;
  String? verificationCode;

  VerifyOtpDetails({
    this.userCode,
    this.verificationCode,
  });

  factory VerifyOtpDetails.fromJson(Map<String, dynamic> json) =>
      VerifyOtpDetails(
        userCode: json["UserCode"],
        verificationCode: json["VerificationCode"],
      );

  Map<String, dynamic> toJson() => {
        "UserCode": userCode,
        "VerificationCode": verificationCode,
      };
}

//

class RefreshTokenRequest {
  String? refreshToken;

  RefreshTokenRequest({
    this.refreshToken,
  });

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      RefreshTokenRequest(refreshToken: json["refreshToken"]);

  Map<String, dynamic> toJson() => {"refreshToken": refreshToken};
}

RefreshTokenResponse refreshTokenResponseFromJson(String str) =>
    RefreshTokenResponse.fromJson(json.decode(str));

String refreshTokenResponseToJson(RefreshTokenResponse data) =>
    json.encode(data.toJson());

class RefreshTokenResponse {
  String? authToken;
  String? authExpiry;

  RefreshTokenResponse({
    this.authToken,
    this.authExpiry,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      RefreshTokenResponse(
        authToken: json["authToken"],
        authExpiry: json["authExpiry"],
      );

  Map<String, dynamic> toJson() => {
        "authToken": authToken,
        "authExpiry": authExpiry,
      };
}

// token
//

RefreshResponse refreshResponseFromJson(String str) =>
    RefreshResponse.fromJson(json.decode(str));

String refreshResponseToJson(RefreshResponse data) =>
    json.encode(data.toJson());

class RefreshResponse {
  String? authToken;
  String? authExpiry;

  RefreshResponse({
    this.authToken,
    this.authExpiry,
  });

  factory RefreshResponse.fromJson(Map<String, dynamic> json) =>
      RefreshResponse(
        authToken: json["authToken"],
        authExpiry: json["authExpiry"],
      );

  Map<String, dynamic> toJson() => {
        "authToken": authToken,
        "authExpiry": authExpiry,
      };
}

//
//

RefreshRequest refreshRequestFromJson(String str) =>
    RefreshRequest.fromJson(json.decode(str));

String refreshRequestToJson(RefreshRequest data) => json.encode(data.toJson());

class RefreshRequest {
  String? refreshToken;

  RefreshRequest({
    this.refreshToken,
  });

  factory RefreshRequest.fromJson(Map<String, dynamic> json) => RefreshRequest(
        refreshToken: json["refreshToken"],
      );

  Map<String, dynamic> toJson() => {
        "refreshToken": refreshToken,
      };
}
