import 'package:flutter/services.dart';

class MoMoPayment {
  static const MethodChannel _channel = MethodChannel('com.yourcompany.momo');

  static Future<String?> requestPayment(String amount) async {
    try {
      final String? result =
          await _channel.invokeMethod('requestPayment', {"amount": amount});
      return result;
    } on PlatformException catch (e) {
      return "Failed to get token: '${e.message}'.";
    }
  }
}
