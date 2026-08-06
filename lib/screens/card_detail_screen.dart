import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/visiting_card.dart';
import '../repository/card_repository.dart';
import '../services/share_service.dart';
import 'edit_card_screen.dart';

class CardDetailScreen extends StatefulWidget {
  final VisitingCard card;

  const CardDetailScreen({super.key, required this.card});

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  final CardRepository repository = CardRepository();
  final ShareService shareService = ShareService();

  VisitingCard get card => widget.card;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Business Card"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: "Share Text",
            onPressed: () async {
              await shareService.shareText(card);
            },
          ),

          PopupMenuButton<String>(
            onSelected: _handleMenu,
            itemBuilder: (context) => const [
              PopupMenuItem(value: "vcf", child: Text("Share Contact (.vcf)")),

              PopupMenuItem(value: "edit", child: Text("Edit")),

              PopupMenuItem(value: "delete", child: Text("Delete")),
            ],
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(),

            const SizedBox(height: 24),

            _buildActionButtons(),

            const SizedBox(height: 24),

            _sectionTitle("Contact Information"),

            _infoTile(
              icon: Icons.phone_android,
              title: "Mobile",
              value: card.mobile,
              onTap: () => _call(card.mobile),
            ),

            _infoTile(
              icon: Icons.phone,
              title: "Office Phone",
              value: card.officePhone,
              onTap: () => _call(card.officePhone),
            ),

            _infoTile(icon: Icons.print, title: "Fax", value: card.fax),

            for (final phone in card.phones)
              _infoTile(
                icon: Icons.phone,
                title: "Phone",
                value: phone,
                onTap: () => _call(phone),
              ),

            for (final email in card.emails)
              _infoTile(
                icon: Icons.email,
                title: "Email",
                value: email,
                onTap: () => _email(email),
              ),

            _infoTile(
              icon: Icons.language,
              title: "Website",
              value: card.website,
              onTap: () => _openWebsite(card.website),
            ),

            _infoTile(
              icon: Icons.business,
              title: "LinkedIn",
              value: card.linkedin,
              onTap: () => _openWebsite(card.linkedin),
            ),

            _infoTile(
              icon: Icons.chat,
              title: "WhatsApp",
              value: card.whatsapp,
              onTap: () => _openWhatsapp(card.whatsapp),
            ),
            const SizedBox(height: 24),

            _sectionTitle("Address"),

            _infoTile(
              icon: Icons.location_on,
              title: "Address",
              value: card.address,
            ),

            _infoTile(
              icon: Icons.location_city,
              title: "City",
              value: card.city,
            ),

            _infoTile(icon: Icons.map, title: "State", value: card.state),

            _infoTile(
              icon: Icons.public,
              title: "Country",
              value: card.country,
            ),

            _infoTile(
              icon: Icons.markunread_mailbox,
              title: "Postal Code",
              value: card.postalCode,
            ),

            const SizedBox(height: 24),

            _sectionTitle("Notes"),

            if (card.notes.trim().isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(card.notes, style: const TextStyle(fontSize: 15)),
                ),
              ),

            const SizedBox(height: 24),

            Card(
              child: ListTile(
                leading: const Icon(Icons.schedule),
                title: const Text("Created"),
                subtitle: Text(card.createdAt.toString()),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 42,
          child: Text(
            card.name.isEmpty ? "?" : card.name[0].toUpperCase(),
            style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 16),

        Text(
          card.name.isEmpty ? "Unknown" : card.name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),

        if (card.designation.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(card.designation, style: const TextStyle(fontSize: 18)),
          ),

        if (card.company.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              card.company,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        if (card.mobile.isNotEmpty)
          FilledButton.icon(
            icon: const Icon(Icons.call),
            label: const Text("Call"),
            onPressed: () => _call(card.mobile),
          ),

        if (card.emails.isNotEmpty)
          FilledButton.icon(
            icon: const Icon(Icons.email),
            label: const Text("Email"),
            onPressed: () => _email(card.emails.first),
          ),

        if (card.website.isNotEmpty)
          FilledButton.icon(
            icon: const Icon(Icons.language),
            label: const Text("Website"),
            onPressed: () => _openWebsite(card.website),
          ),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    if (value.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),

        title: Text(title),

        subtitle: Text(value),

        onTap: onTap,

        trailing: IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () => _copy(value),
        ),
      ),
    );
  }

  Future<void> _handleMenu(String value) async {
    switch (value) {
      case "vcf":
        await shareService.shareVcf(card);
        break;

      case "edit":
        final updated = await Navigator.push<VisitingCard>(
          context,
          MaterialPageRoute(builder: (_) => EditCardScreen(card: card)),
        );

        if (updated != null) {
          await repository.updateCard(updated);

          if (!mounted) return;

          Navigator.pop(context, updated);
        }
        break;

      case "delete":
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Delete Card"),
            content: const Text(
              "Are you sure you want to delete this business card?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Delete"),
              ),
            ],
          ),
        );

        if (confirm == true) {
          await repository.deleteCard(card.id);

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Business card deleted")),
          );

          Navigator.pop(context, true);
        }
        break;
    }
  }

  Future<void> _copy(String value) async {
    if (value.trim().isEmpty) return;

    await Clipboard.setData(ClipboardData(text: value));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Copied to clipboard"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _call(String phone) async {
    if (phone.trim().isEmpty) return;

    final uri = Uri(scheme: "tel", path: phone);

    await _launch(uri);
  }

  Future<void> _email(String email) async {
    if (email.trim().isEmpty) return;

    final uri = Uri(scheme: "mailto", path: email);

    await _launch(uri);
  }

  Future<void> _openWebsite(String website) async {
    if (website.trim().isEmpty) return;

    String url = website.trim();

    if (!url.startsWith("http://") && !url.startsWith("https://")) {
      url = "https://$url";
    }

    await _launch(Uri.parse(url));
  }

  Future<void> _openWhatsapp(String phone) async {
    if (phone.trim().isEmpty) return;

    final cleaned = phone.replaceAll(RegExp(r'[^0-9+]'), '');

    final uri = Uri.parse("https://wa.me/$cleaned");

    await _launch(uri);
  }

  Future<void> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unable to open ${uri.toString()}")),
      );
    }
  }
}
