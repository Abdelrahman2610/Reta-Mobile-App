import 'dart:developer';

import 'package:flutter/cupertino.dart';

class PendingDebtDocument {
  final String name;
  final String path;
  final String originalFileName;
  final String fullUrl;

  PendingDebtDocument({
    required this.name,
    required this.path,
    required this.originalFileName,
    required this.fullUrl,
  });
}

class DebtSupportingDocument {
  final int id;
  final String url;
  final String fullUrl;
  final String originalFileName;
  final String name;
  final String path;

  DebtSupportingDocument({
    required this.id,
    required this.url,
    required this.fullUrl,
    required this.originalFileName,
    required this.name,
    required this.path,
  });

  factory DebtSupportingDocument.fromJson(Map<String, dynamic> json) {
    return DebtSupportingDocument(
      id: json['id'],
      url: json['url'] ?? '',
      fullUrl: json['full_url'] ?? '',
      originalFileName: json['original_file_name'] ?? '',
      name: json['name'] ?? '',
      path: json['path'] ?? '',
    );
  }
}

class DebtUnitItemModel {
  final int id;
  final String declarationId;
  final String propertyTypeId;
  final String propertyType;
  final String propertyName;
  final String propertyNumber;
  final String activityType;
  final String governorate;
  final String type;
  final String requiredAmount;
  final String paidAmount;
  final double amount;
  final List<DebtSupportingDocument> debtSupportingDocuments;
  bool isSelected;
  final TextEditingController amountController = TextEditingController();
  final List<PendingDebtDocument> pendingDocuments = [];

  DebtUnitItemModel({
    required this.id,
    required this.declarationId,
    required this.propertyTypeId,
    required this.propertyType,
    required this.propertyName,
    required this.propertyNumber,
    required this.activityType,
    required this.governorate,
    required this.type,
    required this.requiredAmount,
    required this.paidAmount,
    required this.amount,
    required this.debtSupportingDocuments,
    this.isSelected = true,
  });

  factory DebtUnitItemModel.fromJson(Map<String, dynamic> json) {
    log(
      'FromJson: required_amount: ${double.tryParse(json['required_amount'].toString())}',
    );
    log(
      'FromJson: paid_amount: ${double.tryParse(json['paid_amount'].toString())}',
    );
    final unit = DebtUnitItemModel(
      id: json['id'],
      declarationId: json['declaration_id'].toString(),
      propertyTypeId: json['property_type_id'].toString(),
      propertyType: json['property_type'] ?? '',
      propertyName: json['property_name'] ?? '',
      propertyNumber: json['property_number'] ?? '',
      activityType: json['activity_type'] ?? '',
      governorate: json['governorate'] ?? '',
      type: json['type'] ?? '',
      requiredAmount: json['required_amount'].toString(),
      paidAmount: json['paid_amount'].toString(),
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      debtSupportingDocuments: (json['debt_supporting_document'] as List)
          .map((e) => DebtSupportingDocument.fromJson(e))
          .toList(),
      isSelected: false,
    );
    unit.amountController.text = double.tryParse(json['amount'].toString()) != 0
        ? json['amount'].toString()
        : '';
    return unit;
  }

  void dispose() => amountController.dispose();
}

class DebtUnitsResponse {
  final String declarationStatusId;
  final List<DebtUnitItemModel> units;

  DebtUnitsResponse({required this.declarationStatusId, required this.units});

  factory DebtUnitsResponse.fromJson(Map<String, dynamic> json) {
    return DebtUnitsResponse(
      declarationStatusId: json['declaration_status_id'].toString(),
      units: (json['data'] as List)
          .map((e) => DebtUnitItemModel.fromJson(e))
          .toList(),
    );
  }
}
