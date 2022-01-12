import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({Key? key}) : super(key: key);

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  String _scanBarcode = '0';
  final dbhelper = DatabaseHelper.instance;
  @override
  void initState() {
    super.initState();
  }


  Future<Map<String,dynamic>> getProducts() async{
    List res = await  dbhelper.getProducts() ;
    int idx = int.parse(_scanBarcode);
    for(var u in res) {
      print(u);
    }
    return res[idx];
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
      _scanBarcode = barcodeScanRes;
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
      _scanBarcode = barcodeScanRes;
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
            flex : 3,
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      scanQR();

                    },
                    child: const Text('Start QR scan')),
                Text('Product ID : $_scanBarcode\n',
                    style: const TextStyle(fontSize: 20)),

                ElevatedButton(
                    onPressed: ()async{
                      var res = await getProducts();
                      String prodName = res['product_name'];
                      String manufacturer = res['username'];
                      String price = res['price'];
                      String status = res['status'];
                      String loc1 ;
                      String loc2;
                      getProducts();
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.NO_HEADER,
                        borderSide: const BorderSide(color: Colors.white, width: 2),
                        width: 700,
                        buttonsBorderRadius: const BorderRadius.all(Radius.circular(2)),
                        headerAnimationLoop: true,
                        body: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Product Info",
                                    style: GoogleFonts.robotoSlab(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Product Name : $prodName",
                                style: GoogleFonts.robotoSlab(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Manufactured by : $manufacturer",
                                style: GoogleFonts.robotoSlab(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Price : $price",
                                style: GoogleFonts.robotoSlab(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Status : $status",
                                style: GoogleFonts.robotoSlab(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Last Locations : India",
                                style: GoogleFonts.robotoSlab(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                            ],
                          ),
                        ),
                        animType: AnimType.BOTTOMSLIDE,
                        showCloseIcon: true,
                      ).show();
                    },
                    child: const Text('Start QR scan')),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
