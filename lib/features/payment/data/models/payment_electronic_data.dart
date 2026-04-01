class PaymentElectronicData {
  final String senderID;
  final String randomSecret;
  final String requestObject;
  final String hashedRequestObject;
  final String paymentUrl;

  PaymentElectronicData({
    required this.senderID,
    required this.randomSecret,
    required this.requestObject,
    required this.hashedRequestObject,
    required this.paymentUrl,
  });

  factory PaymentElectronicData.fromJson(Map<String, dynamic> json) {
    return PaymentElectronicData(
      senderID: json['SenderID'] ?? '',
      randomSecret: json['RandomSecret'] ?? '',
      requestObject: json['RequestObject'] ?? '',
      hashedRequestObject: json['HashedRequestObject'] ?? '',
      paymentUrl: json['payment_gateway_url'] ?? '',
    );
  }
}
