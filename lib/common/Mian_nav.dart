import 'package:flutter/material.dart';
import 'package:flutter_fcm/common/Strings.dart';
import 'package:flutter_fcm/common/Text_Style.dart';

final List<String> tabTitle = ["Home", "Setting"];

dynamic pages = [
  {
    "icon": Image.asset("images/nav_home_icon.png", width: 25.0, height: 25.0),
    "icon2": Image.asset("images/nav_home_checked_icon.png",
        width: 25.0, height: 25.0),
    "title": Text(Strings.home, style: textStyle),
    "title2": Text(Strings.home, style: textStyle2),
//    "type": MainScreenType.HOME
  },
  {
    "icon":
        Image.asset("images/nav_setting_icon.png", width: 25.0, height: 25.0),
    "icon2": Image.asset("images/nav_setting_checked_icon.png",
        width: 25.0, height: 25.0),
    "title": Text(Strings.setting, style: textStyle),
    "title2": Text(Strings.setting, style: textStyle2),
//    "type": MainScreenType.SETTING
  },
];
