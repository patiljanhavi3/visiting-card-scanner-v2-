import 'package:flutter/material.dart';

import '../models/visiting_card.dart';

class EditCardScreen extends StatefulWidget {
  final VisitingCard card;

  const EditCardScreen({super.key, required this.card});

  @override
  State<EditCardScreen> createState() => _EditCardScreenState();
}

class _EditCardScreenState extends State<EditCardScreen> {
  late TextEditingController nameController;
  late TextEditingController designationController;
  late TextEditingController companyController;

  late TextEditingController mobileController;
  late TextEditingController officeController;
  late TextEditingController faxController;

  late TextEditingController emailController;

  late TextEditingController websiteController;
  late TextEditingController linkedinController;
  late TextEditingController whatsappController;

  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController countryController;
  late TextEditingController postalController;

  late TextEditingController notesController;

  @override
  void initState() {
    super.initState();

    final c = widget.card;

    nameController = TextEditingController(text: c.name);

    designationController = TextEditingController(text: c.designation);

    companyController = TextEditingController(text: c.company);

    mobileController = TextEditingController(text: c.mobile);

    officeController = TextEditingController(text: c.officePhone);

    faxController = TextEditingController(text: c.fax);

    emailController = TextEditingController(text: c.emails.join(", "));

    websiteController = TextEditingController(text: c.website);

    linkedinController = TextEditingController(text: c.linkedin);

    whatsappController = TextEditingController(text: c.whatsapp);

    addressController = TextEditingController(text: c.address);

    cityController = TextEditingController(text: c.city);

    stateController = TextEditingController(text: c.state);

    countryController = TextEditingController(text: c.country);

    postalController = TextEditingController(text: c.postalCode);

    notesController = TextEditingController(text: c.notes);
  }

  @override
  void dispose() {
    nameController.dispose();
    designationController.dispose();
    companyController.dispose();

    mobileController.dispose();
    officeController.dispose();
    faxController.dispose();

    emailController.dispose();

    websiteController.dispose();
    linkedinController.dispose();
    whatsappController.dispose();

    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    postalController.dispose();

    notesController.dispose();

    super.dispose();
  }

  Widget buildField(
    String label,
    TextEditingController controller, {
    int lines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: lines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Review Business Card")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              buildField("Name", nameController),

              buildField("Designation", designationController),

              buildField("Company", companyController),

              buildField("Email(s)", emailController),

              buildField("Mobile", mobileController),

              buildField("Office Phone", officeController),

              buildField("Fax", faxController),

              buildField("Website", websiteController),

              buildField("LinkedIn", linkedinController),

              buildField("WhatsApp", whatsappController),

              buildField("Address", addressController, lines: 2),

              buildField("City", cityController),

              buildField("State", stateController),

              buildField("Country", countryController),

              buildField("Postal Code", postalController),

              buildField("Notes", notesController, lines: 3),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("Save Card"),
                  onPressed: () {
                    final updated = VisitingCard(
                      id: widget.card.id,

                      name: nameController.text.trim(),

                      designation: designationController.text.trim(),

                      company: companyController.text.trim(),

                      emails: emailController.text
                          .split(",")
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList(),

                      phones: [
                        mobileController.text.trim(),
                        officeController.text.trim(),
                      ].where((e) => e.isNotEmpty).toList(),

                      mobile: mobileController.text.trim(),

                      officePhone: officeController.text.trim(),

                      fax: faxController.text.trim(),

                      website: websiteController.text.trim(),

                      linkedin: linkedinController.text.trim(),

                      whatsapp: whatsappController.text.trim(),

                      address: addressController.text.trim(),

                      city: cityController.text.trim(),

                      state: stateController.text.trim(),

                      country: countryController.text.trim(),

                      postalCode: postalController.text.trim(),

                      notes: notesController.text.trim(),

                      createdAt: widget.card.createdAt,
                    );

                    Navigator.pop(context, updated);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
