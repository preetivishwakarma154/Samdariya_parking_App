import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:samdriya/SplashScreen.dart';
import 'package:samdriya/constant.dart';
import 'package:http/http.dart' as http;
import 'package:samdriya/login.dart';
import 'package:samdriya/vehicleCheckIn.dart';

class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<Summary> createState() => _SummaryState();
}

Map summaryData = Map();
Map summaryList = Map();

class _SummaryState extends State<Summary> {
  Future SummaryAPI() async {
    try {
      var headers = {
        'x-access-token': '$globalusertoken',
        'Cookie': 'ci_session=66f9cac100970c304030861ad8aa31153089a12e'
      };
      print("api called");
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'http://smalljbp.dpmstech.in/v1/account/get_vehicle_summary'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
       print(await response.stream.bytesToString());
      var data = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        setState(() {
          summaryData = jsonDecode(data);
          summaryList = summaryData['data'];
          print(summaryList);
        });
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    SummaryAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          appBarButton(
            buttonText: "Logout",
            context: context,
            function: Login(),
          ),
          appBarButton(
            buttonText: "Back",
            context: context,
            function: CheckINOut(),
          ),
        ],
      ),
      body: summaryData.isEmpty
          ? Center(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              margin: EdgeInsets.only(right: 20, left: 20, top: 30),
              child: Table(
                border: TableBorder.all(color: Colors.black12),
                columnWidths: const <int, TableColumnWidth>{
                  0: IntrinsicColumnWidth(),
                  1: IntrinsicColumnWidth(),
                  2: IntrinsicColumnWidth(),
                  3: IntrinsicColumnWidth(),
                  4: IntrinsicColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      TableHeading("S.No."),
                      TableHeading("Vehicle Type"),
                      TableHeading("Total"),
                      TableHeading("Amount"),
                      TableHeading("Total Amount"),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      TableData("1"),
                      TableData("Bike"),
                      TableData(
                          summaryData['data']['res_bike']['total_vehicle']),
                      TableData(
                          summaryData['data']['res_bike']['total_amount']),
                      TableData(
                        summaryData['data']['res_bike']['amount'],
                      )
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      TableData("2"),
                      TableData("Car"),
                      TableData(
                          summaryData['data']['res_car']['total_vehicle']),
                      TableData(summaryData['data']['res_car']['total_amount']),
                      TableData(
                        summaryData['data']['res_car']['amount'],
                      )
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      TableData("3"),
                      TableData("VIP Car"),
                      TableData(
                          summaryData['data']['res_vip_car']['total_vehicle']),
                      TableData(
                          summaryData['data']['res_vip_car']['total_amount']),
                      TableData(
                        summaryData['data']['res_vip_car']['amount'],
                      )
                    ],
                  ),
                ],
              ),
            ),

      // SingleChildScrollView(
      //         scrollDirection: Axis.horizontal,
      //         child: DataTable(columns: [
      //           DataColumn(label: Text('S.No')),
      //           DataColumn(label: Text('Vehicle  Type')),
      //           DataColumn(label: Text('Totle Vehicle')),
      //           DataColumn(label: Text('Amount')),
      //           DataColumn(label: Text('Totle Amount')),
      //         ], rows: [
      //           DataRow(cells: [
      //             DataCell(Text('1')),
      //             DataCell(Text('Bike')),
      //             DataCell(
      //                 Text(summaryData['data']['res_bike']['total_vehicle'])),
      //             DataCell(
      //                 Text(summaryData['data']['res_bike']['total_amount'])),
      //             DataCell(Text(summaryData['data']['res_bike']['amount'])),
      //           ]),
      //           DataRow(cells: [
      //             DataCell(Text('1')),
      //             DataCell(Text('Car')),
      //             DataCell(Text(summaryData['data']['res_car']['total_vehicle'])),
      //             DataCell(Text(summaryData['data']['res_car']['total_amount'])),
      //             DataCell(Text(summaryData['data']['res_car']['amount'])),
      //           ]),
      //           DataRow(cells: [
      //             DataCell(Text('1')),
      //             DataCell(Text('VIP Car')),
      //             DataCell(Text(summaryData['data']['res_vip_car']['total_vehicle'])),
      //             DataCell(Text(summaryData['data']['res_vip_car']['total_amount'])),
      //             DataCell(Text(summaryData['data']['res_vip_car']['amount'])),
      //           ])
      //         ]),
      //       )
    );
  }

  Padding TableData(text) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        text,
        style: TextStyle(color: Colors.black87),
      ),
    );
  }

  Center TableHeading(text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }

  buttons(String s, Summary summary) {}
}


// TableRow(
// children: [
// Padding(
// padding: EdgeInsets.all(5.0),
// child: Text(
// summaryList['res_bike']['total_vehicle'],
// textAlign: TextAlign.center),
// ),
// Padding(
// padding: EdgeInsets.all(5.0),
// child: Text(summaryList['res_bike']['total_amount'],
// textAlign: TextAlign.center),
// ),
// Padding(
// padding: EdgeInsets.all(5.0),
// child: Text(summaryList['res_bike']['"amount'],
// textAlign: TextAlign.center),
// ),
// ],
// );
