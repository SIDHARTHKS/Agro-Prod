// To parse this JSON data, do
//
//     final billSummaryModel = billSummaryModelFromJson(jsonString);

import 'dart:convert';

BillSummaryModel billSummaryModelFromJson(String str) =>
    BillSummaryModel.fromJson(json.decode(str));

String billSummaryModelToJson(BillSummaryModel data) =>
    json.encode(data.toJson());

class BillSummaryModel {
  String? custName;
  String? billNo;
  String? location;
  String? billDate;
  String? committedDate;
  String? transactionType;
  String? noOfItems;
  String? noOfPackets;
  String? totQty;
  String? grossAmount;
  String? discountAmt;
  String? netAmt;
  String? taxAmt;
  String? roundOff;
  String? totalAmt;
  String? lateDays;
  String? settledDate;
  String? phoneNo;
  String? custAddress;
  List<ProductDetailsListDtl>? productDetailsListDtls;

  BillSummaryModel(
      {this.custName,
      this.billNo,
      this.location,
      this.billDate,
      this.committedDate,
      this.transactionType,
      this.noOfItems,
      this.noOfPackets,
      this.totQty,
      this.grossAmount,
      this.discountAmt,
      this.netAmt,
      this.taxAmt,
      this.roundOff,
      this.totalAmt,
      this.productDetailsListDtls,
      this.lateDays,
      this.settledDate,
      this.phoneNo,
      this.custAddress});

  factory BillSummaryModel.fromJson(Map<String, dynamic> json) =>
      BillSummaryModel(
        custName: json["CustName"],
        billNo: json["BillNo"],
        location: json["Location"],
        billDate: json["BillDate"],
        committedDate: json["CommittedDate"],
        transactionType: json["TransactionType"],
        noOfItems: json["NoOfItems"],
        noOfPackets: json["NoOfPackets"],
        totQty: json["TotQty"],
        grossAmount: json["GrossAmount"],
        discountAmt: json["DiscountAmt"],
        netAmt: json["NetAmt"],
        taxAmt: json["TaxAmt"],
        roundOff: json["RoundOff"],
        totalAmt: json["TotalAmt"],
        lateDays: json["LateDays"],
        settledDate: json["SettledDate"],
        phoneNo: json["PhoneNo"],
        custAddress: json["CustAddress"],
        productDetailsListDtls: json["ProductDetailsListDtls"] == null
            ? []
            : List<ProductDetailsListDtl>.from(json["ProductDetailsListDtls"]!
                .map((x) => ProductDetailsListDtl.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "CustName": custName,
        "BillNo": billNo,
        "Location": location,
        "BillDate": billDate,
        "CommittedDate": committedDate,
        "TransactionType": transactionType,
        "NoOfItems": noOfItems,
        "NoOfPackets": noOfPackets,
        "TotQty": totQty,
        "GrossAmount": grossAmount,
        "DiscountAmt": discountAmt,
        "NetAmt": netAmt,
        "TaxAmt": taxAmt,
        "RoundOff": roundOff,
        "TotalAmt": totalAmt,
        "LateDays": lateDays,
        "SettledDate": settledDate,
        "PhoneNo": phoneNo,
        "CustAddress": custAddress,
        "ProductDetailsListDtls": productDetailsListDtls == null
            ? []
            : List<dynamic>.from(
                productDetailsListDtls!.map((x) => x.toJson())),
      };
}

class ProductDetailsListDtl {
  String? bundleBarcode;
  String? noOfPkts;
  String? qty;
  String? productName;
  String? prodTotalAmt;

  ProductDetailsListDtl({
    this.bundleBarcode,
    this.noOfPkts,
    this.qty,
    this.productName,
    this.prodTotalAmt,
  });

  factory ProductDetailsListDtl.fromJson(Map<String, dynamic> json) =>
      ProductDetailsListDtl(
        bundleBarcode: json["BundleBarcode"],
        noOfPkts: json["NoOfPkts"],
        qty: json["Qty"],
        productName: json["ProductName"],
        prodTotalAmt: json["ProdTotalAmt"],
      );

  Map<String, dynamic> toJson() => {
        "BundleBarcode": bundleBarcode,
        "NoOfPkts": noOfPkts,
        "Qty": qty,
        "ProductName": productName,
        "ProdTotalAmt": prodTotalAmt,
      };
}

BillSummaryRequest billSummaryRequestFromJson(String str) =>
    BillSummaryRequest.fromJson(json.decode(str));

String billSummaryRequestToJson(BillSummaryRequest data) =>
    json.encode(data.toJson());

class BillSummaryRequest {
  String? companyCode;
  String? branchCode;
  String? syCode;
  int? locationId;
  int? invoiceId;

  BillSummaryRequest({
    this.companyCode,
    this.branchCode,
    this.syCode,
    this.locationId,
    this.invoiceId,
  });

  factory BillSummaryRequest.fromJson(Map<String, dynamic> json) =>
      BillSummaryRequest(
        companyCode: json["CompanyCode"],
        branchCode: json["BranchCode"],
        syCode: json["SyCode"],
        locationId: json["LocationID"],
        invoiceId: json["InvoiceID"],
      );

  Map<String, dynamic> toJson() => {
        "CompanyCode": companyCode,
        "BranchCode": branchCode,
        "SyCode": syCode,
        "LocationID": locationId,
        "InvoiceID": invoiceId,
      };
}
