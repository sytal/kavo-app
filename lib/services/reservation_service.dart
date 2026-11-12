import 'api_client.dart';

/// Sends a table booking to the backend (`POST /api/v1/reservations`), the
/// same endpoint the website form uses, so it shows up in the admin panel.
class ReservationService {
  ReservationService._();
  static final ReservationService instance = ReservationService._();

  /// Returns null on success, or a readable error message.
  Future<String?> book({
    required String name,
    required String email,
    required String phone,
    required String date, // YYYY-MM-DD
    required String time, // HH:mm (24h)
    required int partySize,
    String? requests,
  }) async {
    final res = await ApiClient.instance.post('/reservations', {
      'name': name,
      'email': email,
      'phone': phone,
      'date': date,
      'time': time,
      'party_size': partySize,
      if (requests != null && requests.trim().isNotEmpty) 'requests': requests.trim(),
    });
    return res.ok ? null : res.errorMessage;
  }
}
