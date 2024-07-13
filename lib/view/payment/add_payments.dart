import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:interior_v_1/api/apiServices.dart';
import 'package:interior_v_1/model/lead_sources.dart';
import 'package:interior_v_1/widget/text_form_y.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/custome_colour.dart';
import '../../helper/location_widget.dart';
import '../project/project_list.dart';

class AddSales extends StatefulWidget {
  const AddSales({super.key});

  @override
  State<AddSales> createState() => _AddSalesState();
}

class _AddSalesState extends State<AddSales> {
  late TextEditingController _endDateController = TextEditingController();
  late TextEditingController _projectNameController = TextEditingController();
  late TextEditingController _flatNoController = TextEditingController();
  late TextEditingController _addressController = TextEditingController();
  late TextEditingController _priceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController = TextEditingController();
  late TextEditingController _pincodeController = TextEditingController();

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  String errorMessage = '';
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();
  String gpsLocation = '';

  DropdownItem? _selectedClient;
  DropdownItem? _selectedPackage;
  int? _selectedPackageId;
  String? _selectedPackagePrice;
  int? _selectedClientId;
  bool _showErrors = false;
  bool _packageError = false;
  bool _packagePriceError = false;
  bool _clientError = false;
  bool _cityError = false;
  bool _packageTypeError = false;
  bool _isProjectEnabled = false;

  String errorDesMessage = '';
  bool isLoading = false;
  DropdownItem? _selectedState;
  int? _selectedStateId;
  bool _stateError = false;
  bool _isCityEnabled = false;
  bool _isPropertyEnabled = false;
  DropdownItem? _selectedCity;
  DropdownItem? _selectedProperty;
  final List<String> noteTypes = [
    'Rs. 50',
    'Rs. 100',
    'Rs. 200',
    'Rs. 500',
    'Rs. 2000'
  ];
  final Map<String, int> selectedNotes = {};
  String? _selectedNoteType;
  String clientId = '',
      projectName = '',
      address = '',
      date = '',
      price = '',
      packageId = '',
      description = '',
      zip = '',
      state = '',
      city = '',
      projectType = '',
      userId = '';

  final LocationService _locationService = LocationService();
  Position? _currentPosition;
  bool _locStatus = false;
  String? _currentAddress;

  void _showNoteCountDialog(BuildContext context, String noteType) {
    final TextEditingController noteCountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter No Of $noteType Notes'),
          backgroundColor: Colors.orange.shade50,
          content: TextField(
            controller: noteCountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Number of Notes',
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide:
                BorderSide(color: Colors.orange), // Change border color
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide:
                BorderSide(color: Colors.orange), // Change border color
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide:
                BorderSide(color: Colors.orange), // Change border color
              ),
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedNotes[noteType] =
                        int.parse(noteCountController.text);
                    _selectedNoteType = noteType;
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  Future<List<DropdownItem>> _fetchProject(String filter, int client) async {
    final projectlist = await StatesServices().getProjectDD(client.toString());
    if (projectlist.status != true) {
      print('NewPackage${projectlist.data}');
      return [DropdownItem(id: -1, name: 'No data found')];
    }

    final projects = projectlist.data ?? [];
    if (filter.isEmpty) {
      return projects
          .map((project) => DropdownItem(
          id: project.id!, name: project.projectName ?? 'Unknown Package'))
          .toList();
    } else {
      return projects
          .where((project) =>
      project.projectName != null &&
          project.projectName!.toLowerCase().contains(filter.toLowerCase()))
          .map((project) => DropdownItem(
        id: project.id!,
        name: project.projectName!,
      ))
          .toList();
    }
  }
  Future<void> _fetchLocation() async {
    try {
      Position position = await _locationService.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });

      String address = await _locationService.getAddressFromLatLng(position);
      setState(() {
        _currentAddress = address;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _addProject() async {
    setState(() {
      isLoading = true;
    });

    clientId = _selectedClientId.toString();
    projectName = _projectNameController.text.trim();
    address = _addressController.text.trim();
    date = _endDateController.text.trim();
    price = _priceController.text.trim();
    packageId = _selectedPackageId.toString();
    zip = _pincodeController.text.trim();
    state = _selectedState.toString();
    city = _selectedCity.toString();
    description = _descriptionController.text.trim();

    print('41105 $zip');

    StatesServices statesServices = StatesServices();
    Map<String, dynamic> response = await statesServices.addProject(
        userId,
        clientId,
        projectName,
        address,
        zip,
        city,
        state,
        date,
        price,
        packageId,
        description);

    Map<String, dynamic> _response = {};

    setState(() {
      _response = response;
      isLoading = false;
    });

    _showResponseAlert(response);
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

    print('41105 $zip');

    StatesServices statesServices = StatesServices();
    Map<String, dynamic> response =
    await statesServices.getPrice(userId, packageId, projectType);

    Map<String, dynamic> _response = {};

    setState(() {
      _response = response;
      isLoading = false;
      _priceController = TextEditingController(text: response['data']['price']);
    });
  }

  void _showResponseAlert(Map<String, dynamic> response) {
    bool status = response['status'] ?? false;
    String title = status ? "Done!" : "Ohh..!";
    _endDateController.clear();
    _addressController.clear();
    _pincodeController.clear();
    _flatNoController.clear();
    _selectedPackage = null;
    _selectedCity = null;
    _selectedState = null;
    _selectedClient = null;

    // _clearErrors();
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
                ? MaterialPageRoute(builder: (context) => ProjectList())
                : MaterialPageRoute(builder: (context) => ProjectList()),
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

  void _submitForm() {
    setState(() {
      _showErrors = true;
      _packageError = _selectedPackage == null;
      _clientError = _selectedClient == null;
      _cityError = _selectedCity == null;
      _packageTypeError = _selectedProperty == null;
      _stateError = _selectedState == null;
    });

    if (_endDateController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please select a date';
      });
    } else {
      setState(() {
        errorMessage = '';
      });
    }

    if (_descriptionController.text.isEmpty) {
      setState(() {
        errorDesMessage = 'Please enter description';
      });
    } else {
      setState(() {
        errorDesMessage = '';
      });
    }

    bool _projectNameValid = _projectNameController.text.isNotEmpty;
    bool _flatNoValid = _flatNoController.text.isNotEmpty;
    bool _addressValid = _addressController.text.isNotEmpty;
    bool _priceValid = _selectedPackagePrice.toString().isNotEmpty;
    bool _pincodeValid = _pincodeController.text.isNotEmpty;

    bool _formValid = _projectNameValid &&
        _flatNoValid &&
        _addressValid &&
        _priceValid &&
        _pincodeValid &&
        _selectedPackage != null;
    _selectedProperty != null;
    _selectedClient != null;
    _selectedCity != null;
    _selectedState != null;

    if (_formValid && _formKey.currentState!.validate()) {
      _addProject();
    }
  }

  Future<List<DropdownItem>> _fetchClient(String filter) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      userId = sp.getString('userid') ?? '';
    });

