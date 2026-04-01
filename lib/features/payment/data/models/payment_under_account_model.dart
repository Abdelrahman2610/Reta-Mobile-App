class PaymentUnderAccountModel {
  final int id;
  final String? declarationNumber;
  final String? declarationTypeText;
  final String? statusId;
  final String? statusText;
  final String? submitterType;
  final int unitsCount;
  final int unpaidPropertyCount;
  final double totalAmountUnderAccount;
  final double totalPaidAmount;
  final double totalAmountDue;

  bool get isDraft => statusId == '1';

  PaymentUnderAccountModel({
    required this.id,
    this.declarationNumber,
    this.declarationTypeText,
    this.statusId,
    this.statusText,
    this.submitterType,
    required this.unitsCount,
    required this.unpaidPropertyCount,
    required this.totalAmountUnderAccount,
    required this.totalPaidAmount,
    required this.totalAmountDue,
  });

  factory PaymentUnderAccountModel.fromJson(Map<String, dynamic> json) {
    return PaymentUnderAccountModel(
      id: json['id'],
      declarationNumber: json['declaration_number'],
      declarationTypeText: json['declaration_type_text'] ?? '',
      statusId: json['status_id']?.toString() ?? '',
      statusText: json['status_text'] ?? '',
      submitterType: json['submitter_type'] ?? '',
      unitsCount: json['units_count'] ?? 0,
      unpaidPropertyCount: json['unpaid_property_count'] ?? 0,
      totalAmountUnderAccount:
          double.tryParse(json['total_amount_under_account'].toString()) ?? 0,
      totalPaidAmount:
          double.tryParse(json['total_paid_amount'].toString()) ?? 0,
      totalAmountDue: double.tryParse(json['total_amount_due'].toString()) ?? 0,
    );
  }
}
