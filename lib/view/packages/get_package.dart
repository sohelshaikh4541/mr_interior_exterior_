import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interior_v_1/helper/custome_colour.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/apiServices.dart';
import '../../dummy.dart';
import '../../helper/full_view_image.dart';
import '../../model/lead_sources.dart';
import '../../model/package_drop_model.dart';

class GetPackage extends StatefulWidget {
  const GetPackage({super.key});

  @override
  State<GetPackage> createState() => _GetPackageState();
}

class _GetPackageState extends State<GetPackage> {
  DropdownItem? _selectedCity;
  DropdownItem? _selectedPackage;
  int? _selectedPackageId;

  bool _packageError = false;
  bool _packageTypeError = false;
  bool _packageDetailsError = false;
  String errorDesMessage = '';
  bool isLoading = false;
  bool _isPropertyEnabled = false;
  DropdownItem? _selectedProperty;
  late PageController _pageOneController;
  Map<String, dynamic> _response = {};
  Future<List<String>>? bannerImagesFuture;
  int _currentPage = 0;
  late Timer _timer;

  String packageId = '', projectType = '', userId = '';

  @override
  void initState() {
    super.initState();
    _pageOneController = PageController(initialPage: _currentPage);
    loadData();
    _startTimer();
  }

  loadData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      userId = sp.getString('userid') ?? '';
      bannerImagesFuture = fetchBannerImages(userId);
    });
    print('getClients$userId');
  }

  @override
  void dispose() {
    _pageOneController.dispose();
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_pageOneController.hasClients) {
        int nextPage = _currentPage + 1;
        bannerImagesFuture?.then((bannerImages) {
          if (nextPage >= bannerImages.length) {
            nextPage = 0;
          }
          _pageOneController.animateToPage(
            nextPage,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          setState(() {
            _currentPage = nextPage;
          });
        });
      }
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  Future<List<String>> fetchBannerImages(String userId) async {
    StatesServices statesServices = StatesServices();
    List<String> bannerImages = [];
    try {
      List<dynamic> promotionalBanners = await statesServices.getPromotionalBanner(userId);
      for (var banner in promotionalBanners) {
        bannerImages.add('https://myerpmie.in/images/${banner['image']}');
      }
    } catch (e) {
      print(e);
    }
    return bannerImages;
  }

  Future<List<DropdownItem>> _fetchProperty(String filter) async {
    final propertytype = await StatesServices().getPropertyType("2");
    if (propertytype.status != true) {
      return [DropdownItem(id: -1, name: 'No data found')];
    }

    final property = propertytype.data ?? [];
    if (filter.isEmpty) {
      return property
          .map((propertyy) => DropdownItem(
              id: propertyy.id!, name: propertyy.name ?? 'Unknown Source'))
          .toList();
    } else {
      return property
          .where((propertyy) =>
              propertyy.name != null &&
              propertyy.name!.toLowerCase().contains(filter.toLowerCase()))
          .map((propertyy) =>
              DropdownItem(id: propertyy.id!, name: propertyy.name!))
          .toList();
    }
  }

  Future<List<DropdownItem>> _fetchPackage(String filter) async {
    final packagelist = await StatesServices().getPackages("2");
    if (packagelist.status != true) {
      print('NewPackage${packagelist.data}');
      return [DropdownItem(id: -1, name: 'No data found')];
    }

    final packagee = packagelist.data ?? [];
    if (filter.isEmpty) {
      return packagee
          .map((package) => DropdownItem(
              id: package.id!, name: package.name ?? 'Unknown Package'))
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

  Future<void> _postPrice() async {
    setState(() {
      isLoading = true;
    });

    packageId = _selectedPackageId.toString();
    projectType = _selectedProperty.toString();

    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      userId = sp.getString('userid') ?? '';
    });

    StatesServices statesServices = StatesServices();
    Map<String, dynamic> response =
        await statesServices.getPrice(userId, packageId, projectType);

    setState(() {
      _response = response;
      isLoading = false;
      _packageDetailsError = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Packages',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomColors.orangeColor,
                    fontSize: 24),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_packageError)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6, left: 4),
                      child: Text(
                        'Please select a Package',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  if (_packageError) SizedBox(height: 5),
                  Container(
                    height: 48,
                    width: w * 0.903,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
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
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide:
                                BorderSide(color: Color(0x4CFFA500), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide:
                                BorderSide(color: Color(0x4CFFA500), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
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
                        baseStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      onChanged: (DropdownItem? value) {
                        setState(() {
                          _selectedPackage = value;
                          _selectedPackageId = value?.id;
                          _isPropertyEnabled = value != null;
                          _packageError = false;
                        });
                      },
                      selectedItem: _selectedPackage,
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(
                                  color: Color(0xFFFFA500), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(
                                  color: Color(0xFFFFA500), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(
                                  color: Color(0xFFFFA500), width: 1),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            hintText: "Search Package",
                          ),
                        ),
                        itemBuilder: (context, item, isSelected) {
                          return ListTile(
                            title:
                                Text(item.name, style: TextStyle(fontSize: 14)),
                            selected: isSelected,
                          );
                        },
                        constraints: BoxConstraints(
                          maxHeight:
                              300, // Set your desired maximum height here
                        ),
                      ),
                      asyncItems: (String filter) async {
                        return await _fetchPackage(filter);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_packageTypeError)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6, left: 4),
                      child: Text(
                        'Please Select a Property Type',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  if (_packageTypeError) SizedBox(height: 5),
                  Container(
                    height: 48,
                    width: w * 0.903,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: IgnorePointer(
                      ignoring: !_isPropertyEnabled,
                      child: DropdownSearch<DropdownItem>(
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            hintText: _isPropertyEnabled
                                ? "Select Property Type"
                                : "Please select a Package first",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(
                                  color: Color(0x4CFFA500), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(
                                  color: Color(0x4CFFA500), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(
                                  color: Color(0x4CFFA500), width: 1),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.only(left: 20),
                            hintStyle:
                                TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          baseStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        onChanged: (DropdownItem? value) {
                          setState(() {
                            _selectedProperty = value;
                            _packageTypeError = false;
                            _postPrice();
                          });
                        },
                        selectedItem: _selectedCity,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                    color: Color(0xFFFFA500), width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                    color: Color(0xFFFFA500), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                    color: Color(0xFFFFA500), width: 1),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              hintText: "Search Property Type",
                            ),
                          ),
                          itemBuilder: (context, item, isSelected) {
                            return ListTile(
                              title: Text(item.name,
                                  style: TextStyle(fontSize: 14)),
                              selected: isSelected,
                            );
                          },
                        ),
                        asyncItems: (String filter) async {
                          if (_selectedPackage == null) {
                            return [
                              DropdownItem(
                                  id: -1, name: 'Please select a Package first')
                            ];
                          }
                          return await _fetchProperty(filter);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              if (_packageDetailsError)
                SizedBox(
                  height: 10,
                ),
              if (_packageDetailsError)
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: CustomColors.orangeColor,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: CustomColors.orangeColor, width: 1),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    _response != null && _response.containsKey('data') && _response['data'].containsKey('name')
                                        ? _response['data']['name']
                                        : 'No data found',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: CustomColors.orangeColor
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          _response != null && _response.containsKey('data') && _response['data'].containsKey('property_type') && _response['data']['property_type'] != null
                                              ? 'Property :- ${_response['data']['property_type']}'
                                              : 'Property :- No data found',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: CustomColors.orangeColor
                                          ),
                                        ),
                                        Text(
                                          _response != null && _response.containsKey('data') && _response['data'].containsKey('price') && _response['data']['price'] != null
                                              ? 'Price :- \u20B9${_response['data']['price']}'
                                              : 'Price :- No data found',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: CustomColors.orangeColor
                                          ),
                                        ),
                                      ]),
                                  SizedBox(height: 10),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 5),
                            child: Container(
                              height: 150,
                              width: screenWidth - 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: FutureBuilder<List<String>>(
                                  future: bannerImagesFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(child: Text('Error: ${snapshot.error}'));
                                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                      return Center(child: Text('No Banners Found'));
                                    } else {
                                      return PageView.builder(
                                        controller: _pageOneController,
                                        itemCount: snapshot.data!.length,
                                        onPageChanged: (int index) {
                                          setState(() {
                                            _currentPage = index;
                                          });
                                        },
                                        itemBuilder: (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => FullViewImage(
                                                    imageUrl: snapshot.data![index],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(15.0),
                                                child: Image.network(
                                                  snapshot.data![index],
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _response != null && _response.containsKey('data') && _response['data'].containsKey('description') && _response['data']['description'] != null
                                      ? '${_response['data']['description']}'
                                      : 'No data found',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
