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
  String attachmentIC = "${svg}attachment_ic.svg";
  String attachmentWhiteIC = "${svg}attachment_ic_white.svg";
}
