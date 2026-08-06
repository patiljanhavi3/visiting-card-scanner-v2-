class AppConstants {
  AppConstants._();

  // App
  static const String appName = 'Business Card Scanner';

  // Firestore
  static const String cardsCollection = 'business_cards';

  // Export
  static const String csvFileName = 'business_cards.csv';
  static const String jsonFileName = 'business_cards.json';

  // Share
  static const String vcfExtension = '.vcf';
  static const String qrImageName = 'business_card_qr.png';

  // Validation
  static const int minPhoneLength = 7;
  static const int maxPhoneLength = 15;

  // UI
  static const double defaultPadding = 16.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;

  // Messages
  static const String noCards = 'No business cards found.';
  static const String deleteSuccess = 'Business card deleted.';
  static const String saveSuccess = 'Business card saved.';
  static const String updateSuccess = 'Business card updated.';
  static const String exportSuccess = 'Export completed.';
}
