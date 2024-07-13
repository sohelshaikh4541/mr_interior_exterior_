// import 'package:flutter/material.dart';
// import 'package:barcode_scan2/barcode_scan2.dart';
// import 'package:barcode_widget/barcode_widget.dart';
//
// class ReceiveOrder extends StatefulWidget {
//   @override
//   _ReceiveOrderState createState() => _ReceiveOrderState();
// }
//
// class _ReceiveOrderState extends State<ReceiveOrder> {
//   String _scanResult = '';
//   String _generatedBarcode = '1234567890';
//
//   Future<void> _scanBarcode() async {
//     try {
//       var result = await BarcodeScanner.scan();
//       setState(() {
//         if (_isValidBarcode(result.rawContent)) {
//           _scanResult = 'Valid barcode: ${result.rawContent}';
//         } else {
//           _scanResult = 'Invalid barcode';
//         }
//       });
//     } catch (e) {
//       setState(() {
//         _scanResult = 'Failed to get barcode: $e';
//       });
//     }
//   }
//
//   bool _isValidBarcode(String barcode) {
//     return barcode.startsWith('123');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Receive Order',style: TextStyle(fontWeight: FontWeight.bold),),
//         backgroundColor: Color(0xFFFFA500),
//         elevation: 5,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               SizedBox(height: 30,),
//               Text(
//                 _scanResult.isEmpty ? 'Scan a barcode' : _scanResult,style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               OutlinedButton.icon(
//                 icon: Icon(
//                   Icons.document_scanner,
//                   color: Colors.black,
//                   size: 25,
//                 ),
//                 label: Text(
//                   'Scan Barcode',
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       color: Colors.green),
//                 ),
//                 style: OutlinedButton.styleFrom(
//                   side: BorderSide(
//                       color: Colors.black,),
//                   shape: RoundedRectangleBorder(
//                     borderRadius:
//                     BorderRadius.circular(15),
//                   ),
//                 ),
//                 onPressed: _scanBarcode,
//               ),
//               SizedBox(height: 20),
//               Text('Generated Barcode:'),
//               SizedBox(height: 10),
//               BarcodeWidget(
//                 barcode: Barcode.code128(),
//                 data: _generatedBarcode,
//                 width: 200,
//                 height: 80,
//               ),
//               SizedBox(height: 20),
//               OutlinedButton.icon(
//                 icon: Icon(
//                   Icons.bar_chart,
//                   color: Colors.black,
//                   size: 25,
//                 ),
//                 label: Text(
//                   'Generate New Barcode',
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       color: Colors.blueAccent),
//                 ),
//                 style: OutlinedButton.styleFrom(
//                   side: BorderSide(
//                     color: Colors.black,),
//                   shape: RoundedRectangleBorder(
//                     borderRadius:
//                     BorderRadius.circular(15),
//                   ),
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _generatedBarcode = '123${DateTime.now().millisecondsSinceEpoch}';
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
