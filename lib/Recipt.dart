import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
class Recipt extends StatefulWidget {
  const Recipt({super.key});

  @override
  State<Recipt> createState() => _ReciptState();
}

class _ReciptState extends State<Recipt> {
  @override
  void initState() {
    //_launchURL();
    super.initState();
  }
  Widget build(BuildContext context) {

    return Scaffold(
      body:

      PdfPreview(
        build: (format) => _generatePdf(format, "title"),
      ),
    );
  }
}
Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await PdfGoogleFonts.nunitoExtraLight();
  final image = await imageFromAssetBundle('assets/logo.png');


  pdf.addPage(
    pw.Page(
      pageFormat: format,
      build: (context) {
        return pw.Container(
            child: pw.Column(
              children: [
                pw.Center(
                  child: pw.Image(image),
                ),

                pw.Container(

                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                      children: [
                        pw.Text("Vehicle"),
                        pw.Text("Bike"),
                      ]

                  ),
                ),


                pw.SizedBox(
                  width: double.infinity,
                  child: pw.FittedBox(
                    child: pw.Text(title, style: pw.TextStyle(font: font)),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Flexible(child: pw.FlutterLogo())
              ],
            )
        );
      },
    ),
  );


  return pdf.save();
}




