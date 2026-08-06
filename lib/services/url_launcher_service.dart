import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  const UrlLauncherService();

  Future<void> callPhone(BuildContext context, String phone) async {
    await _launch(context, "tel:${phone.trim()}", "Unable to make phone call.");
  }

  Future<void> sendSms(BuildContext context, String phone) async {
    await _launch(context, "sms:${phone.trim()}", "Unable to send SMS.");
  }

  Future<void> sendEmail(
    BuildContext context, {
    required String email,
    String subject = "",
    String body = "",
  }) async {
    final uri = Uri(
      scheme: "mailto",
      path: email.trim(),
      queryParameters: {
        if (subject.isNotEmpty) "subject": subject,
        if (body.isNotEmpty) "body": body,
      },
    );

    await _launchUri(context, uri, "Unable to open email application.");
  }

  Future<void> openWebsite(BuildContext context, String website) async {
    String url = website.trim();

    if (url.isEmpty) return;

    if (!url.startsWith("http://") && !url.startsWith("https://")) {
      url = "https://$url";
    }

    await _launch(context, url, "Unable to open website.");
  }

  Future<void> openLinkedIn(BuildContext context, String url) async {
    await openWebsite(context, url);
  }

  Future<void> openWhatsApp(BuildContext context, String phone) async {
    final clean = phone.replaceAll(RegExp(r"[^\d+]"), "");

    await _launch(context, "https://wa.me/$clean", "Unable to open WhatsApp.");
  }

  Future<void> openMaps(BuildContext context, String address) async {
    final uri = Uri.encodeFull(
      "https://www.google.com/maps/search/?api=1&query=$address",
    );

    await _launch(context, uri, "Unable to open Maps.");
  }

  Future<void> _launch(BuildContext context, String url, String error) async {
    final uri = Uri.parse(url);

    await _launchUri(context, uri, error);
  }

  Future<void> _launchUri(BuildContext context, Uri uri, String error) async {
    try {
      final success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!success && context.mounted) {
        _showError(context, error);
      }
    } catch (_) {
      if (context.mounted) {
        _showError(context, error);
      }
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
