import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      // Running in browser on laptop or mobile
      if (Uri.base.host == 'localhost') {
        return "http://localhost:8080";
      } else {
        return "http://192.168.0.240:8080";  // 192.168.0.240 , 192.168.194.185
      }
    } else {
      // Mobile app
      return "http://192.168.0.240:8080";  // 192.168.0.240 , 192.168.194.185
    }
  }
}
