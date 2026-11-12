import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';

/// Business info from Admin > Business Info (GET /api/v1/business): phone,
/// WhatsApp, socials, address, hours, reservation time slots, delivery fee.
class BusinessService extends ChangeNotifier {
  BusinessService._();
  static final BusinessService instance = BusinessService._();

  Map<String, dynamic> _data = {
    'address': 'Gulberg Thana Road, Faisalabad',
    'hours_label': 'Daily, 1pm – 1am',
    'open_time': '13:00',
    'close_time': '01:00',
    'delivery_fee': 0,
    'time_slots': <String>[],
  };

  String _s(String k) => (_data[k] ?? '').toString();
  String get phone => _s('phone');
  String get whatsappUrl => _s('whatsapp_url');
  String get email => _s('email');
  String get address => _s('address');
  String get instagram => _s('instagram');
  String get facebook => _s('facebook');
  String get hoursLabel => _s('hours_label');
  String get openTime => _s('open_time');
  num get deliveryFee => (_data['delivery_fee'] is num) ? _data['delivery_fee'] as num : num.tryParse(_s('delivery_fee')) ?? 0;
  List<String> get timeSlots => (_data['time_slots'] is List) ? (_data['time_slots'] as List).map((e) => e.toString()).toList() : const [];

  static const _cacheKey = 'business_cache_v1';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_cacheKey);
    if (cached != null) {
      try {
        _data = Map<String, dynamic>.from(jsonDecode(cached) as Map);
        notifyListeners();
      } catch (_) {}
    }
    final res = await ApiClient.instance.get('/business');
    if (res.ok && res.data is Map && res.data['data'] is Map) {
      _data = Map<String, dynamic>.from(res.data['data'] as Map);
      await prefs.setString(_cacheKey, jsonEncode(_data));
      notifyListeners();
    }
  }
}
