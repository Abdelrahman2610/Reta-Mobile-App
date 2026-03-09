import '../../../../core/helpers/extensions/payment_status.dart';

class OnlinePaymentModel {
  final PaymentStatus status;
  final String? amount;
  final String? operationNumber;

  const OnlinePaymentModel({
    required this.status,
    this.amount,
    this.operationNumber,
  });

  OnlinePaymentModel copyWith({
    PaymentStatus? status,
    String? amount,
    String? operationNumber,
  }) {
    return OnlinePaymentModel(
      status: status ?? this.status,
      amount: amount ?? this.amount,
      operationNumber: operationNumber ?? this.operationNumber,
    );
  }

  factory OnlinePaymentModel.fromJson(Map<String, dynamic> json) {
    return OnlinePaymentModel(
      status: (json['status'].toString()).fromJson,
      amount: json['amount']?.toString(),
      operationNumber: json['operation_number']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.toJson,
      'amount': amount,
      'operation_number': operationNumber,
    };
  }

  static List<OnlinePaymentModel> listFromJson(List<dynamic> list) {
    return list
        .map((e) => OnlinePaymentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
