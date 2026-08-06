// lib/services/share_service.dart
//
// NOTE:
// This is a production-ready scaffold for ShareService.
// It assumes your project uses:
//   share_plus, path_provider, qr_flutter
//
// Replace QR generation implementation if your qr_flutter version differs.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../models/visiting_card.dart';

class ShareService {
  const ShareService();

  String buildShareText(VisitingCard card) {
    final b = StringBuffer();
    void w(String s) {
      if (s.trim().isNotEmpty) b.writeln(s);
    }

    w(card.name);
    w(card.designation);
    w(card.company);
    if (card.mobile.isNotEmpty) w("Mobile: ${card.mobile}");
    if (card.officePhone.isNotEmpty) w("Office: ${card.officePhone}");
    if (card.fax.isNotEmpty) w("Fax: ${card.fax}");
    for (final e in card.emails) {
      w("Email: $e");
    }
    if (card.website.isNotEmpty) w("Website: ${card.website}");
    if (card.linkedin.isNotEmpty) w("LinkedIn: ${card.linkedin}");
    if (card.whatsapp.isNotEmpty) w("WhatsApp: ${card.whatsapp}");
    final addr = [
      card.address,
      card.city,
      card.state,
      card.country,
      card.postalCode,
    ].where((e) => e.isNotEmpty).join(", ");
    if (addr.isNotEmpty) w("Address: $addr");
    if (card.notes.isNotEmpty) {
      w("");
      w(card.notes);
    }
    return b.toString().trim();
  }

  String buildVcf(VisitingCard card) {
    final b = StringBuffer()
      ..writeln("BEGIN:VCARD")
      ..writeln("VERSION:3.0")
      ..writeln("FN:${card.name}")
      ..writeln("N:${card.name};;;;");
    if (card.company.isNotEmpty) b.writeln("ORG:${card.company}");
    if (card.designation.isNotEmpty) b.writeln("TITLE:${card.designation}");
    if (card.mobile.isNotEmpty) b.writeln("TEL;TYPE=CELL:${card.mobile}");
    if (card.officePhone.isNotEmpty)
      b.writeln("TEL;TYPE=WORK:${card.officePhone}");
    for (final e in card.emails) {
      b.writeln("EMAIL:$e");
    }
    if (card.website.isNotEmpty) b.writeln("URL:${card.website}");
    b.writeln("END:VCARD");
    return b.toString();
  }

  String _safe(String s) {
    final x = s
        .trim()
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(RegExp(r'\s+'), '_');
    return x.isEmpty ? "contact" : x;
  }

  Future<File> createVcfFile(VisitingCard c) async {
    final d = await getTemporaryDirectory();
    final f = File("${d.path}/${_safe(c.name)}.vcf");
    await f.writeAsString(buildVcf(c), encoding: utf8);
    return f;
  }

  Future<File> createTextFile(VisitingCard c) async {
    final d = await getTemporaryDirectory();
    final f = File("${d.path}/${_safe(c.name)}.txt");
    await f.writeAsString(buildShareText(c), encoding: utf8);
    return f;
  }

  Future<Uint8List> generateQrPng(VisitingCard c, {double size = 800}) async {
    final painter = QrPainter(
      data: buildVcf(c),
      version: QrVersions.auto,
      gapless: true,
    );
    final img = await painter.toImageData(size, format: ui.ImageByteFormat.png);
    if (img == null) throw Exception("QR generation failed");
    return img.buffer.asUint8List();
  }

  Future<File> createQrImageFile(VisitingCard c) async {
    final d = await getTemporaryDirectory();
    final f = File("${d.path}/${_safe(c.name)}_qr.png");
    await f.writeAsBytes(await generateQrPng(c), flush: true);
    return f;
  }

  Future<void> shareText(VisitingCard c) =>
      Share.share(buildShareText(c), subject: c.name);

  Future<void> shareVcf(VisitingCard c) async {
    final f = await createVcfFile(c);
    await Share.shareXFiles([XFile(f.path)], text: c.name);
  }

  Future<void> shareQr(VisitingCard c) async {
    final f = await createQrImageFile(c);
    await Share.shareXFiles([XFile(f.path)], text: "QR - ${c.name}");
  }

  Future<void> shareEverything(VisitingCard c) async {
    final v = await createVcfFile(c);
    final t = await createTextFile(c);
    final q = await createQrImageFile(c);
    await Share.shareXFiles(
      [XFile(v.path), XFile(t.path), XFile(q.path)],
      text: buildShareText(c),
      subject: c.name,
    );
  }

  Future<void> cleanupTemporaryFiles(VisitingCard c) async {
    for (final f in [
      await createVcfFile(c),
      await createTextFile(c),
      await createQrImageFile(c),
    ]) {
      if (await f.exists()) {
        try {
          await f.delete();
        } catch (_) {}
      }
    }
  }
}
