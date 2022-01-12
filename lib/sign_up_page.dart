import 'package:finalproject/database_helper.dart';
import 'package:finalproject/shipper_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'customer_page.dart';
import 'login_page.dart';
import 'manufacturer_page.dart';


class SignUpPage extends StatefulWidget {
  //ignore

  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var segmentedControlGroupValue = 0;
  String username = 'null';
  String password = 'null';
  String role = "consumer";
  String confirmPassword = 'null';

  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("Consumer"),
    1: Text("Manufacturer"),
    2: Text("Shipper")
  };
  final dbhelper = DatabaseHelper.instance;

  void insertData() async{
    Map<String,dynamic> row= {
       DatabaseHelper.columnUsername :username,
       DatabaseHelper.columnPassword : password,
       DatabaseHelper.columnRole : role,

    };
    final id = await dbhelper.insertLogin(row);
    print(id);

  }


  void queryAll() async
  {
    var allrows = await dbhelper.queryAll();
    allrows.forEach((row) {print(row);});
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("DBMS"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Column(),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  CupertinoSlidingSegmentedControl(
                      thumbColor: Colors.blue,
                      groupValue: segmentedControlGroupValue,
                      children: myTabs,
                      onValueChanged: (i) {
                        setState(() {
                          segmentedControlGroupValue = int.parse(i.toString());
                          if(segmentedControlGroupValue==0) {
                            role = 'consumer';
                          } else if(segmentedControlGroupValue==1) {
                            role = 'manufacturer';
                          } else {
                            role = 'shipper';
                          }
                        });
                      }),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: TextField(
                      onChanged: (value) {
                        username = value;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.teal,
                            ),
                          ),
                          prefixIcon: const Icon(Icons.account_circle),
                          hintStyle: GoogleFonts.robotoSlab(
                            fontSize: 18,
                          ),
                          hintText: "Email or Username"),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: TextField(
                      onChanged: (value) {
                        password = value;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.teal,
                            ),
                          ),
                          prefixIcon: const Icon(Icons.password_rounded),
                          hintStyle: GoogleFonts.robotoSlab(
                            fontSize: 18,
                          ),
                          hintText: "New Password"),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: TextField(
                      onChanged: (value) {
                        confirmPassword = value;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.teal,
                            ),
                          ),
                          prefixIcon: const Icon(Icons.password_rounded),
                          hintStyle: GoogleFonts.robotoSlab(
                            fontSize: 18,
                          ),
                          hintText: "Confirm Password"),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  queryAll();
                  if(password == confirmPassword && password !='null') {
                    insertData();
                    Fluttertoast.showToast(
                        msg: "User Created",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                  else
                    {
                      Fluttertoast.showToast(
                          msg: "Password Doesn't Match",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                },
                child: const Text('Submit')),
            Expanded(flex: 1, child: Column(
              children: [ Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: GoogleFonts.robotoSlab(
                      fontSize: 15,
                      color: const Color(0xff767676),
                    ),
                  ),
                  RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: ' Sign in',
                          recognizer: TapGestureRecognizer()..onTap = () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
                          style: GoogleFonts.robotoSlab(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ]))
                ],
              ),
                ],
            ))
          ],
        ),
      ),
    );
  }
}
