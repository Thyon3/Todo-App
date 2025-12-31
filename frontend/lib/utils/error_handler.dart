import 'package:flutter/material.dart';
import 'logger.dart';
import 'notification_utils.dart';

class ErrorHandler {
  static void handleError(
    BuildContext context,
    String operation,
    Object error, [
    StackTrace? stackTrace,
  ]) {
    Logger.error('Error during $operation', error, stackTrace);
    
    String userMessage;
    if (error.toString().contains('database')) {
      userMessage = 'Database error occurred. Please try again.';
    } else if (error.toString().contains('permission')) {
      userMessage = 'Permission denied. Please check app permissions.';
    } else {
      userMessage = 'An error occurred. Please try again.';
    }
    
    NotificationUtils.showError(context, userMessage);
  }

  static void handleDatabaseError(
    BuildContext context,
    String operation,
    Object error,
  ) {
    Logger.error('Database error during $operation', error);
    NotificationUtils.showError(
      context,
      'Failed to $operation. Please try again.',
    );
  }

  static void handleNetworkError(BuildContext context, Object error) {
    Logger.error('Network error', error);
    NotificationUtils.showError(
      context,
      'Network error. Please check your connection.',
    );
  }
}
