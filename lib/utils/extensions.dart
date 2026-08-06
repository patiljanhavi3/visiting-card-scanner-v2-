import '../models/visiting_card.dart';

extension StringExtension on String {
  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => trim().isNotEmpty;

  String get capitalize {
    if (trim().isEmpty) return this;

    return this[0].toUpperCase() + substring(1);
  }

  String get digitsOnly {
    return replaceAll(RegExp(r'[^0-9]'), '');
  }

  String get normalizedPhone {
    return replaceAll(
      " ",
      "",
    ).replaceAll("-", "").replaceAll("(", "").replaceAll(")", "").trim();
  }

  String get normalizedWebsite {
    return replaceAll("https://", "").replaceAll("http://", "").trim();
  }
}

extension DateExtension on DateTime {
  String get displayDate {
    return "${day.toString().padLeft(2, '0')}/"
        "${month.toString().padLeft(2, '0')}/"
        "$year";
  }

  String get displayDateTime {
    return "${day.toString().padLeft(2, '0')}/"
        "${month.toString().padLeft(2, '0')}/"
        "$year "
        "${hour.toString().padLeft(2, '0')}:"
        "${minute.toString().padLeft(2, '0')}";
  }
}

extension StringListExtension on List<String> {
  String get commaSeparated {
    return where((e) => e.trim().isNotEmpty).join(", ");
  }
}

extension VisitingCardExtension on VisitingCard {
  String get displayName {
    return name.isEmpty ? "Unknown" : name;
  }

  String get primaryEmail {
    return emails.isEmpty ? "" : emails.first;
  }

  String get primaryPhone {
    if (mobile.isNotEmpty) return mobile;

    if (phones.isNotEmpty) return phones.first;

    return "";
  }

  String get subtitle {
    if (designation.isNotEmpty && company.isNotEmpty) {
      return "$designation • $company";
    }

    if (designation.isNotEmpty) {
      return designation;
    }

    return company;
  }

  String get initials {
    if (name.trim().isEmpty) {
      return "?";
    }

    final parts = name.trim().split(" ");

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
