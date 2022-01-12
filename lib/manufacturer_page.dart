import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'database_helper.dart';

class ManufacturerPage extends StatefulWidget {
  ManufacturerPage(this.username, {Key? key}) : super(key: key);
  String username;

  @override
  State<ManufacturerPage> createState() => _ManufacturerPageState();
}

class _ManufacturerPageState extends State<ManufacturerPage> {
  late String productName;

  late int product_id;
  late String productPrice;
  late String location1;

  final dbhelper = DatabaseHelper.instance;

  Future<int> getProductCount() async {
    List allrows = await dbhelper.queryAllProduct();
    return allrows.length;
  }
  void getLocations() async {
    List allrows = await dbhelper.getLocations();
    for(var u in allrows)
      {
        print(u);
      }
  }
  void insertLocation1(int prodID,String loc1) async
  {

    Map<String, dynamic> row = {
      DatabaseHelper.columnProductId:prodID,
      DatabaseHelper.columnLocation1:loc1,
    };
    final id = await dbhelper.insertLocation(row);
    print(id);
  }
  void insertProduct() async {
    product_id = await getProductCount() + 1;
    Map<String, dynamic> row = {
      DatabaseHelper.columnProductId: product_id,
      DatabaseHelper.columnProductName: productName,
      DatabaseHelper.columnProductPrice: productPrice,
      DatabaseHelper.columnUsername: widget.username,
      DatabaseHelper.columnStatus: 'manufactured',
    };
    final id = await dbhelper.insertProduct(row);
    print(id);
  }

  void printAllProduct() async
  {
    var allrows = await dbhelper.queryAllProduct();
    allrows.forEach((row) {
      print(row);
    });
  }

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
                      productName = value;
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
                        hintText: "Enter Product Name"),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: TextField(
                    onChanged: (value) {
                      productPrice = value;
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
                        hintText: "Enter Product Price"),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: TextField(
                    onChanged: (value) {
                      location1 = value;
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
                        hintText: "Enter Current Location"),
                  ),
                ),

                RaisedButton(
                  elevation: 0,
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () async{
                    insertProduct();
                    printAllProduct();
                    product_id = await getProductCount() ;
                    insertLocation1(product_id, location1);
                    getLocations();
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.SUCCES,
                      borderSide: const BorderSide(color: Colors.white, width: 2),
                      width: 280,
                      buttonsBorderRadius: const BorderRadius.all(Radius.circular(2)),
                      headerAnimationLoop: true,
                      body: Column(
                        children: [
                          const Text(
                            "Item Added Successfully!",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          QrImage(
                            data:product_id.toString(),
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                        ],
                      ),
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'INFO',
                      desc: 'Item Added Successfully!',
                      showCloseIcon: true,
                    ).show();
                  },
                  child: Center(
                    child: Text(
                      "SUBMIT",
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
