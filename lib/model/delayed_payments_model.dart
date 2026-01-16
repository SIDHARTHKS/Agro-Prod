// To parse this JSON data, do
//
//     final delayedPaymentsModel = delayedPaymentsModelFromJson(jsonString);

import 'dart:convert';

DelayedPaymentsModel delayedPaymentsModelFromJson(String str) =>
    DelayedPaymentsModel.fromJson(json.decode(str));

String delayedPaymentsModelToJson(DelayedPaymentsModel data) =>
    json.encode(data.toJson());

class DelayedPaymentsModel {
  String? totalBills;
  String? totalAmount;
  String? billsForMonth;
  List<LocationDetailsListDtl>? locationDetailsListDtls;
  List<DelayedPayListDtl>? delayedPayPendingListDtls;
  List<DelayedPayListDtl>? delayedPaySettledListDtls;

  DelayedPaymentsModel({
    this.totalBills,
    this.totalAmount,
    this.billsForMonth,
    this.locationDetailsListDtls,
    this.delayedPayPendingListDtls,
    this.delayedPaySettledListDtls,
  });

  factory DelayedPaymentsModel.fromJson(Map<String, dynamic> json) =>
      DelayedPaymentsModel(
        totalBills: json["TotalBills"],
        totalAmount: json["TotalAmount"],
        billsForMonth: json["BillsForMonth"],
        locationDetailsListDtls: json["LocationDetailsListDtls"] == null
            ? []
            : List<LocationDetailsListDtl>.from(json["LocationDetailsListDtls"]!
                .map((x) => LocationDetailsListDtl.fromJson(x))),
        delayedPayPendingListDtls: json["DelayedPayPendingListDtls"] == null
            ? []
            : List<DelayedPayListDtl>.from(json["DelayedPayPendingListDtls"]!
                .map((x) => DelayedPayListDtl.fromJson(x))),
        delayedPaySettledListDtls: json["DelayedPaySettledListDtls"] == null
            ? []
            : List<DelayedPayListDtl>.from(json["DelayedPaySettledListDtls"]!
                .map((x) => DelayedPayListDtl.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "TotalBills": totalBills,
        "TotalAmount": totalAmount,
        "BillsForMonth": billsForMonth,
        "LocationDetailsListDtls": locationDetailsListDtls == null
            ? []
            : List<dynamic>.from(
                locationDetailsListDtls!.map((x) => x.toJson())),
        "DelayedPayPendingListDtls": delayedPayPendingListDtls == null
            ? []
            : List<dynamic>.from(
                delayedPayPendingListDtls!.map((x) => x.toJson())),
        "DelayedPaySettledListDtls": delayedPaySettledListDtls == null
            ? []
            : List<dynamic>.from(
                delayedPaySettledListDtls!.map((x) => x.toJson())),
      };
}

class DelayedPayListDtl {
  String? compCode;
  String? branchCode;
  String? syCode;
  int? locationId;
  int? invoiceId;
  String? custName;
  String? billNo;
  String? location;
  String? billAmt;
  String? phoneNo;
  String? billedOn;
  String? committedOn;
  String? lateDays;
  String? settledOn;
  String? paymentMode;

  DelayedPayListDtl({
    this.compCode,
    this.branchCode,
    this.syCode,
    this.locationId,
    this.invoiceId,
    this.custName,
    this.billNo,
    this.location,
    this.billAmt,
    this.phoneNo,
    this.billedOn,
    this.committedOn,
    this.lateDays,
    this.settledOn,
    this.paymentMode,
  });

  factory DelayedPayListDtl.fromJson(Map<String, dynamic> json) =>
      DelayedPayListDtl(
        compCode: json["CompCode"],
        branchCode: json["BranchCode"],
        syCode: json["SyCode"],
        locationId: json["LocationID"],
        invoiceId: json["InvoiceID"],
        custName: json["CustName"],
        billNo: json["BillNo"],
        location: json["Location"],
        billAmt: json["BillAmt"],
        phoneNo: json["PhoneNo"],
        billedOn: json["BilledOn"],
        committedOn: json["CommittedOn"],
        lateDays: json["LateDays"],
        settledOn: json["SettledOn"],
        paymentMode: json["PaymentMode"],
      );

  Map<String, dynamic> toJson() => {
        "CompCode": compCode,
        "BranchCode": branchCode,
        "SyCode": syCode,
        "LocationID": locationId,
        "InvoiceID": invoiceId,
        "CustName": custName,
        "BillNo": billNo,
        "Location": location,
        "BillAmt": billAmt,
        "PhoneNo": phoneNo,
        "BilledOn": billedOn,
        "CommittedOn": committedOn,
        "LateDays": lateDays,
        "SettledOn": settledOn,
        "PaymentMode": paymentMode,
      };
}

class LocationDetailsListDtl {
  String? locationName;
  String? locTotAmt;
  String? locTotBillCnt;

  LocationDetailsListDtl({
    this.locationName,
    this.locTotAmt,
    this.locTotBillCnt,
  });

  factory LocationDetailsListDtl.fromJson(Map<String, dynamic> json) =>
      LocationDetailsListDtl(
        locationName: json["LocationName"],
        locTotAmt: json["LocTotAmt"],
        locTotBillCnt: json["LocTotBillCnt"],
      );

  Map<String, dynamic> toJson() => {
        "LocationName": locationName,
        "LocTotAmt": locTotAmt,
        "LocTotBillCnt": locTotBillCnt,
      };
}

DelayedPaymentsRequest delayedPaymentsRequestFromJson(String str) =>
    DelayedPaymentsRequest.fromJson(json.decode(str));

String delayedPaymentsRequestToJson(DelayedPaymentsRequest data) =>
    json.encode(data.toJson());

class DelayedPaymentsRequest {
  String? companyCode;
  String? branchCode;
  String? repToDate;

  DelayedPaymentsRequest({
    this.companyCode,
    this.branchCode,
    this.repToDate,
  });

  factory DelayedPaymentsRequest.fromJson(Map<String, dynamic> json) =>
      DelayedPaymentsRequest(
        companyCode: json["CompanyCode"],
        branchCode: json["BranchCode"],
        repToDate: json["RepToDate"],
      );

  Map<String, dynamic> toJson() => {
        "CompanyCode": companyCode,
        "BranchCode": branchCode,
        "RepToDate": repToDate,
      };
}
