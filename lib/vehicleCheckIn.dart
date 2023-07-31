import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import 'package:samdriya/InputBox.dart';
import 'package:samdriya/Recipt.dart';
import 'package:samdriya/SplashScreen.dart';
import 'package:samdriya/Summary.dart';
import 'package:samdriya/UserLogin.dart';
import 'package:samdriya/constant.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

enum Value { Bike, Car, VIP_Car }

class CheckINOut extends StatefulWidget {
  const CheckINOut({super.key});

  @override
  State<CheckINOut> createState() => _CheckINOutState();
}

Map checkInData = Map();
Map reciptData = Map();
var _timer;

class _CheckINOutState extends State<CheckINOut> {
  var _error;

  var nameerror;

  var valuerror;
  String? newusername;

  bool? isapicalled = false;

  var amount;

  String? vehicleType;

  String? numbererror;

  var newusernumber;
  _DialogBox()async {
     await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.topCenter,
          scrollable: true,
          title: const Text("Vehicle Check In"),
          content: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                SizedBox(
                  height: 20,
                ),
                Text("Vehical Type : " + vehicleType!),
                SizedBox(
                  height: 30,
                ),
                Text("Vehical Amount : " + amount),
                Divider(),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColorBlue),
                    child: const Text(
                      "Yes",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      newusernumber==null?
                      CheckIN(newusername, _value,
                      ''):
                      CheckIN(newusername, _value,
                          newusernumber);




                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

  }

  Future CheckIN(vehicle_number, vehicle_type, mobile_no) async {
    try {
      var headers = {
        'x-access-token':
            'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiaWF0IjoxNjkwMDMxNTUzfQ.eP5pM_LThjVdnoBOTJcmIjTwIN66ijoMzdE6dREoVew',
        'Cookie': 'ci_session=15e2ca751bd413d1ea2822611b865217982377f2'
      };
      var request = http.MultipartRequest('POST',
          Uri.parse('http://smalljbp.dpmstech.in/v1/account/vehicle_check_in'));
      request.fields.addAll({
        'vehicle_number': '$vehicle_number',
        'vehicle_type': '$vehicle_type',
        'mobile_no': '$mobile_no'
      });
      print('$vehicle_type,$vehicle_number,$mobile_no');

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      isapicalled = true;
      var data = await response.stream.bytesToString();
      checkInData = jsonDecode(data);
      if (response.statusCode == 200) {



        if (checkInData['status'] == 1) {
          setState(() {
            reciptAPI(checkInData['data']['check_in_id']);
          });
          Navigator.pop(context);






         
        }
      } else {
        setState(() {
          _error = checkInData['message'];
        });
      }
    } catch (e) {
      print(e);
    }
  }
  Future reciptAPI(check_in_id) async {
    try {
      var headers = {
        'x-access-token':
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiaWF0IjoxNjkwMDMxNTUzfQ.eP5pM_LThjVdnoBOTJcmIjTwIN66ijoMzdE6dREoVew',
        'Cookie': 'ci_session=6ab94e5e9ed87b3fe01eaf7140c283c4e2992216'
      };
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'http://smalljbp.dpmstech.in/v1/account/get_vehicle_check_in_data'));
      request.fields.addAll({'check_in_id': '$check_in_id'});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(check_in_id);
      var data = await response.stream.bytesToString();
      reciptData = jsonDecode(data);
      if (response.statusCode == 200) {


        print(reciptData);
        if (reciptData['status'] == 1) {
          await  _generatePdf();

          
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CheckINOut(),));
          

        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
  }

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  var _value;
  var _key;

  void _deletetoken() async {
    print('running');
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.remove('token');
    setState(() {
      _key = key;
    });
    print('YOUR KEY - "$key"');
    print('key deleted');
  }
