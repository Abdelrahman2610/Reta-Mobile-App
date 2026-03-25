import 'package:reta/core/helpers/app_enum.dart';

import '../../../../core/helpers/extensions/transaction_status.dart';

class TransactionModel {
  final String? id;
  final TransactionStatus transactionStatus;
  final String? amount;
  final String? transactionNumber;
  final String? operationNumber;
  final DateTime? transactionDateTime;

  const TransactionModel({
    this.id,
    required this.transactionStatus,
    this.amount,
    this.transactionNumber,
    this.operationNumber,
    this.transactionDateTime,
  });

  TransactionModel copyWith({
    String? id,
    TransactionStatus? transactionStatus,
    String? amount,
    String? transactionNumber,
    String? operationNumber,
    DateTime? transactionDateTime,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      transactionStatus: transactionStatus ?? this.transactionStatus,
      amount: amount ?? this.amount,
      transactionNumber: transactionNumber ?? this.transactionNumber,
      operationNumber: operationNumber ?? this.operationNumber,
      transactionDateTime: transactionDateTime ?? this.transactionDateTime,
    );
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id']?.toString(),
      transactionStatus: (json['transaction_status'].toString()).fromJson,
      amount: json['amount']?.toString(),
      transactionNumber: json['transaction_number']?.toString(),
      operationNumber: json['procedure_number']?.toString(),
      transactionDateTime: json['transaction_date_time'] != null
          ? DateTime.tryParse(json['transaction_date_time'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_status': transactionStatus.toJson,
      'amount': amount,
      'transaction_number': transactionNumber,
      'procedure_number': operationNumber,
      'transaction_date_time': transactionDateTime?.toIso8601String(),
    };
  }

  static List<TransactionModel> fromJsonList(List<dynamic> list) {
    return list
        .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
