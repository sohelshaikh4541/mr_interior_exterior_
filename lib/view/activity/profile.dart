import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:interior_v_1/helper/image_controller_single.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ImageController controller = Get.put(ImageController());

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

  @override
  void initState() {
    super.initState();

    loadData();
  }

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
    controller.setImageUrl("https://myerpmie.in/images/interior_logo.png");
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              return Column(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        controller.getImage();
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        child: CircleAvatar(
                          backgroundImage: controller.imagePath.isNotEmpty
                              ? FileImage(File(controller.imagePath.value)) as ImageProvider<Object>
                              : controller.imageUrl.isNotEmpty
                              ? CachedNetworkImageProvider(controller.imageUrl.value)
                              : null,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.getImage();
                    },
                    child: Container(
                      width: 50,
                      height: 40,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(),
                      child: Icon(Icons.camera_alt),
                    ),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 14,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ],
              );
            }),
            Text(
              usertype,
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 10,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w300,
                height: 0,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 180),
              child: Text(
                'Personal Info',
                style: TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: 326,
              height: 231,
              decoration: ShapeDecoration(
                color: Color(0xFFF1E5E5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 22),
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Icon(CupertinoIcons.phone_fill),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(mobile),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Icon(Icons.email),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(email),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Icon(CupertinoIcons.location_circle_fill),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(address),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Icon(Icons.location_on),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(state),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Icon(Icons.pin),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(pin_code),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
