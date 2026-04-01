class PaymentInfoResponse {
  final double walletBalance;
  final String declarationStatusId;
  final List<PaymentUnitItemModel> units;

  PaymentInfoResponse({
    required this.walletBalance,
    required this.declarationStatusId,
    required this.units,
  });

  factory PaymentInfoResponse.fromJson(Map<String, dynamic> json) {
    return PaymentInfoResponse(
      walletBalance: double.tryParse(json['wallet_balance'].toString()) ?? 0,
      declarationStatusId: json['declaration_status_id'].toString(),
      units: (json['data'] as List)
          .map((e) => PaymentUnitItemModel.fromJson(e))
          .toList(),
    );
  }
}

class PaymentUnitItemModel {
  final int id;
  final String declarationId;
  final String propertyType;
  final String propertyTypeId;
  final String propertyName;
  final String activityType;
  final String governorate;
  final String propertyNumber;
  final double amountUnderPayment;
  final double? requiredAmount;
  final double? paidAmount;
  bool isChecked;
  bool isPaidByWallet;
  final bool isPaidByWalletDisabled;
  final bool isExistInClaim;
  final String type;
  bool isSelected;

  PaymentUnitItemModel({
    required this.id,
    required this.declarationId,
    required this.propertyType,
    required this.propertyTypeId,
    required this.propertyName,
    required this.activityType,
    required this.governorate,
    required this.propertyNumber,
    required this.amountUnderPayment,
    this.requiredAmount,
    this.paidAmount,
    required this.isChecked,
    required this.isPaidByWallet,
    required this.isPaidByWalletDisabled,
    required this.isExistInClaim,
    required this.type,
    this.isSelected = true,
  });

  factory PaymentUnitItemModel.fromJson(Map<String, dynamic> json) {
    return PaymentUnitItemModel(
      id: json['id'],
      declarationId: json['declaration_id'].toString(),
      propertyType: json['property_type'] ?? '',
      propertyTypeId: json['property_type_id'] ?? '',
      propertyName: json['property_name'] ?? '',
      activityType: json['activity_type'] ?? '',
      governorate: json['governorate'] ?? '',
      propertyNumber: json['property_number'] ?? '',
      amountUnderPayment:
          double.tryParse(json['amount_under_payment'].toString()) ?? 0,
      requiredAmount: json['required_amount'] != null
          ? double.tryParse(json['required_amount'].toString())
          : null,
      paidAmount: json['paid_amount'] != null
          ? double.tryParse(json['paid_amount'].toString())
          : null,
      isChecked: json['is_checked'] ?? false,
      isPaidByWallet: json['paid_by_wallet'] ?? false,
      isPaidByWalletDisabled: json['is_paid_by_wallet_disabled'] ?? false,
      isExistInClaim: json['is_exist_in_claim'] ?? false,
      type: json['type'] ?? '',
    );
  }

  static List<PaymentUnitItemModel> listFromJson(List<dynamic> list) {
    return list
        .map((e) => PaymentUnitItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
