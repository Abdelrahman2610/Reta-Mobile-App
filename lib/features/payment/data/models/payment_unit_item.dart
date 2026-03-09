class PaymentUnitItemModel {
  final String? unitType;
  final String? location;
  final double? amount;
  bool useSettlementAccount;
  bool isSelected;

  PaymentUnitItemModel({
    this.unitType,
    this.location,
    this.amount,
    this.useSettlementAccount = false,
    this.isSelected = true,
  });

  PaymentUnitItemModel copyWith({
    String? unitType,
    String? location,
    double? amount,
    bool? useSettlementAccount,
    bool? isSelected,
  }) {
    return PaymentUnitItemModel(
      unitType: unitType ?? this.unitType,
      location: location ?? this.location,
      amount: amount ?? this.amount,
      useSettlementAccount: useSettlementAccount ?? this.useSettlementAccount,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  factory PaymentUnitItemModel.fromJson(Map<String, dynamic> json) {
    return PaymentUnitItemModel(
      unitType: json['unit_type']?.toString(),
      location: json['location']?.toString(),
      amount: double.tryParse(json['amount']?.toString() ?? ''),
      useSettlementAccount:
          json['use_settlement_account'] == true ||
          json['use_settlement_account'] == 1,
      isSelected: json['is_selected'] == true || json['is_selected'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unit_type': unitType,
      'location': location,
      'amount': amount,
      'use_settlement_account': useSettlementAccount,
      'is_selected': isSelected,
    };
  }

  static List<PaymentUnitItemModel> listFromJson(List<dynamic> list) {
    return list
        .map((e) => PaymentUnitItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
