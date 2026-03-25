class PaymentStatusLookup {
  final dynamic id; // 'all' or int
  final String name;

  const PaymentStatusLookup({required this.id, required this.name});

  factory PaymentStatusLookup.fromJson(Map<String, dynamic> json) {
    return PaymentStatusLookup(
      id: json['id'],
      name: json['name']?.toString() ?? '',
    );
  }
}
