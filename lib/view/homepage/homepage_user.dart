import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:interior_v_1/helper/image_controller_single.dart';
import 'package:interior_v_1/view/activity/profile.dart';
import 'package:interior_v_1/view/addonwork/add_on_work.dart';
import 'package:interior_v_1/view/addonwork/add_on_work_history.dart';
import 'package:interior_v_1/view/customer/add_customer.dart';
import 'package:interior_v_1/view/customer/customer_list.dart';
import 'package:interior_v_1/view/lead/add_lead.dart';
import 'package:interior_v_1/view/lead/lead_list.dart';
import 'package:interior_v_1/view/order/order_history.dart';
import 'package:interior_v_1/view/order/order_place.dart';
import 'package:interior_v_1/view/project/add_project.dart';
import 'package:interior_v_1/view/project/assign_project.dart';
import 'package:interior_v_1/view/project/project_list.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shared_preferences/shared_preferences.dart';

import '../payment/add_payments.dart';
import '../payment/payments_history.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({Key? key});

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  ImageController controller = Get.put(ImageController());

  void _navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  String name = '',
      mobile = '',
      email = '',
      gender = '',
      usertype = '',
      address = '',
      city = '',
      state = '',
      pin_code = '',
      profile_pic = '';

  loadData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      name = sp.getString('name') ?? '';
      mobile = sp.getString('mobile') ?? '';
      email = sp.getString('email') ?? '';
      gender = sp.getString('gender') ?? '';
      usertype = sp.getString('usertype') ?? '';
      address = sp.getString('address') ?? '';
      city = sp.getString('city') ?? '';
      state = sp.getString('state') ?? '';
      pin_code = sp.getString('pin_code') ?? '';
      profile_pic = sp.getString('profile_pic') ?? '';
    });
    print(email);
  }

  int _currentPage = 0;
  PageController _pageTopController = PageController();

  final List<String> bannerImages = [
    'assets/images/temp.png',
    'assets/images/temp.png',
    'assets/images/temp.png',
  ];

  late Timer _timer;

  @override
  void initState() {
    super.initState();

    loadData();
    _pageTopController = PageController(initialPage: _currentPage);

    _startTimer();
  }

  @override
  void dispose() {
    _pageTopController.dispose();

    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < bannerImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageTopController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Interior',style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Color(0xFFFFA500),
        elevation: 5,
        actions: [
          badges.Badge(
            badgeContent: Text('5'),
            position: badges.BadgePosition.topEnd(top: 0, end: 7),
            child: Padding(
              padding: const EdgeInsets.only(right: 7),
              child: IconButton(
                iconSize: 27,
                icon: Icon(Icons.notifications_none),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.transparent),
                currentAccountPicture: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  },
                  child: Obx(() {
                    return Column(
                      children: [
                        Center(
                          child: Container(
                            height: 72,
                            width: 80,
                            child: CircleAvatar(
                              backgroundImage: controller.imagePath.isNotEmpty
                                  ? FileImage(
                                      File(controller.imagePath.toString()))
                                  : null,
                            ),
                          ),
                        )
                      ],
                    );
                  }),
                ),
                accountName: Text(
                  name,
                  style:
                      TextStyle(color: Colors.black87, fontSize: 16, height: 1),
                ),
                accountEmail: Text(
                  email,
                  style:
                      TextStyle(color: Colors.black87, fontSize: 16, height: 1),
                )),
            ExpansionTileGroup(children: [
              ExpansionTileWithoutBorderItem(
                title: Row(
                  children: [
                    Image(
                      image: AssetImage('assets/images/customer_add.png'),
                    ),
                    SizedBox(width: 10),
                    Text('Client'),
                  ],
                ),
                expendedBorderColor: Colors.black,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddCustomer()),
                          );
                        },
                        child:
                            Text('Add Client', style: TextStyle(fontSize: 16))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30, top: 9, bottom: 5),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerList()),
                          );
                        },
                        child: Text('Client List',
                            style: TextStyle(fontSize: 16))),
                  ),
                ],
              ),
              ExpansionTileWithoutBorderItem(
                title: Row(
                  children: [
                    Image(
                      image: AssetImage('assets/images/sales_add.png'),
                    ),
                    SizedBox(width: 10),
                    Text('Lead'),
                  ],
                ),
                expendedBorderColor: Colors.black,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddLead()),
                          );
                        },
                        child:
                            Text('Add Lead', style: TextStyle(fontSize: 16))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30, top: 9, bottom: 5),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LeadList()),
                          );
                        },
                        child:
                            Text('Lead List', style: TextStyle(fontSize: 16))),
                  ),
                ],
              ),
              ExpansionTileWithoutBorderItem(
                title: Row(
                  children: [
                    Image(
                      image: AssetImage('assets/images/sales_add.png'),
                    ),
                    SizedBox(width: 10),
                    Text('Sales'),
                  ],
                ),
                expendedBorderColor: Colors.black,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddSales()),
                          );
                        },
                        child:
                            Text('Add Sales', style: TextStyle(fontSize: 16))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30, top: 9, bottom: 5),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SalesHistory()),
                          );
                        },
                        child:
                            Text('Sales List', style: TextStyle(fontSize: 16))),
                  ),
                ],
              ),
              ExpansionTileWithoutBorderItem(
                title: Row(
                  children: [
                    Image(
                      image: AssetImage('assets/images/project_add.png'),
                    ),
                    SizedBox(width: 10),
                    Text('Manage Project'),
                  ],
                ),
                expendedBorderColor: Colors.black,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 30,
                    ),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddProject()),
                          );
                        },
                        child: Text('Add Project',
                            style: TextStyle(fontSize: 16))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 30,
                      top: 9,
                    ),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AssignProject()),
                          );
                        },
                        child: Text('Assign Project',
                            style: TextStyle(fontSize: 16))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30, top: 9, bottom: 5),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProjectList()),
                          );
                        },
                        child: Text('Project List',
                            style: TextStyle(fontSize: 16))),
                  ),
                ],
              ),
              ExpansionTileWithoutBorderItem(
                title: Row(
                  children: [
                    Image(
                      image: AssetImage('assets/images/payment_add.png'),
                    ),
                    SizedBox(width: 10),
                    Text('Payments'),
                  ],
                ),
                expendedBorderColor: Colors.black,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddOnWork()),
                          );
                        },
                        child: Text('Add Payments',
                            style: TextStyle(fontSize: 16))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30, top: 9, bottom: 5),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddOnWorkHistory()),
                          );
                        },
                        child: Text('Payments History',
                            style: TextStyle(fontSize: 16))),
                  ),
                ],
              ),
              ExpansionTileWithoutBorderItem(
                title: Row(
                  children: [
                    Image(
                      image: AssetImage('assets/images/package_add.png'),
                    ),
                    SizedBox(width: 10),
                    Text('Package'),
                  ],
                ),
                expendedBorderColor: Colors.black,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30, bottom: 5),
                    child: Text('All Package', style: TextStyle(fontSize: 16)),
                  ),
                ], // Empty list
              ),
              ExpansionTileWithoutBorderItem(
                title: Row(
                  children: [
                    Icon(
                      CupertinoIcons.purchased_circle,
                      size: 28,
                    ),
                    SizedBox(width: 10),
                    Text('Order'),
                  ],
                ),
                expendedBorderColor: Colors.black,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 30,
                      top: 9,
                    ),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderPlaced()),
                          );
                        },
                        child: Text('Order Material',
                            style: TextStyle(fontSize: 16))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30, top: 9, bottom: 5),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderHistory()),
                          );
                        },
                        child: Text('Order History',
                            style: TextStyle(fontSize: 16))),
                  ),
                ],
              ),
              ExpansionTileWithoutBorderItem(
                title: Row(
                  children: [
                    Icon(
                      CupertinoIcons.purchased_circle,
                      size: 28,
                    ),
                    SizedBox(width: 10),
                    Text('Logout'),
                  ],
                ),
                expendedBorderColor: Colors.black,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 30,
                      top: 9,
                    ),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderPlaced()),
                          );
                        },
                        child: Text('Logout', style: TextStyle(fontSize: 16))),
                  ),
                ],
              ),
            ]),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                'Welcome Back!',
                style: TextStyle(
                  color: Color(0xFF2A2828),
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 32, top: 5),
                child: Text(
                  'Hi, $name',
                  style: TextStyle(
                    color: Color(0xFF959393),
                    fontSize: 11,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 1.1,
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  height: h * 0.25,
                  width: double.infinity,
                  child: PageView.builder(
                    controller: _pageTopController,
                    itemCount: bannerImages.length,
                    onPageChanged: (int index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 0.0),
                        child: Image.asset(
                          bannerImages[index],
                          fit: BoxFit.fill,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
