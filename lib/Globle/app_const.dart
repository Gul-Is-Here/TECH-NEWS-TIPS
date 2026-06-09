import 'package:intl/intl.dart';

/// Stateless utility helpers used across the app.
/// For user session data use [AppSession] from Config/app_config.dart.
class AppConst {
  /// Formats an ISO date string (e.g. "2024-08-23T00:00:00") as "Aug 23, 2024".
  /// Returns [rawDate] unchanged if parsing fails.
  String formatDate(String rawDate) {
    try {
      final dateTime = DateTime.parse(rawDate);
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (_) {
      return rawDate;
    }
  }
}
