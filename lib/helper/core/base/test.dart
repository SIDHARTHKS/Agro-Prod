/// A generic class representing a response with common properties.
class MisBaseResponse2<T> {
  /// A boolean indicating the success status of the response.
  bool success;

  /// An optional message associated with the response.
  String? message;

  /// Generic data associated with the response.
  T? data;
  List<dynamic>? errors;
  MisBaseResponse2(
      {required this.success, this.message, this.data, this.errors});

  factory MisBaseResponse2.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return MisBaseResponse2(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errors: json["errors"] == null
          ? []
          : List<dynamic>.from(
              json["errors"]!.map((x) => ResponseError.fromJson(x))),
    );
  }
}

class ResponseError {
  final String code;
  final String message;
  final String errorType;
  final String ruleConstSortOrder;

  ResponseError({
    required this.code,
    required this.message,
    required this.errorType,
    required this.ruleConstSortOrder,
  });

  factory ResponseError.fromJson(Map<String, dynamic> json) => ResponseError(
        code: json["code"],
        message: json["message"],
        errorType: json["errorType"],
        ruleConstSortOrder: json["ruleConstSortOrder"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "errorType": errorType,
        "ruleConstSortOrder": ruleConstSortOrder,
      };
}
