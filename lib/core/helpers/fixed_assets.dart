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
}
