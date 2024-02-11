import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pwidget;
import 'package:pdf/pdf.dart' as pdfw;

void showQRandPrint(Uint8List encodedBytes) async {
  final pwidget.Document document = pwidget.Document();

  final PdfImage image = PdfImage(document.document,
      image: encodedBytes!, width: 120, height: 100);

  document.addPage(pwidget.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pwidget.Context context) {
        return pwidget.Center(
          child: pwidget.Expanded(
            child: pwidget.Image(pwidget.MemoryImage(encodedBytes)),
          ),
        ); // Center
      })); // Page

  // return document.save();
  /////////////////////////////////////////////////////////////
  final bool result =
  await Printing.layoutPdf(onLayout: (PdfPageFormat format) {
    return document.save();
  });
}