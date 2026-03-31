//main path
String assets = "assets/";
String images = "${assets}images/";
String svg = "${assets}svg/";

class FixedAssets {
  FixedAssets._();

  static final FixedAssets _instance = FixedAssets._();

  static FixedAssets get instance => _instance;

  //SVG
  String addIcon = "${svg}add_icon.svg";
  String sendIcon = "${svg}send_icon.svg";
  String closeIcon = "${svg}close_icon.svg";
  String deleteIcon = "${svg}delete_icon.svg";
  String icon1 = "${svg}icon1.svg";
  String icon2 = "${svg}icon2.svg";
  String icon3 = "${svg}icon3.svg";
  String icon4 = "${svg}icon4.svg";
  String icon5 = "${svg}icon5.svg";
  String icon6 = "${svg}icon6.svg";
  String icon7 = "${svg}icon7.svg";
  String icon8 = "${svg}icon8.svg";
  String icon9 = "${svg}icon9.svg";
  String icon10 = "${svg}icon10.svg";
  String icon11 = "${svg}icon11.svg";
  String icon12 = "${svg}icon12.svg";
  String attachmentIC = "${svg}attachment_ic.svg";
  String attachmentWhiteIC = "${svg}attachment_ic_white.svg";
  String selectedHome = "${svg}selected_home.svg";
  String unselectedHome = "${svg}unselected_home.svg";
  String selectedDebt = "${svg}selected_debt.svg";
  String unselectedDebt = "${svg}unselected_debt.svg";
  String unselectedPayment = "${svg}unselected_payment.svg";
  String selectedPayment = "${svg}selected_payment.svg";
  String declaration = "${svg}declaration.svg";
  String selectedSettings = "${svg}selected_settings.svg";
  String unselectedSettings = "${svg}unselected_settings.svg";
  String calendarIC = "${svg}calendar_ic.svg";
  String deleteIC = "${svg}delete_ic.svg";
  String infoIC = "${svg}info_ic.svg";
  String settlementIC = "${svg}settlement_ic.svg";
  String paymentRequestsIC = "${svg}payment_requests_ic.svg";
  String paymentUnderAccountIC = "${svg}payment_under_account_ic.svg";
  String successIC = "${svg}success_ic.svg";
  String paymentSuccessIC = "${svg}payment_success_ic.svg";
  String paymentFailIC = "${svg}payment_fail_ic.svg";
  String filterIC = "${svg}filter_ic.svg";
  String shareIC = "${svg}share_ic.svg";
  String previewIC = "${svg}preview_ic.svg";
  String printIC = "${svg}print_ic.svg";
  String deleteICGrey = "${svg}delete_ic_grey.svg";
  String dateIC = "${svg}date_ic.svg";
  String warningIC = "${svg}warning_ic.svg";
}
