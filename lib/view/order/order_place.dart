import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interior_v_1/api/apiServices.dart';
import 'package:interior_v_1/helper/image_controller_multiple.dart';
import 'package:interior_v_1/helper/image_controller_single.dart';
import 'package:interior_v_1/view/homepage/homepage.dart';
import 'package:interior_v_1/view/customer/add_customer.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../model/lead_sources.dart';

class OrderPlaced extends StatefulWidget {
  const OrderPlaced({super.key});

  @override
  State<OrderPlaced> createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  ImageControllerMulti controller = Get.put(ImageControllerMulti());

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  Future<void> _selectFromDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      String formattedDate = "${picked.day}-${picked.month}-${picked.year}";
      _startDateController.text = formattedDate;
      setState(() {});
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      String formattedDate = "${picked.day}-${picked.month}-${picked.year}";
      _endDateController.text = formattedDate;
      setState(() {});
    }
  }

  DropdownItem? _selectedProject;

  Future<List<DropdownItem>> _fetchProject(String filter) async {
    final packagelist = await StatesServices().getPackages("");
    if (packagelist.data != true) {
      return [DropdownItem(id: -1, name: 'No data found')];
    }

    final packagee = packagelist.data ?? [];
    if (filter.isEmpty) {
      return packagee
          .map((package) =>
          DropdownItem(id: package.id!, name: package.name ?? 'Unknown Source'))
          .toList();
    } else {
      return packagee
          .where((package) =>
      package.name != null &&
          package.name!.toLowerCase().contains(filter.toLowerCase()))
          .map((package) => DropdownItem(id: package.id!, name: package.name!))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order',style: TextStyle(fontWeight: FontWeight.bold),),
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '   Order Material',
                    style: TextStyle(
                      color: Color(0xFF2A2828),
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 48,
                  width: w * 0.903,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: DropdownSearch<DropdownItem>(
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: "Select Package",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                          BorderSide(color: Color(0x4CFFA500), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                          BorderSide(color: Color(0x4CFFA500), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                          BorderSide(color: Color(0x4CFFA500), width: 1),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.only(
                          left: 20,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    onChanged: (DropdownItem? value) {
                      setState(() {
                        _selectedProject = value;
                      });
                    },
                    selectedItem: _selectedProject,
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                            BorderSide(color: Color(0xFFFFA500), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                            BorderSide(color: Color(0xFFFFA500), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                            BorderSide(color: Color(0xFFFFA500), width: 1),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          hintText: "Search Package",
                        ),
                      ),
                      itemBuilder: (context, item, isSelected) {
                        return ListTile(
                          title: Text(item.name, style: TextStyle(fontSize: 14)),
                          selected: isSelected,
                        );
                      },
                    ),
                    asyncItems: (String filter) async {
                      return await _fetchProject(filter);
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: w * 0.06),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Select Image',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'Roboto Regular',
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  width: w * 0.9,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0x4CFFA500)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (int index = 0;
                                    index < controller.imagePathsmulti.length;
                                    index++)
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.file(
                                          File(controller
                                              .imagePathsmulti[index]),
                                          width: 42,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            controller.imagePathsmulti
                                                .removeAt(index);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            padding: EdgeInsets.all(4),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.getImages();
                        },
                        child: Container(
                          width: 50,
                          height: 100,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Icon(Icons.camera_alt_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 150,
                    height: 50,
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFFFFA500)),
                        overlayColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Color(0xFF2B9EBFF).withOpacity(0.2);
                          } else {
                            return Colors.transparent;
                          }
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side:
                                BorderSide(color: Color(0x4CFFA500), width: 1),
                          ),
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
