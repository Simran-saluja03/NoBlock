import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart';

class ShipperPage extends StatefulWidget {
  const ShipperPage({Key? key}) : super(key: key);

  @override
  State<ShipperPage> createState() => _ShipperPageState();
}

class _ShipperPageState extends State<ShipperPage> {
  late String _barcode;
  late String loc2;
  @override
  void initState() {
    super.initState();
  }
  final dbhelper = DatabaseHelper.instance;
  void insertLocation2(int prodID,String loc2) async
  {
    dbhelper.insertLocation2(prodID,loc2);
  }
  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _barcode = barcodeScanRes;
    });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _barcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(child: Container()),

          Expanded(
            flex: 5,
            child: Column(
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: TextField(
                    onChanged: (value) {
                     loc2 = value;
                    },
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.teal,
                          ),
                        ),
                        hintStyle: GoogleFonts.robotoSlab(
                          fontSize: 18,
                        ),
                        hintText: "Update Location"),
                  ),
                ),
                RaisedButton(
                  elevation: 0,
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    scanQR();
                  },
                  child: Center(
                    child: Text(
                      "Scan Product",
                      style: GoogleFonts.robotoSlab(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),

                RaisedButton(
                  elevation: 0,
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    insertLocation2(int.parse(_barcode), loc2);
                    Fluttertoast.showToast(
                        msg: "Current Location Updated",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  },
                  child: Center(
                    child: Text(
                      "Marked as Shipped",
                      style: GoogleFonts.robotoSlab(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
}
