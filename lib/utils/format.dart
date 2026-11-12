// Shared display formatting so prices and dates look the same everywhere
// in the app (and match the website: "Rs. 2,650").

/// 2650 -> "Rs. 2,650"; 1250.5 -> "Rs. 1,250.50"
String formatRs(num amount) {
  final isWhole = amount == amount.roundToDouble();
  final fixed = amount.toStringAsFixed(isWhole ? 0 : 2);
  final parts = fixed.split('.');
  final digits = parts[0];
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
    buf.write(digits[i]);
  }
  return 'Rs. $buf${parts.length > 1 ? '.${parts[1]}' : ''}';
}

/// Pulls the number out of a display price like "Rs. 1,250".
double parsePrice(String price) {
  final match = RegExp(r'[\d,]+(\.\d+)?').firstMatch(price);
  return match == null ? 0 : double.tryParse(match.group(0)!.replaceAll(',', '')) ?? 0;
}

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

/// DateTime -> "12 Nov 2026, 3:45 PM" (local time)
String formatDateTime(DateTime when) {
  final local = when.toLocal();
  final hour12 = local.hour % 12 == 0 ? 12 : local.hour % 12;
  final minute = local.minute.toString().padLeft(2, '0');
  final ampm = local.hour < 12 ? 'AM' : 'PM';
  return '${local.day} ${_months[local.month - 1]} ${local.year}, $hour12:$minute $ampm';
}
