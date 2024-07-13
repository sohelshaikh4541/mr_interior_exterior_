import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interior_v_1/helper/image_controller_single.dart';
import 'package:interior_v_1/view/activity/profile.dart';
import 'package:badges/badges.dart' as badges;
import 'package:interior_v_1/view/notification/notification.dart';
import 'package:interior_v_1/widget/users_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helper/custome_colour.dart';
import '../../widget/client_home.dart';
import '../../widget/drawer_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ImageController controller = Get.put(ImageController());

  void _navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  String
      userId='',
      name = '',
      mobile = '',
      email = '',
      gender = '',
      usertype = '',
      address = '',
      city = '',
      state = '',
      pin_code = '',
      profile_pic = '';

  @override
  void initState() {
    super.initState();

    loadData();
  }

  loadData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      userId = sp.getString('userid') ?? '';
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
    controller.setImageUrl("https://myerpmie.in/images/interior_logo.png");
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Notifications()),
                  );
                },
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
                                  ? FileImage(File(controller.imagePath.value)) as ImageProvider<Object>
                                  : controller.imageUrl.isNotEmpty
                                  ? CachedNetworkImageProvider(controller.imageUrl.value)
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
                      TextStyle(color: Colors.black87, fontSize: 16, height: 1,fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(
                  email,
                  style:
                      TextStyle(color: CustomColors.greyTextColor, fontSize: 16, height: 1),
                )),
            DrawerMenu(),
          ],
        ),
      ),
      body: userId == '1' ? UserHome(usertype: usertype, name: name) : ClientHome(usertype: usertype, name: name),
    );
  }
}