@override
  void dispose() {
  _value = null;

  newusernumber= null;
  newusername= null;

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 20, bottom: 5),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: ThemeColorRed),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Summary(),
                      ));
                },
                child: Text(
                  "Summary",
                  style: TextStyle(color: Colors.white),
                )),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20, right: 30, bottom: 5,),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: ThemeColorRed),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: new Text('Are you sure?'),
                      content: new Text('Do you want to Logout'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pop(false), //<-- SEE HERE
                          child: new Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            _deletetoken();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (BuildContext context) => UserLogin()),
                                ModalRoute.withName('/')
                            );
                          }, // <-- SEE HERE
                          child: new Text('Yes'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(

          padding: EdgeInsets.only(top: 20,bottom: 20,left: 5,right: 5),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black12, width: 1, style: BorderStyle.solid)),
          margin: EdgeInsets.only(top: 15, right: 20, left: 15, bottom: 20,),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Vehicle Check In/Out',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(
                          'Bike',
                          style: radioButtonText,
                        ),
                        leading: Radio<String>(
                          value: '1',
                          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                          groupValue: _value,
                          onChanged: (value) {
                            setState(() {
                              _value = value;
                              amount = '20';
                              vehicleType = 'Bike';
                            });
                          },
                        ),
                      )),
                      Expanded(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: Text(
                            'Car',
                            style: radioButtonText,
                          ),
                          leading: Radio<String>(
                            value: '2',
                            groupValue: _value,
                              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                            onChanged: (value) {
                              setState(() {
                                _value = value!;
                                amount = '50';
                                vehicleType = 'Car';
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: Text(
                            'VIP Car',
                            style: radioButtonText,
                          ),
                          leading: Radio(
                            value: "3",
                            groupValue: _value,
                            onChanged: (value) {
                              setState(() {
                                _value = value;
                                amount = '100';
                                vehicleType = 'VIP Car';
                              });
                              //debugPrint(_value!.name);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                if (_value == null && isapicalled == true)
                  Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 10.0),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(0),
                          child: Row(
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: Text(
                                    "Vehicle Type can't be empty",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 13),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 30,right: 20,left: 20),
                  child: Text(
                    "Vehicle",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                Container(
                    height: 40,
                    margin: EdgeInsets.only(
                      bottom: 15,
                      right: 20,
                      left: 20,
                      top: 8,
                    ),
                    child: TextFormField(
                        initialValue: newusername,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value!.isEmpty) {
                            setState(() {
                              nameerror = "Vehicle number can't be empty";
                            });
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            nameerror = null;
                            newusername = value;
                          });
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                              left: 12,
                            ),
                            hintText: "Enter Vehicle Number",
                            hintStyle: TextStyle(
                              fontSize: 14,
                            ),
                            prefix: SizedBox(
                              height: 20,
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black))))),
                if (nameerror != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 10.0),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(0),
                          child: Row(
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: Text(
                                    "$nameerror",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 13),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
                  child: Text(
                    "Mobile Number",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                Container(
                    height: 40,
                    margin: EdgeInsets.only(
                      bottom: 15,
                      right: 20,
                      left: 20,
                      top: 8,
                    ),
                    child: TextFormField(
                        initialValue: newusername,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10)
                        ],

                        validator: (value) {
                          setState(() {
                            if (value == null || value.isEmpty) {


                            }else if (value.length < 10) {
                              numbererror =
                              "Please enter full 10 digit number";
                            }
                          });




                          if (value!.contains(',')) {
                            numbererror =
                            "Invalid input. Please enter numbers only";
                          }
                          if (value.contains('.')) {
                            numbererror =
                            "Invalid input. Please enter numbers only";
                          }
                          if (value.contains('-')) {
                            numbererror =
                            "Invalid input. Please enter numbers only";
                          }
                          if (value.contains(' ')) {
                            numbererror =
                            "Invalid input. Please enter numbers only without any spaces";
                          }


                        },
                        onChanged: (value) {
                          setState(() {
                            numbererror = null;
                            newusernumber = value;

                          });
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                              left: 12,
                            ),
                            hintText: "Enter Mobile Number",
                            hintStyle: TextStyle(
                              fontSize: 14,
                            ),
                            prefix: SizedBox(
                              height: 20,
                            ),

                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black))))),
                if (numbererror != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 10.0),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(0),
                          child: Row(
                            children: [
                              Container(
                                  width:
                                  MediaQuery.of(context).size.width - 100,
                                  child: Text(
                                    "$numbererror",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 13),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),



                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 8),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeColorGreen,
                      ),
                      onPressed: () {
                        if (formkey.currentState!.validate()) {}
                        if (_value == null) {
                          isapicalled = true;
                        } else if (nameerror == null && numbererror==null) {
                          _DialogBox();

                        }

                      },

                      //_generatePdf();

                      child: Text(
                        "Check In",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}



_generatePdf() async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await PdfGoogleFonts.nunitoExtraLight();
  final image = await imageFromAssetBundle('assets/logo.png');

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Container(
            height: 550,

            padding: pw.EdgeInsets.only(left: 5, right: 5,top: 10),
            decoration: pw.BoxDecoration(
                border: pw.Border.all(
                    color: PdfColors.grey,
                    style: pw.BorderStyle.solid,
                    width: 1)),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Image(image, height: 120),
                pw.Text(reciptData['data']['vehicle'],
                    style: pw.TextStyle(
                      fontSize: 48,
                    )),
                pw.SizedBox(height: 10),
                pw.Text(reciptData['data']['vehicle_no'],
                    style: pw.TextStyle(
                      fontSize: 48,
                    )),
                pw.SizedBox(height: 10),
                pw.Text(reciptData['data']['check_in_time'],
                    style: pw.TextStyle(fontSize: 48)),
                pw.SizedBox(height: 10),
                pw.Text(reciptData['data']['entry_charge'],

                    style: pw.TextStyle(fontSize: 48)),
                pw.SizedBox(height: 10),
                pw.Text(reciptData['data']['mobileno']==null?'':reciptData['data']['mobileno'],
                    style: pw.TextStyle(fontSize: 48)),
                pw.SizedBox(height: 25),
                pw.Align(
                    alignment: pw.Alignment.bottomCenter,
                    child: pw.Text("Thank you, visit again",
                        style: pw.TextStyle(fontSize: 28))),
              ],
            ));
      },
    ),
  );
  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save());
}

class appBarButton extends StatelessWidget {
  const appBarButton({
    super.key,
    required this.context,
    required this.buttonText,
    required this.function,
  });
  final String buttonText;
  final Widget function;

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 20, bottom: 5),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: ThemeColorRed),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => function,
                ));
          },
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}
