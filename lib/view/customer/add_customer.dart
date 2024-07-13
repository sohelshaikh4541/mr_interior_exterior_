import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interior_v_1/api/apiServices.dart';
import 'package:interior_v_1/model/lead_sources.dart';
import 'package:interior_v_1/view/customer/customer_list.dart';
import 'package:interior_v_1/view/homepage/homepage.dart';
import 'package:interior_v_1/widget/text_form_y.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/bottom_nav_bar.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> _response = {};

  String name = '',
      mobileNo = '',
      email = '',
      pincode = '',
      address = '',
      city = '',
      state = '',
      sources = '',
      userId = '',
      partner = '';

  DropdownItem? _selectedPartner;
  DropdownItem? _selectedSources;
  int? _selectedSourceId;
  DropdownItem? _selectedCity;
  DropdownItem? _selectedState;
  int? _selectedStateId;
  bool _isCityEnabled = false;

  bool _showErrors = false;
  bool _partnerError = false;
  bool _sourcesError = false;
  bool _cityError = false;
  bool _stateError = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      userId = sp.getString('userid') ?? '';
    });
  }

  Future<List<DropdownItem>> _fetchCity(String filter, int stateId) async {
    final citieslist = await StatesServices().getCities(stateId);
    if (citieslist.status != true) {
      return [DropdownItem(id: -1, name: 'No data found')];
    }

    final cities = citieslist.cities ?? [];
    if (filter.isEmpty) {
      return cities
          .map((city) =>
              DropdownItem(id: city.id!, name: city.name ?? 'Unknown Source'))
          .toList();
    } else {
      return cities
          .where((city) =>
              city.name != null &&
              city.name!.toLowerCase().contains(filter.toLowerCase()))
          .map((city) => DropdownItem(id: city.id!, name: city.name!))
          .toList();
    }
  }

  Future<List<DropdownItem>> _fetchLeadSources(String filter) async {
    final leadSources = await StatesServices().getLeadSource();
    if (leadSources.status != true) {
      return [DropdownItem(id: -1, name: 'No data found')];
    }

    final sources = leadSources.sources ?? [];
    if (filter.isEmpty) {
      return sources
          .map((source) => DropdownItem(
              id: source.id!, name: source.name ?? 'Unknown Source'))
          .toList();
    } else {
      return sources
          .where((source) =>
              source.name != null &&
              source.name!.toLowerCase().contains(filter.toLowerCase()))
          .map((source) => DropdownItem(id: source.id!, name: source.name!))
          .toList();
    }
  }

  Future<List<DropdownItem>> _fetchState(String filter) async {
    final statelist = await StatesServices().getStates();
    if (statelist.status != true) {
      return [DropdownItem(id: -1, name: 'No data found')];
    }

    final states = statelist.states ?? [];
    if (filter.isEmpty) {
      return states
          .map((state) =>
              DropdownItem(id: state.id!, name: state.name ?? 'Unknown Source'))
          .toList();
    } else {
      return states
          .where((state) =>
              state.name != null &&
              state.name!.toLowerCase().contains(filter.toLowerCase()))
          .map((state) => DropdownItem(id: state.id!, name: state.name!))
          .toList();
    }
  }

  Future<void> _addClient() async {
    setState(() {
      isLoading = true;
    });

    name = _fullNameController.text.trim();
    mobileNo = _mobileController.text.trim();
    email = _emailController.text.trim();
    pincode = _pincodeController.text.trim();
    address = _addressController.text.trim();
    city = _selectedCity.toString();
    state = _selectedState.toString();
    sources = _selectedSourceId.toString();

    StatesServices statesServices = StatesServices();
    Map<String, dynamic> response = await statesServices.addClient(
        userId, name, email, mobileNo, address, pincode, city, state, sources);

    setState(() {
      _response = response;
      isLoading = false;
    });

    _showResponseAlert(response);
  }

  void _showResponseAlert(Map<String, dynamic> response) {
    bool status = response['status'] ?? false;
    String title = status ? "Done!" : "Ohh..!";
    _fullNameController.clear();
    _mobileController.clear();
    _emailController.clear();
    _addressController.clear();
    _selectedState = null;
    _selectedCity = null;
    _selectedSources = null;
    _selectedSourceId = null;
    _selectedPartner = null;
    _isCityEnabled = false;
    _clearErrors();
    Alert(
      context: context,
      type: status ? AlertType.success : AlertType.info,
      title: title,
      content: Center(
          child: Text(
        response['message'],
        style: TextStyle(fontSize: 18),
      )),
      buttons: [
        DialogButton(
          child: Text(
            "OKAY",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.push(
            context,
            status
                ? MaterialPageRoute(builder: (context) => CustomerList())
                : MaterialPageRoute(builder: (context) => AddCustomer()),
          ),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
          width: 120,
        )
      ],
    ).show();
  }

  void _submitForm() {
    setState(() {
      _showErrors = true;
      _sourcesError = _selectedSources == null;
      _cityError = _selectedCity == null;
      _stateError = _selectedState == null;
    });

    // if (_endDateController.text.isEmpty) {
    //   setState(() {
    //     errorMessage = 'Please select a date';
    //   });
    // } else {
    //   setState(() {
    //     errorMessage = '';
    //   });
    // }

    bool _fullNameValid = _fullNameController.text.isNotEmpty;
    bool _mobileValid = _mobileController.text.isNotEmpty &&
        RegExp(r'^[6-9]\d{9}$').hasMatch(_mobileController.text);
    bool _addressValid = _addressController.text.isNotEmpty;

    bool _formValid = _fullNameValid &&
        _mobileValid &&
        _addressValid &&
        _selectedSources != null;
    _selectedCity != null;
    _selectedState != null;

    if (_formValid && _formKey.currentState!.validate()) {
      print("65765757");
      _addClient();
    }
  }

  void _clearErrors() {
    setState(() {
      _showErrors = false;
      _partnerError = false;
      _sourcesError = false;
      _cityError = false;
      _stateError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Client',style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Color(0xFFFFA500),
        elevation: 5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavBar(),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '   Add Client',
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
                  CustomTextField(
                    controller: _fullNameController,
                    hintText: 'Full Name',
                    icon: CupertinoIcons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Full Name';
                      }
                      return null;
                    },
                    showError: _showErrors,
                    keyboardType: TextInputType.text,
                    maxLength: 100,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: _mobileController,
                    hintText: 'Mobile Number',
                    icon: CupertinoIcons.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Mobile No';
                      }
                      if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                        return 'Please Enter a Valid 10-Digit Mobile Number';
                      }
                      return null;
                    },
                    showError: _showErrors,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.text,
                    maxLength: 100,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: _addressController,
                    hintText: 'Address',
                    icon: CupertinoIcons.location,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Address';
                      }
                      return null;
                    },
                    showError: _showErrors,
                    keyboardType: TextInputType.text,
                    maxLength: 100,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: _pincodeController,
                    hintText: 'Pin Code',
                    icon: Icons.pin_drop_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Pin Code';
                      }
                      return null;
                    },
                    showError: _showErrors,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_stateError)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 4),
                          child: Text(
                            'Please select a State',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      if (_stateError) SizedBox(height: 5),
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
                              hintText: "Select State",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Color(0x4CFFA500), width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Color(0x4CFFA500), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
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
                              _selectedState = value;
                              _selectedStateId = value?.id;
                              _stateError = false;
                              _isCityEnabled = value != null;
                            });
                          },
                          selectedItem: _selectedState,
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Color(0xFFFFA500), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Color(0xFFFFA500), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Color(0xFFFFA500), width: 1),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                hintText: "Search State",
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
                            return await _fetchState(filter);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_cityError)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 4),
                          child: Text(
                            'Please Select a City',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      if (_cityError) SizedBox(height: 5),
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
                        child: IgnorePointer(
                          ignoring: !_isCityEnabled,
                          child: DropdownSearch<DropdownItem>(
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                hintText: _isCityEnabled
                                    ? "Select City"
                                    : "Please select a State first",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Color(0x4CFFA500), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Color(0x4CFFA500), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Color(0x4CFFA500), width: 1),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.only(left: 20),
                                hintStyle: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              baseStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            onChanged: (DropdownItem? value) {
                              setState(() {
                                _selectedCity = value;
                                _cityError = false;
                              });
                            },
                            selectedItem: _selectedCity,
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: Color(0xFFFFA500), width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: Color(0xFFFFA500), width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: Color(0xFFFFA500), width: 1),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  hintText: "Search City",
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
                              if (_selectedState == null) {
                                return [
                                  DropdownItem(
                                      id: -1,
                                      name: 'Please select a State first')
                                ];
                              }
                              return await _fetchCity(
                                  filter, _selectedState!.id!);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_sourcesError)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 4),
                          child: Text(
                            'Please select a Lead Source',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      if (_sourcesError) SizedBox(height: 5),
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
                              hintText: "Select Sources",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Color(0x4CFFA500), width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Color(0x4CFFA500), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
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
                              _selectedSources = value;
                              _sourcesError = false;
                              _selectedSourceId = value?.id;
                            });
                          },
                          selectedItem: _selectedSources,
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Color(0xFFFFA500), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Color(0xFFFFA500), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Color(0xFFFFA500), width: 1),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                hintText: "Search Sources",
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
                            return await _fetchLeadSources(filter);
                          },
                        ),
                      ),
                    ],
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
                        onPressed: _submitForm,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFFFFA500)),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (states) {
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
                              side: BorderSide(
                                  color: Color(0x4CFFA500), width: 1),
                            ),
                          ),
                        ),
                        child: isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
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
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
