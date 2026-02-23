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
}
