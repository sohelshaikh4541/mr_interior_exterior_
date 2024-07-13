import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:interior_v_1/dummy.dart';
import 'package:interior_v_1/helper/atatchments.dart';
import 'package:interior_v_1/helper/custome_colour.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../api/apiServices.dart';
import '../../helper/custom_dialog.dart';
import '../../model/get_project_members.dart';
import '../../widget/custome_progress_indicator.dart';

class Project_Remind extends StatefulWidget {
  String? client_name,
      project_name,
      address,
      zip,
      state,
      city,
      date,
      package_id,
      price,
      project_id,
      package_name,
      client_mobile_no,
      description;

  Project_Remind(
      {this.client_name,
      this.project_name,
      this.address,
      this.zip,
      this.state,
      this.city,
      this.date,
      this.package_id,
      this.price,
      this.project_id,
      this.package_name,
      this.client_mobile_no,
      this.description});

  @override
  State<Project_Remind> createState() => _Project_RemindState();
}

class _Project_RemindState extends State<Project_Remind>with SingleTickerProviderStateMixin {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  bool isExpanded = false;
  bool isExpandedPay = false;
  bool showTextField = false;
  bool showAttachField = false;
  TextEditingController _descriptionController = TextEditingController();
  Future<List<dynamic>>? futureProfiles;
  String userId = "";
  double _progress = 0.9;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 0.9).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
    loadData();
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  loadData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      userId = sp.getString('userid') ?? '';
      futureProfiles = StatesServices().getProject(userId);
      print(futureProfiles.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Project',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFFA500),
        elevation: 5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ' Project Progress ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              CustomProgressIndicator(progress: 60),
              Transform.translate(
                offset: Offset(0, -60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              ' Project Description ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: w * 0.95,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Color(0x33FFA500),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1, color: Colors.orange.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 12, left: 18),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Project Name :-',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          height: 1.4,
                                        ),
                                      ),
                                      Text(
                                        widget.project_name?.toString() ?? '',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Expanded(
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       Text(
                                //         'Project Id',
                                //         style: TextStyle(
                                //           color: Colors.black,
                                //           fontSize: 16,
                                //           fontFamily: 'Inter',
                                //           fontWeight: FontWeight.w500,
                                //           height: 1.4,
                                //         ),
                                //       ),
                                //       Text(
                                //         '#205',
                                //         style: TextStyle(
                                //           color: Colors.black,
                                //           fontSize: 14,
                                //           fontFamily: 'Inter',
                                //           fontWeight: FontWeight.w500,
                                //           height: 1.4,
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12, left: 18),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Address :-',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          height: 1.4,
                                        ),
                                      ),
                                      Text(
                                        (widget.address?.toString() ?? '') +
                                            ", " +
                                            (widget.city?.toString() ?? '') +
                                            ", " +
                                            (widget.state?.toString() ?? ''),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isExpanded)
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 12, left: 18),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Date :-',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                height: 1.4,
                                              ),
                                            ),
                                            Text(
                                              widget.date?.toString() ?? '',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                                height: 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Project Id :-',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                height: 1.4,
                                              ),
                                            ),
                                            Text(
                                              widget.project_id?.toString() ??
                                                  '',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                                height: 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 12, left: 18),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Package Name :-',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                height: 1.4,
                                              ),
                                            ),
                                            Text(
                                              widget.package_name?.toString() ??
                                                  '',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                                height: 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 12, left: 18),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Price :-',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                height: 1.4,
                                              ),
                                            ),
                                            Text(
                                              (widget.price?.toString() ==
                                                          'null' ||
                                                      widget.price == null)
                                                  ? 'Not Found'
                                                  : widget.price.toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                                height: 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Mobile No :-',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                height: 1.4,
                                              ),
                                            ),
                                            Text(
                                              (widget.client_mobile_no
                                                              ?.toString() ==
                                                          'null' ||
                                                      widget.client_mobile_no ==
                                                          null)
                                                  ? 'Not Found'
                                                  : widget.client_mobile_no
                                                      .toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                                height: 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            child: Text(isExpanded ? 'View Less' : 'View More'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // setState(() {
                              //   showAttachField = !showAttachField;
                              // });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Attachments()),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFFFA500)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'See Attachment',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    showAttachField
                                        ? CupertinoIcons.minus_circle
                                        : CupertinoIcons.plus_circle,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (showAttachField)
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Container(
                          width: w * 0.88,
                          constraints: BoxConstraints(minHeight: 55),
                        ),
                      ),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              ' Payment Details ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: w * 0.95,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Color(0x33FFA500),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1, color: Colors.orange.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Container(
                            width: 300,
                            height: 40,
                            child: LiquidLinearProgressIndicator(
                              value: _animation.value,
                              valueColor: AlwaysStoppedAnimation(CustomColors.orangeColor),
                              backgroundColor: Colors.white,
                              borderColor: CustomColors.orangeColor,
                              borderWidth: 5.0,
                              borderRadius: 12.0,
                              direction: Axis.horizontal,
                              center: Text(
                                '${(_animation.value * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12, left: 18),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total :- Rs.7,08,000.00/- (Inc GST)',
                                        style: TextStyle(
                                          color: Colors.lightBlue.shade900,
                                          fontSize: 16.5,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Payment Stages',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 1,
                            height: 10,
                            indent: 20,
                            endIndent: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5, left: 18),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            '10% on Total (Stage 1)',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                          Text(
                                            'Rs.70,800.00',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          OutlinedButton.icon(
                                            icon: Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 20,
                                            ),
                                            label: Text(
                                              'Paid',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.green),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                  color: Colors.transparent,
                                                  strokeAlign: -15,
                                                  width: 0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 1,
                            height: 10,
                            indent: 20,
                            endIndent: 20,
                          ),
                          if (isExpandedPay)
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 5, left: 18),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  '50% on Total (Stage 2)',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.4,
                                                  ),
                                                ),
                                                Text(
                                                  'Rs.3,54,000.00',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.4,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                OutlinedButton.icon(
                                                  icon: Icon(
                                                    Icons.error_outline,
                                                    color: Colors.red,
                                                    size: 20,
                                                  ),
                                                  label: Text(
                                                    'Over Due',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.red),
                                                  ),
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                        color:
                                                            Colors.transparent,
                                                        strokeAlign: -15,
                                                        width: 0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                  onPressed: () {},
                                                ),
                                                OutlinedButton.icon(
                                                  icon: Icon(
                                                    Icons.send,
                                                    color: Colors.orange,
                                                    size: 20,
                                                  ),
                                                  label: Text(
                                                    'Remind',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.orange),
                                                  ),
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                        color: Colors.orange,
                                                        strokeAlign: -15),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    // elevation: 10, // Add elevation for shadow
                                                    // shadowColor: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                  height: 10,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5, left: 18),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  '25% on Total (Stage 3)',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.4,
                                                  ),
                                                ),
                                                Text(
                                                  'Rs.1,77,000.00',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.4,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                OutlinedButton.icon(
                                                  icon: Icon(
                                                    Icons.pending,
                                                    color: Colors.blue,
                                                    size: 20,
                                                  ),
                                                  label: Text(
                                                    'Pending',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.blue),
                                                  ),
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                        color:
                                                            Colors.transparent,
                                                        strokeAlign: -15,
                                                        width: 0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                  onPressed: () {},
                                                ),
                                                OutlinedButton.icon(
                                                  icon: Icon(
                                                    Icons.send,
                                                    color: Colors.orange,
                                                    size: 20,
                                                  ),
                                                  label: Text(
                                                    'Remind',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.orange),
                                                  ),
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                        color: Colors.orange,
                                                        strokeAlign: -15),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    // elevation: 10, // Add elevation for shadow
                                                    // shadowColor: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                  height: 10,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5, left: 18),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  '10% on Total (Stage 4)',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.4,
                                                  ),
                                                ),
                                                Text(
                                                  'Rs.70,800.00',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.4,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                OutlinedButton.icon(
                                                  icon: Icon(
                                                    Icons.pending,
                                                    color: Colors.blue,
                                                    size: 20,
                                                  ),
                                                  label: Text(
                                                    'Pending',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.blue),
                                                  ),
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                        color:
                                                            Colors.transparent,
                                                        strokeAlign: -15,
                                                        width: 0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                  onPressed: () {},
                                                ),
                                                OutlinedButton.icon(
                                                  icon: Icon(
                                                    Icons.send,
                                                    color: Colors.orange,
                                                    size: 20,
                                                  ),
                                                  label: Text(
                                                    'Remind',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.orange),
                                                  ),
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                        color: Colors.orange,
                                                        strokeAlign: -15),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    // elevation: 10, // Add elevation for shadow
                                                    // shadowColor: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                  height: 10,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5, left: 18),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  '05% on Total (Stage 5)',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.4,
                                                  ),
                                                ),
                                                Text(
                                                  'Rs.35,400.00',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.bold,
                                                    height: 2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                OutlinedButton.icon(
                                                  icon: Icon(
                                                    Icons.pending,
                                                    color: Colors.blue,
                                                    size: 20,
                                                  ),
                                                  label: Text(
                                                    'Pending',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.blue),
                                                  ),
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                        color:
                                                            Colors.transparent,
                                                        strokeAlign: -15,
                                                        width: 0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                  onPressed: () {},
                                                ),
                                                OutlinedButton.icon(
                                                  icon: Icon(
                                                    Icons.send,
                                                    color: Colors.orange,
                                                    size: 20,
                                                  ),
                                                  label: Text(
                                                    'Remind',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.orange),
                                                  ),
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                        color: Colors.orange,
                                                        strokeAlign: -15),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    // elevation: 10, // Add elevation for shadow
                                                    // shadowColor: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isExpandedPay = !isExpandedPay;
                              });
                            },
                            child: Text(isExpandedPay ? 'View Less' : 'View More'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  ' Project Members ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: h * 0.26,
                          child: FutureBuilder<List<dynamic>>(
                            future: futureProfiles,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    var profile = snapshot.data![index];
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        width: w * 0.4,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xFFFFA500),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 5),
                                            CircleAvatar(
                                              radius: h * 0.04,
                                              backgroundImage: NetworkImage(
                                                'https://images.moneycontrol.com/static-mcnews/2024/05/20240522135516_WhatsApp-Image-2024-05-22-at-7.21.46-PM.jpg?impolicy=website&width=770&height=431',
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              profile['client_name'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: h * 0.020,
                                                color: Colors.purple.shade700,
                                              ),
                                            ),
                                            Text(
                                              '${profile['name']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: h * 0.016,
                                                color:
                                                    Colors.blueAccent.shade400,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(Icons.phone,
                                                        size: h * 0.04),
                                                    color: Colors.orange,
                                                  ),
                                                  IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(Icons.message,
                                                        size: h * 0.04),
                                                    color: Colors.orange,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                period: Duration(milliseconds: 1000),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      width: 180,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xFFFFA500), width: 2),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 5),
                                          CircleAvatar(
                                            radius: 40,
                                            backgroundColor: Colors.white,
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            height: 20,
                                            width: 100,
                                            color: Colors.white,
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            height: 20,
                                            width: 100,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  width: 38,
                                                  height: 38,
                                                  color: Colors.white,
                                                ),
                                                Container(
                                                  width: 38,
                                                  height: 38,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showTextField = !showTextField;
                              });
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => CustomDialog()),
                              // );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFFFA500)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Add description',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    showTextField
                                        ? CupertinoIcons.minus_circle
                                        : CupertinoIcons.plus_circle,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (showTextField)
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Container(
                          width: w * 0.88,
                          constraints: BoxConstraints(minHeight: 55),
                          // Set minimum height
                          child: TextFormField(
                            controller: _descriptionController,
                            maxLines: null,
                            // Allows the TextFormField to expand vertically
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 10),
                              // Adjust the padding as needed
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: CustomColors
                                      .orangeColor, // Default border color
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: CustomColors
                                      .orangeColor, // Border color when focused
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors
                                      .yellow, // Border color when enabled
                                ),
                              ),
                              labelText: 'Description',
                              alignLabelWithHint: true,
                              // Aligns the label with the hint text
                              suffixIcon: IconButton(
                                icon: Icon(Icons.send,
                                    color: CustomColors.orangeColor),
                                onPressed: () {
                                  setState(() {
                                    showTextField = !showTextField;
                                  });
                                },
                              ),
                            ),
                            textInputAction: TextInputAction
                                .newline, // Changes the action to a newline
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
