import 'package:finalproject/shipper_page.dart';
import 'package:finalproject/sign_up_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'customer_page.dart';
import 'database_helper.dart';
import 'manufacturer_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = 'null';
  String password = 'null';

  final dbhelper = DatabaseHelper.instance;

  void redirect(String username , String password) async
  {
    var user = await dbhelper.redirect(username);

    for(Map<String,dynamic> u in user)
    {
      if(u['role'] == 'consumer' && u['password'] == password) {

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CustomerPage()),
        );
      }
      else if(u['role'] == 'manufacturer' && u['password'] == password)
      {

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  ManufacturerPage(u['username'])),
        );
      }
      else if(u['role'] == 'shipper' && u['password'] == password)
      {

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ShipperPage()),
        );
      }
      else
      {
        Fluttertoast.showToast(
            msg: "User not Found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
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
              flex: 1,
              child: Column(
                children: [
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
                ],
              ),
            ),
            Expanded(flex: 1, child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RaisedButton(
                      elevation: 0,
                      padding: const EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () {
                        if(username == 'null' || password =='null'){
                          Fluttertoast.showToast(
                              msg: "Username or Password Empty",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                        else {
                          redirect(username,password);
                        }
                      },
                      child: Center(
                        child: Text(
                          "Login",
                          style: GoogleFonts.robotoSlab(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: GoogleFonts.robotoSlab(
                            fontSize: 15,
                            color: const Color(0xff767676),
                          ),
                        ),
                        RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: ' Register',
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const SignUpPage()));
                                },
                                style: GoogleFonts.robotoSlab(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ]))
                      ],
                    ),
                  ],
                ),],
            ))
          ],
        ),
      ),
    );
  }
}
