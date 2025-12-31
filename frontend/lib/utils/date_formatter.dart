import 'package:intl/intl.dart';

class DateFormatter {
  static String formatShort(DateTime date) {
    return DateFormat('MMM dd').format(date);
  }

  static String formatMedium(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatLong(DateTime date) {
    return DateFormat('EEEE, MMMM dd, yyyy').format(date);
  }

  static String formatTime12Hour(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static String formatTime24Hour(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
  }

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formatMedium(date);
    }
  }
}
