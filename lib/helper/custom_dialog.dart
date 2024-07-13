import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Dialog Example')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => _showMyDialog(context),
            child: Text('Show Dialog'),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  children: [
                    Icon(Icons.star, size: 50, color: Colors.amber),
                    SizedBox(height: 10),
                    Text(
                      'Payment Request',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text('Client Name :-')),
                    Flexible(child: Text('Sohel Shaikh')),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text('Project Name :-')),
                    Flexible(child: Text('Alpha Tech City')),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text('Client Mob No :-')),
                    Flexible(child: Text('7058143404')),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text('Amount :-')),
                    Flexible(child: Text('Rs.45500/-')),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text('Payment Stage :-')),
                    Flexible(child: Text('3rd')),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text('Payment Type :-')),
                    Flexible(child: Text('Cash')),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text('Date :-')),
                    Flexible(child: Text('15-02-2024')),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text('Received by :-')),
                    Flexible(child: Text('Sohel Shaikh (Sup)')),
                  ],
                ),
                SizedBox(height: 20),
                Text('Received Notes:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                SizedBox(height: 10,),
                SizedBox(
                  height: 100,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Rs.50'),
                          Text('5 Notes'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Rs.100'),
                          Text('10 Notes'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Rs.200'),
                          Text('20 Notes'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Rs.500'),
                          Text('10 Notes'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Rs.2000'),
                          Text('50 Notes'),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton.icon(
                      icon: Icon(Icons.cancel, color: Colors.white),
                      label: Text(
                        'Approve',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        side: BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 10, // Add elevation for shadow
                        shadowColor: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      icon: Icon(Icons.check_circle, color: Colors.white),
                      label: Text(
                        'Decline',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 10, // Add elevation for shadow
                        shadowColor: Colors.black,
                      ),
                      onPressed: () {
                        // Add your decline logic here
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _coloredTextField(Color color) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: color.withOpacity(0.3),
        border: OutlineInputBorder(),
      ),
    );
  }
}

// void main() {
//   runApp(CustomDialog());
// }


// import 'package:flutter/material.dart';
//
// class CustomDialog extends StatelessWidget {
//   const CustomDialog({Key? key}) : super(key: key);
//
//   // Define a static method to show the dialog
//   static Future<void> showMyDialog(BuildContext context) async {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(20.0)),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Column(
//                   children: [
//                     Icon(Icons.star, size: 50, color: Colors.amber),
//                     SizedBox(height: 10),
//                     Text(
//                       'Payment Request',
//                       style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blueAccent),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Flexible(child: Text('Client Name :-')),
//                     Flexible(child: Text('Sohel Shaikh')),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Flexible(child: Text('Project Name :-')),
//                     Flexible(child: Text('Alpha Tech City')),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Flexible(child: Text('Client Mob No :-')),
//                     Flexible(child: Text('7058143404')),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Flexible(child: Text('Amount :-')),
//                     Flexible(child: Text('Rs.45500/-')),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Flexible(child: Text('Payment Stage :-')),
//                     Flexible(child: Text('3rd')),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Flexible(child: Text('Payment Type :-')),
//                     Flexible(child: Text('Cash')),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Flexible(child: Text('Date :-')),
//                     Flexible(child: Text('15-02-2024')),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Flexible(child: Text('Received by :-')),
//                     Flexible(child: Text('Sohel Shaikh (Sup)')),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 Text('Received Notes:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
//                 SizedBox(height: 10,),
//                 SizedBox(
//                   height: 100,
//                   child: ListView(
//                     shrinkWrap: true,
//                     children: <Widget>[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('Rs.50'),
//                           Text('5 Notes'),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('Rs.100'),
//                           Text('10 Notes'),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('Rs.200'),
//                           Text('20 Notes'),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('Rs.500'),
//                           Text('10 Notes'),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('Rs.2000'),
//                           Text('50 Notes'),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     ElevatedButton.icon(
//                       icon: Icon(Icons.cancel, color: Colors.white),
//                       label: Text(
//                         'Approve',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 17,
//                             color: Colors.white),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         side: BorderSide(color: Colors.grey),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         elevation: 10, // Add elevation for shadow
//                         shadowColor: Colors.black,
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                     SizedBox(width: 10),
//                     ElevatedButton.icon(
//                       icon: Icon(Icons.check_circle, color: Colors.white),
//                       label: Text(
//                         'Decline',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 17,
//                             color: Colors.white),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.redAccent,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         elevation: 10, // Add elevation for shadow
//                         shadowColor: Colors.black,
//                       ),
//                       onPressed: () {
//                         // Add your decline logic here
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }

// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Dialog Example'),
//         ),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () {
//               CustomDialog.showMyDialog(context);
//             },
//             child: Text('Show Dialog'),
//           ),
//         ),
//       ),
//     );
//   }
// }
