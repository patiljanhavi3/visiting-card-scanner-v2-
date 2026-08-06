class TextParser {
  static final RegExp _emailRegex = RegExp(
    r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b',
    caseSensitive: false,
  );

  static final RegExp _phoneRegex = RegExp(
    r'(\+?\d{1,4}[\s.-]?)?(\(?\d{2,4}\)?[\s.-]?)?\d{3,4}[\s.-]?\d{3,4}',
    caseSensitive: false,
  );

  static final List<String> _companyKeywords = [
    'pvt','ltd','limited','inc','incorporated','corp','corporation','llc','company','co.',
    'technologies','technology','tech','solutions','group','enterprises','industries','services',
    'consulting','systems','software','digital','labs','studio','agency','partners',
  ];

  static final List<String> _designationKeywords = [
    'manager','director','ceo','cto','cfo','coo','founder','co-founder','president','vp','head',
    'lead','senior','junior','principal','architect','engineer','developer','designer','analyst',
    'consultant','specialist','coordinator','executive','assistant','associate','officer',
    'administrator','supervisor','team lead',
  ];

  static final List<String> _addressKeywords = [
    'street','st','st.','road','rd','rd.','avenue','ave','ave.','boulevard','blvd','blvd.',
    'lane','ln','ln.','drive','dr','dr.','building','bldg','floor','suite','unit','apt','apartment',
    'plaza','tower','complex','sector','block','phase','plot','house','city','state','pin','pincode',
    'zip','zipcode','country',
  ];

  // ✅ Add validation methods
  static bool isValidEmail(String email) {
    return _emailRegex.hasMatch(email.trim());
  }

  static bool isValidPhone(String phone) {
    return _phoneRegex.hasMatch(phone.trim());
  }

  static Map<String, String?> parseBusinessCard(String rawText) {
    final lines = rawText
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    if (lines.isEmpty) return {
      'name': null,'phone': null,'email': null,'company': null,'designation': null,'address': null,
    };

    String? name;
    String? phone;
    String? email;
    String? company;
    String? designation;
    final List<String> addressLines = [];
    final Set<int> usedLineIndices = {};

    // 1️⃣ Extract email and phone first
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (email == null && _emailRegex.hasMatch(line)) {
        email = _emailRegex.firstMatch(line)?.group(0);
        usedLineIndices.add(i);
        continue;
      }
      if (phone == null && _phoneRegex.hasMatch(line)) {
        phone = _phoneRegex.firstMatch(line)?.group(0)?.trim();
        usedLineIndices.add(i);
        continue;
      }
    }

    // 2️⃣ Designation
    for (int i = 0; i < lines.length; i++) {
      if (usedLineIndices.contains(i)) continue;
      if (designation == null && _containsDesignationKeyword(lines[i].toLowerCase())) {
        designation = lines[i];
        usedLineIndices.add(i);
      }
    }

    // 3️⃣ Company
    for (int i = 0; i < lines.length; i++) {
      if (usedLineIndices.contains(i)) continue;
      if (company == null && _containsCompanyKeyword(lines[i].toLowerCase())) {
        company = lines[i];
        usedLineIndices.add(i);
      }
    }

    // 4️⃣ Address
    for (int i = 0; i < lines.length; i++) {
      if (usedLineIndices.contains(i)) continue;
      if (_looksLikeAddress(lines[i])) {
        addressLines.add(lines[i]);
        usedLineIndices.add(i);
      }
    }

    // 5️⃣ Name detection
    for (int i = 0; i < lines.length; i++) {
      if (usedLineIndices.contains(i)) continue;
      if (name == null && _looksLikeName(lines[i])) {
        name = lines[i];
        usedLineIndices.add(i);
        break;
      }
    }

    // 6️⃣ Fallback for name
    if (name == null && lines.isNotEmpty) {
      name = lines[0];
      usedLineIndices.add(0);
    }

    // 7️⃣ Remaining lines to address
    for (int i = 0; i < lines.length; i++) {
      if (!usedLineIndices.contains(i)) addressLines.add(lines[i]);
    }

    return {
      'name': name,
      'phone': phone,
      'email': email,
      'company': company,
      'designation': designation,
      'address': addressLines.isNotEmpty ? addressLines.join(', ') : null,
    };
  }

  static bool _containsCompanyKeyword(String text) =>
      _companyKeywords.any((k) => text.contains(k));

  static bool _containsDesignationKeyword(String text) =>
      _designationKeywords.any((k) => text.contains(k));

  static bool _containsAddressKeyword(String text) =>
      _addressKeywords.any((k) => text.contains(k));

  static bool _looksLikeAddress(String text) {
    final hasNumbers = RegExp(r'\d').hasMatch(text);
    final hasComma = text.contains(',');
    final wordCount = text.split(' ').length;
    return (hasNumbers && wordCount >= 3) || (hasComma && wordCount >= 4) || _containsAddressKeyword(text.toLowerCase());
  }

  static bool _looksLikeName(String text) {
    final words = text.split(' ');
    if (words.length < 2 || words.length > 5) return false;
    if (RegExp(r'\d').hasMatch(text)) return false;
    if (_emailRegex.hasMatch(text) || _phoneRegex.hasMatch(text)) return false;
    final lower = text.toLowerCase();
    if (_containsCompanyKeyword(lower) || _containsDesignationKeyword(lower) || _containsAddressKeyword(lower)) return false;
    return true;
  }
}
