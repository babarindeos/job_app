import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ViewPDF extends StatefulWidget {
  ViewPDF({Key key}) : super(key: key);

  @override
  _ViewPDFState createState() => _ViewPDFState();
}

class _ViewPDFState extends State<ViewPDF> {
  PDFDocument doc;
  bool runSpinner = true;
  String statusMsg = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      runSpinner = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    String data = ModalRoute.of(context).settings.arguments;

    void ViewNow() async {
      try {
        doc = await PDFDocument.fromURL(data);
        setState(() {});
      } catch (e) {
        print(e.toString());
        setState(() {
          statusMsg = e.toString();
        });
      }
    }

    Widget loading() {
      setState(() {
        statusMsg = 'Loading...Please Wait';
      });

      ViewNow();

      if (doc == null) {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitDoubleBounce(color: Colors.blue, size: 100),
            SizedBox(height: 10),
            Text(statusMsg)
          ],
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
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
