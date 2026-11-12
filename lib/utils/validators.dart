/// Form validators shared by every screen, mirroring the backend rules so
/// the user hears about a problem before the request is sent.
class Validators {
  Validators._();

  static String? required(String? v, [String message = 'Required']) =>
      (v == null || v.trim().isEmpty) ? message : null;

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Enter your email';
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim()) ? null : 'Enter a valid email';
  }

  /// Same rule as the server (App\Rules\PhoneNumber): digits with an
  /// optional "+", spaces, dashes or brackets; 10–13 digits in total.
  static String? phone(String? v, {bool optional = false}) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return optional ? null : 'Enter your phone number';
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final allowed = RegExp(r'^\+?[0-9\s\-()]+$').hasMatch(value);
    if (!allowed || digits.length < 10 || digits.length > 13) {
      return 'Enter a valid phone number, e.g. 03001234567';
    }
    return null;
  }
}