    final clients = await StatesServices().getClient(userId);
    if (clients.status != true) {
      return [DropdownItem(id: -1, name: 'No data found')];
    }
    final client = clients.clients ?? [];
    if (filter.isEmpty) {
      return client
          .map((client) => DropdownItem(
          id: client.id!, name: client.name ?? 'Unknown Source'))
          .toList();
    } else {
      return client
          .where((client) =>
      client.name != null &&
          client.name!.toLowerCase().contains(filter.toLowerCase()))
          .map((client) => DropdownItem(id: client.id!, name: client.name!))
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
          .map((package) => DropdownItem(
        id: package.id!,
        name: package.name!,
      ))
          .toList();
    }
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
      errorMessage = '';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment',style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: const Color(0xFFFFA500),
        elevation: 5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
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
                      '   Add Payment',
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_clientError)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 4),
                          child: Text(
                            'Please select a Client',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      if (_clientError) SizedBox(height: 5),
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
                              hintText: "Select Client",
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
                              _selectedClient = value;
                              _selectedClientId = value?.id;
                              _clientError = false;
                              _isProjectEnabled = value != null;
                            });
                          },
                          selectedItem: _selectedClient,
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
                                hintText: "Search Client",
                              ),
                            ),
                            itemBuilder: (context, item, isSelected) {
                              return ListTile(
                                title: Text(item.name.toUpperCase(),
                                    style: TextStyle(fontSize: 14)),
                                selected: isSelected,
                              );
                            },
                          ),
                          asyncItems: (String filter) async {
                            return await _fetchClient(filter);
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
                      if (_packageError)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 4),
                          child: Text(
                            'Please select a Project',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      if (_packageError) SizedBox(height: 5),
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
                          ignoring: !_isProjectEnabled,
                          child: DropdownSearch<DropdownItem>(
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                hintText: _isProjectEnabled
                                    ? "Select Project"
                                    : "Please select a Client first",
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
                                  hintText: "Search Project",
                                ),
                              ),
                              itemBuilder: (context, item, isSelected) {
                                return ListTile(
                                  title: Text(item.name,
                                      style: TextStyle(fontSize: 14)),
                                  selected: isSelected,
                                );
                              },
                              constraints: BoxConstraints(
                                maxHeight:
                                300, // Set your desired maximum height here
                              ),
                            ),
                            asyncItems: (String filter) async {
                              if (_selectedClient == null) {
                                return [
                                  DropdownItem(
                                      id: -1,
                                      name: 'Please select a Client first')
                                ];
                              }
                              return await _fetchProject(
                                  filter, _selectedClient!.id);
                            },
                          ),
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
                            'Please Select a Payment Stage',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      if (_packageTypeError) SizedBox(height: 5),
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
                          ignoring: !_isPropertyEnabled,
                          child: DropdownSearch<DropdownItem>(
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                hintText: _isPropertyEnabled
                                    ? "Select Payment Stage"
                                    : "Please select a Project first",
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
                                _selectedProperty = value;
                                _packageTypeError = false;
                                _postPrice();
                                if (_selectedProperty.toString().isNotEmpty) {
                                  _packagePriceError = true;
                                }
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
                                  hintText: "Search Project Type",
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
                                      id: -1,
                                      name: 'Please select a Project first')
                                ];
                              }
                              return await _fetchProperty(filter);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_packagePriceError)
                    SizedBox(
                      height: 10,
                    ),
                  if (_packagePriceError)
                    CustomTextField(
                      controller: _priceController,
                      hintText: '',
                      icon: Icons.currency_rupee,
                      editable: false,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                    ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: _projectNameController,
                    hintText: 'Payment Stage',
                    icon: Icons.add_chart_sharp,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Payment Stage';
                      }
                      return null;
                    },
                    showError: _showErrors,
                    maxLength: 100,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: _projectNameController,
                    hintText: 'Due Amount',
                    icon: Icons.currency_rupee_rounded,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Due Amount';
                      }
                      return null;
                    },
                    showError: _showErrors,
                    maxLength: 100,
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_clientError)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 4),
                          child: Text(
                            'Please select a Payment Mode',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      if (_clientError) SizedBox(height: 5),
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
                              hintText: "Select Payment Mode",
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
                              _selectedClient = value;
                              _selectedClientId = value?.id;
                              _clientError = false;
                            });
                          },
                          selectedItem: _selectedClient,
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
                                hintText: "Search Payment Mode",
                              ),
                            ),
                            itemBuilder: (context, item, isSelected) {
                              return ListTile(
                                title: Text(item.name.toUpperCase(),
                                    style: TextStyle(fontSize: 14)),
                                selected: isSelected,
                              );
                            },
                          ),
                          asyncItems: (String filter) async {
                            return await _fetchClient(filter);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
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
                    child: DropdownSearch<String>(
                      items: noteTypes,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          hintText: "Select Notes",
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
                        baseStyle:
                        TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          _showNoteCountDialog(context, newValue);
                        }
                      },
                      selectedItem: _selectedNoteType,
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
                            hintText: "Search Notes",
                          ),
                        ),
                        itemBuilder: (context, item, isSelected) {
                          return ListTile(
                            title:
                            Text(item, style: TextStyle(fontSize: 16)),
                            trailing: Checkbox(
                              value: selectedNotes.containsKey(item),
                              onChanged: (bool? checked) {
                                if (checked == true) {
                                  _showNoteCountDialog(context, item);
                                } else {
                                  setState(() {
                                    selectedNotes.remove(item);
                                  });
                                }
                              },
                            ),
                            selected: isSelected,
                          );
                        },
                        constraints: BoxConstraints(
                          maxHeight: 350,
                        ),
                      ),
                    ),
                  ),
                  ...selectedNotes.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${entry.key} Note',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'No of Notes: ${entry.value}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 4),
                          child: Text(
                            errorMessage,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      Container(
                        height: 48,
                        width: w * 0.9,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side:
                            BorderSide(width: 1, color: Color(0x4CFFA500)),
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
                        child: Stack(
                          children: [
                            Positioned(
                              left: 3,
                              top: 4,
                              child: Container(
                                width: 30,
                                height: 30,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(),
                                child: IconButton(
                                  icon: Icon(CupertinoIcons.calendar_today),
                                  onPressed: () {
                                    _selectToDate(context);
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 42, right: 10),
                              child: TextFormField(
                                controller: _endDateController,
                                readOnly: true,
                                onTap: () {
                                  _selectToDate(context);
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Select Date',
                                  hintStyle: TextStyle(
                                      fontSize: 16, fontFamily: 'Roboto'),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 13, horizontal: 6.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 250),
                        height: _isFocused ? h * 0.14 : h * 0.056,
                        width: w * 0.9,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _isFocused
                                ? CustomColors.orangeColor
                                : CustomColors.yellowBorderColor,
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _descriptionController,
                          onChanged: (text) {
                            setState(() {
                              if (text.length >= 1) {
                                errorDesMessage = '';
                              }
                            });
                          },
                          style: TextStyle(fontSize: 17, color: Colors.black),
                          focusNode: _focusNode,
                          textAlign: TextAlign.justify,
                          maxLength: 125,
                          decoration: InputDecoration(
                            hintText: 'Enter Description',
                            hintStyle: TextStyle(
                              fontSize: 17,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Colors.white,
                            isDense: true,
                            counterText: '',
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.description,
                                size: 24,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 0.0),
                          ),
                          minLines: 4,
                          maxLines: null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
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
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
