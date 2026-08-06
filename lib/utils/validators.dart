class Validators {
  Validators._();

  static String? required(String? value, {String field = "Field"}) {
    if (value == null || value.trim().isEmpty) {
      return "$field is required";
    }

    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final regex = RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

    if (!regex.hasMatch(value.trim())) {
      return "Invalid email address";
    }

    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final phone = value.replaceAll(RegExp(r'[^0-9+]'), '');

    if (phone.length < 7 || phone.length > 15) {
      return "Invalid phone number";
    }

    return null;
  }

  static String? website(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final text = value.startsWith("http") ? value : "https://$value";

    final uri = Uri.tryParse(text);

    if (uri == null || !uri.hasAuthority) {
      return "Invalid website";
    }

    return null;
  }

  static bool isEmail(String value) {
    return email(value) == null;
  }

  static bool isPhone(String value) {
    return phone(value) == null;
  }

  static bool isWebsite(String value) {
    return website(value) == null;
  }
}
