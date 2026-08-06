import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/visiting_card.dart';

class ExportService {
  const ExportService();

  String _stamp() {
    final n = DateTime.now();
    String t(int v) => v.toString().padLeft(2, '0');
    return "${n.year}${t(n.month)}${t(n.day)}_${t(n.hour)}${t(n.minute)}${t(n.second)}";
  }

  String _esc(String s) => '"${s.replaceAll('"', '""')}"';

  Future<File> exportJson(List<VisitingCard> cards) async {
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/business_cards_${_stamp()}.json");
    await file.writeAsString(
      const JsonEncoder.withIndent(
        '  ',
      ).convert(cards.map((e) => e.toJson()).toList()),
      encoding: utf8,
    );
    return file;
  }

  Future<File> exportCsv(List<VisitingCard> cards) async {
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/business_cards_${_stamp()}.csv");
    final b = StringBuffer();
    b.writeln(
      'Name,Designation,Company,Emails,Phones,Mobile,Office,Fax,Website,LinkedIn,WhatsApp,Address,City,State,Country,PostalCode,Notes,CreatedAt',
    );
    for (final c in cards) {
      b.writeln(
        [
          c.name,
          c.designation,
          c.company,
          c.emails.join(';'),
          c.phones.join(';'),
          c.mobile,
          c.officePhone,
          c.fax,
          c.website,
          c.linkedin,
          c.whatsapp,
          c.address,
          c.city,
          c.state,
          c.country,
          c.postalCode,
          c.notes,
          c.createdAt.toIso8601String(),
        ].map((e) => _esc(e.toString())).join(','),
      );
    }
    await file.writeAsString(b.toString(), encoding: utf8);
    return file;
  }

  Future<void> shareJson(List<VisitingCard> cards) async {
    final f = await exportJson(cards);
    await Share.shareXFiles([XFile(f.path)], subject: 'Business Cards JSON');
  }

  Future<void> shareCsv(List<VisitingCard> cards) async {
    final f = await exportCsv(cards);
    await Share.shareXFiles([XFile(f.path)], subject: 'Business Cards CSV');
  }
}
