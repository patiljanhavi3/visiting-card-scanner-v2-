import 'package:flutter/material.dart';

class ValidationService {
  const ValidationService._();

  /// -------------------------
  /// Generic
  /// -------------------------

  static bool isEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  static bool isNotEmpty(String? value) {
    return !isEmpty(value);
  }

  /// -------------------------
  /// Name
  /// -------------------------

  static String? validateName(String? value) {
    if (isEmpty(value)) {
      return 'Name is required.';
    }

    if (value!.trim().length < 2) {
      return 'Name must be at least 2 characters.';
    }

    return null;
  }

  /// -------------------------
  /// Company
  /// -------------------------

  static String? validateCompany(String? value) {
    if (isEmpty(value)) return null;

    if (value!.trim().length < 2) {
      return 'Company name is too short.';
    }

    return null;
  }

  /// -------------------------
  /// Designation
  /// -------------------------

  static String? validateDesignation(String? value) {
    if (isEmpty(value)) return null;

    if (value!.trim().length < 2) {
      return 'Designation is too short.';
    }

    return null;
  }

  /// -------------------------
  /// Email
  /// -------------------------

  static final RegExp _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  static String? validateEmail(String? value) {
    if (isEmpty(value)) return null;

    if (!_emailRegex.hasMatch(value!.trim())) {
      return 'Enter a valid email.';
    }

    return null;
  }

  static String? validateEmails(List<String> emails) {
    for (final email in emails) {
      final error = validateEmail(email);

      if (error != null) {
        return error;
      }
    }

    return null;
  }

  /// -------------------------
  /// Phone
  /// -------------------------

  static final RegExp _phoneRegex = RegExp(r'^[+]?[0-9 ()-]{7,20}$');

  static String? validatePhone(String? value) {
    if (isEmpty(value)) return null;

    if (!_phoneRegex.hasMatch(value!.trim())) {
      return 'Enter a valid phone number.';
    }

    return null;
  }

  static String? validatePhones(List<String> phones) {
    for (final phone in phones) {
      final error = validatePhone(phone);

      if (error != null) {
        return error;
      }
    }

    return null;
  }

  /// -------------------------
  /// Website
  /// -------------------------

  static String? validateWebsite(String? value) {
    if (isEmpty(value)) return null;

    final text = value!.trim().toLowerCase();

    if (text.startsWith("http://") ||
        text.startsWith("https://") ||
        text.startsWith("www.")) {
      return null;
    }

    if (text.contains(".")) {
      return null;
    }

    return 'Enter a valid website.';
  }

  /// -------------------------
  /// LinkedIn
  /// -------------------------

  static String? validateLinkedIn(String? value) {
    if (isEmpty(value)) return null;

    if (!value!.toLowerCase().contains("linkedin")) {
      return 'Enter a valid LinkedIn URL.';
    }

    return null;
  }

  /// -------------------------
  /// WhatsApp
  /// -------------------------

  static String? validateWhatsApp(String? value) {
    return validatePhone(value);
  }

  /// -------------------------
  /// Postal Code
  /// -------------------------

  static String? validatePostalCode(String? value) {
    if (isEmpty(value)) return null;

    if (value!.trim().length < 4) {
      return 'Invalid postal code.';
    }

    return null;
  }

  /// -------------------------
  /// Required Text
  /// -------------------------

  static String? requiredField(String? value, {String field = 'This field'}) {
    if (isEmpty(value)) {
      return '$field is required.';
    }

    return null;
  }

  /// -------------------------
  /// Form Validation
  /// -------------------------

  static bool validateForm(GlobalKey<FormState> key) {
    final form = key.currentState;

    if (form == null) {
      return false;
    }

    return form.validate();
  }
}
