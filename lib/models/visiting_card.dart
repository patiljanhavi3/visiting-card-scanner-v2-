import 'dart:convert';

class VisitingCard {
  final String id;

  final String name;
  final String designation;
  final String company;

  final List<String> emails;
  final List<String> phones;

  final String mobile;
  final String officePhone;
  final String fax;

  final String website;
  final String linkedin;
  final String whatsapp;

  final String address;
  final String city;
  final String state;
  final String country;
  final String postalCode;

  final String notes;

  final DateTime createdAt;

  const VisitingCard({
    required this.id,
    required this.name,
    required this.designation,
    required this.company,
    required this.emails,
    required this.phones,
    required this.mobile,
    required this.officePhone,
    required this.fax,
    required this.website,
    required this.linkedin,
    required this.whatsapp,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.notes,
    required this.createdAt,
  });

  factory VisitingCard.empty() {
    return VisitingCard(
      id: "",
      name: "",
      designation: "",
      company: "",
      emails: const [],
      phones: const [],
      mobile: "",
      officePhone: "",
      fax: "",
      website: "",
      linkedin: "",
      whatsapp: "",
      address: "",
      city: "",
      state: "",
      country: "",
      postalCode: "",
      notes: "",
      createdAt: DateTime.now(),
    );
  }

  factory VisitingCard.fromJson(Map<String, dynamic> json) {
    return VisitingCard(
      id: json["id"]?.toString() ?? "",

      name: json["name"]?.toString() ?? "",
      designation: json["designation"]?.toString() ?? "",
      company: json["company"]?.toString() ?? "",

      emails: List<String>.from(json["emails"] ?? const []),
      phones: List<String>.from(json["phones"] ?? const []),

      mobile: json["mobile"]?.toString() ?? "",
      officePhone: json["office_phone"]?.toString() ?? "",
      fax: json["fax"]?.toString() ?? "",

      website: json["website"]?.toString() ?? "",
      linkedin: json["linkedin"]?.toString() ?? "",
      whatsapp: json["whatsapp"]?.toString() ?? "",

      address: json["address"]?.toString() ?? "",
      city: json["city"]?.toString() ?? "",
      state: json["state"]?.toString() ?? "",
      country: json["country"]?.toString() ?? "",
      postalCode: json["postal_code"]?.toString() ?? "",

      notes: json["notes"]?.toString() ?? "",

      createdAt:
          DateTime.tryParse(json["created_at"]?.toString() ?? "") ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,

      "name": name,
      "designation": designation,
      "company": company,

      "emails": emails,
      "phones": phones,

      "mobile": mobile,
      "office_phone": officePhone,
      "fax": fax,

      "website": website,
      "linkedin": linkedin,
      "whatsapp": whatsapp,

      "address": address,
      "city": city,
      "state": state,
      "country": country,
      "postal_code": postalCode,

      "notes": notes,

      "created_at": createdAt.toIso8601String(),
    };
  }

  VisitingCard copyWith({
    String? id,
    String? name,
    String? designation,
    String? company,
    List<String>? emails,
    List<String>? phones,
    String? mobile,
    String? officePhone,
    String? fax,
    String? website,
    String? linkedin,
    String? whatsapp,
    String? address,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    String? notes,
    DateTime? createdAt,
  }) {
    return VisitingCard(
      id: id ?? this.id,
      name: name ?? this.name,
      designation: designation ?? this.designation,
      company: company ?? this.company,
      emails: emails ?? this.emails,
      phones: phones ?? this.phones,
      mobile: mobile ?? this.mobile,
      officePhone: officePhone ?? this.officePhone,
      fax: fax ?? this.fax,
      website: website ?? this.website,
      linkedin: linkedin ?? this.linkedin,
      whatsapp: whatsapp ?? this.whatsapp,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String encode() => jsonEncode(toJson());

  factory VisitingCard.decode(String text) {
    return VisitingCard.fromJson(jsonDecode(text));
  }

  @override
  String toString() {
    return '''
VisitingCard(
  name: $name,
  designation: $designation,
  company: $company,
  emails: $emails,
  phones: $phones,
  mobile: $mobile,
  officePhone: $officePhone,
  fax: $fax,
  website: $website,
  linkedin: $linkedin,
  whatsapp: $whatsapp,
  address: $address,
  city: $city,
  state: $state,
  country: $country,
  postalCode: $postalCode
)
''';
  }
}
