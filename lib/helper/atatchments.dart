import 'package:flutter/material.dart';
import 'package:interior_v_1/helper/custome_colour.dart';
import 'package:interior_v_1/helper/web_view.dart';

class Attachments extends StatefulWidget {
  @override
  _AttachmentsState createState() => _AttachmentsState();
}

class _AttachmentsState extends State<Attachments> {
  bool _showDialog = false;

  // void _openWebView(BuildContext context) async {
  //   setState(() {
  //     _showDialog = false;
  //   });
  //
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => WebViewScreen(url: 'https://www.google.com/'),
  //     ),
  //   );
  //
  //   if (result == true) {
  //     setState(() {
  //       _showDialog = true;
  //     });
  //   }
  // }

  void _openWebView(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(url: 'https://www.google.com/'),
      ),
    );

    if (result == true) {
      _showAcceptRejectDialog(context);
    }
  }

  void _showAcceptRejectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Do You Want to Approve Designs?',textAlign: TextAlign.center,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: CustomColors.orangeColorWithShade),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle Accept action
              },
              child: const Text('Accept',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.green),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle Reject action
              },
              child: const Text('Reject',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.red),),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web View Example',style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _openWebView(context),
          child: Text('Open URL'),
        ),
      ),
      // floatingActionButton: _showDialog
      //     ? FloatingActionButton.extended(
      //   onPressed: () => _showAcceptRejectDialog(context),
      //   label: Text('Accept/Reject'),
      // )
      //     : null,
    );
  }
}
