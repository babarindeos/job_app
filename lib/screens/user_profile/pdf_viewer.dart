import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class ViewPDF extends StatefulWidget {
  ViewPDF({Key key}) : super(key: key);

  @override
  _ViewPDFState createState() => _ViewPDFState();
}

class _ViewPDFState extends State<ViewPDF> {
  PDFDocument doc;
  @override
  Widget build(BuildContext context) {
    String data = ModalRoute.of(context).settings.arguments;

    void ViewNow() async {
      doc = await PDFDocument.fromURL(data);
      setState(() {});
    }

    Widget loading() {
      ViewNow();
      if (doc == null) {
        return Text('Loading...');
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
        title: Text('PDF CV'),
      ),
      body: doc == null
          ? loading()
          : PDFViewer(
              document: doc,
            ),
    );
  }
}
