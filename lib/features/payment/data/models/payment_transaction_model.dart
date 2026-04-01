class PaymentTransactionModel {
  final String payerName;
  final String paymentMethod;
  final String paymentNumber;
  final String date;
  final double amount;
  final int paymentStatusId;
  final String paymentStatus;

  PaymentTransactionModel({
    required this.payerName,
    required this.paymentMethod,
    required this.paymentNumber,
    required this.date,
    required this.amount,
    required this.paymentStatusId,
    required this.paymentStatus,
  });

  factory PaymentTransactionModel.fromJson(Map<String, dynamic> json) {
    return PaymentTransactionModel(
      payerName: json['payer_name'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      paymentNumber: json['payment_number'] ?? '',
      date: json['date'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      paymentStatusId: json['payment_status_id'] ?? 0,
      paymentStatus: json['payment_status'] ?? '',
    );
  }
}
