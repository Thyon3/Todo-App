import '../constants/app_constants.dart';

class Validators {
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }
    if (value.trim().length > AppConstants.maxTitleLength) {
      return 'Title must be less than ${AppConstants.maxTitleLength} characters';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value != null && value.length > AppConstants.maxDescriptionLength) {
      return 'Description must be less than ${AppConstants.maxDescriptionLength} characters';
    }
    return null;
  }

  static String? validateNotes(String? value) {
    if (value != null && value.length > AppConstants.maxNotesLength) {
      return 'Notes must be less than ${AppConstants.maxNotesLength} characters';
    }
    return null;
  }

  static String? validateCategoryName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Category name is required';
    }
    if (value.trim().length < 2) {
      return 'Category name must be at least 2 characters';
    }
    if (value.trim().length > 30) {
      return 'Category name must be less than 30 characters';
    }
    return null;
  }

  static String? validateTag(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tag cannot be empty';
    }
    if (value.trim().length > 20) {
      return 'Tag must be less than 20 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Tag can only contain letters, numbers, and underscores';
    }
    return null;
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
