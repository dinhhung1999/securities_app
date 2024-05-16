

import 'package:securities_app/config/prod_config.dart';
import 'package:securities_app/config/uat_config.dart';

class AppConfig {
  late Config config;

  void setUat() {
    config = UatConfig();
  }

  void setProd() {
    config = ProdConfig();
  }
}

abstract class Config {
  String get baseUrl;

  // Nhóm API đặt lệnh
  String get tradingUrl;

  // Nhóm API thị trường
  String get marektUrl;

  // TradingView Url
  String get tradingViewUrl;

  /// API Lấy Access token cho TradingView
  String get tradingViewSessionUrl;

  String get socketUrl;

  int get socketPort;

}