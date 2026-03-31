import '../../../../core/helpers/app_enum.dart';
import '../../../../core/helpers/extensions/payment_request_status.dart';

class PaymentClaimModel {
  final int id;
  final String claimNumber;
  final String claimDate;
  final double amount;
  final int statusId;
  final String statusName;
  final String? claimReceipt;
  final String? claimDetails;
  final bool fromWallet;
  final String? procedureType;
  final String? declarationNumber;
  final int? declarationId;
  final int? unitCount;
  final String? methodTypeId;
  final String? paymentMethod;

  const PaymentClaimModel({
    required this.id,
    required this.claimNumber,
    required this.claimDate,
    required this.amount,
    required this.statusId,
    required this.statusName,
    this.claimReceipt,
    this.claimDetails,
    required this.fromWallet,
    this.procedureType,
    this.declarationNumber,
    this.declarationId,
    this.unitCount,
    this.methodTypeId,
    this.paymentMethod,
  });

  factory PaymentClaimModel.fromJson(Map<String, dynamic> json) {
    return PaymentClaimModel(
      id: json['id'],
      claimNumber: json['claim_number'] ?? '',
      claimDate: json['claim_date'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      statusId: json['status_id'],
      statusName: json['status_name'] ?? '',
      claimReceipt: json['claim_receipt'],
      claimDetails: json['claim_details'],
      fromWallet: json['from_wallet'] ?? false,
      procedureType: json['procedure_type'],
      declarationNumber: json['declaration_number'],
      declarationId: json['declaration_id'],
      unitCount: json['units_count'] ?? json['unit_count'],
      methodTypeId: json['method_type_id'],
      paymentMethod: json['payment_method'],
    );
  }

  PaymentRequestStatus get status => statusId.toString().toStatus;
  bool get canPayElectronically => statusId == 1 || statusId == 3;
  bool get canPrint => statusId == 2;
  bool get canView => statusId == 2;
  bool get isPaid => statusId == 2;
  bool get canDelete => statusId == 1;
  bool get canShare => statusId != 2 && statusId != 4;
}
